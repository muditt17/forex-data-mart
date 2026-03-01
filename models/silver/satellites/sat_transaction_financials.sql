{{ config(materialized='incremental', unique_key='transaction_hk', incremental_strategy='merge') }}

with tx as (
  select
    {{ hash_key(['transaction_id']) }} as transaction_hk,
    transaction_id,
    transaction_ts,
    customer_id,
    branch_id,
    from_currency,
    to_currency,
    from_amount,
    exchange_rate,
    commission_fee,
    channel,
    status
  from {{ ref('transactions_raw') }}
  where transaction_id is not null
),
rates as (
  select base_currency, quote_currency, rate_ts, market_rate
  from {{ ref('fx_rates_raw') }}
),
rate_at_time as (
  select
    tx.transaction_hk,
    r.market_rate
  from tx
  left join rates r
    on tx.from_currency = r.base_currency
   and tx.to_currency = r.quote_currency
   and r.rate_ts <= tx.transaction_ts
  qualify row_number() over (partition by tx.transaction_hk order by r.rate_ts desc) = 1
)
select
  tx.transaction_hk,
  tx.transaction_id,
  tx.transaction_ts,
  {{ hash_key(['tx.customer_id']) }} as customer_hk,
  {{ hash_key(['tx.branch_id']) }} as branch_hk,
  {{ hash_key(['tx.from_currency']) }} as from_currency_hk,
  {{ hash_key(['tx.to_currency']) }} as to_currency_hk,
  tx.from_amount,
  (tx.from_amount * tx.exchange_rate) as to_amount,
  tx.exchange_rate as exchange_rate_applied,
  rat.market_rate as market_rate_at_time,
  case when rat.market_rate is null then null else (tx.exchange_rate - rat.market_rate) end as spread,
  tx.commission_fee,
  case when rat.market_rate is null then null else (tx.exchange_rate - rat.market_rate) * tx.from_amount end as spread_revenue,
  case
    when rat.market_rate is null then tx.commission_fee
    else ((tx.exchange_rate - rat.market_rate) * tx.from_amount) + tx.commission_fee
  end as net_revenue,
  tx.channel,
  tx.status,
  current_timestamp as load_date,
  {{ hashdiff(['tx.transaction_ts','tx.from_amount','tx.exchange_rate','tx.commission_fee','tx.channel','tx.status','rat.market_rate']) }} as hashdiff
from tx
left join rate_at_time rat
  on tx.transaction_hk = rat.transaction_hk

{% if is_incremental() %}
  qualify transaction_hk not in (select transaction_hk from {{ this }})
{% endif %}
