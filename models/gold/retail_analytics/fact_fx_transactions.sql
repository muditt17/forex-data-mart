{{ config(materialized='table') }}

select
  cast(to_char(s.transaction_ts,'YYYYMMDD') as integer) as date_sk,
  s.customer_hk as customer_sk,
  s.branch_hk as branch_sk,
  s.from_currency_hk as from_currency_sk,
  s.to_currency_hk as to_currency_sk,
  {{ hash_key(['s.channel']) }} as channel_sk,
  s.transaction_id,
  s.transaction_ts,
  s.from_amount,
  s.to_amount,
  s.exchange_rate_applied,
  s.market_rate_at_time,
  s.spread,
  s.commission_fee,
  s.spread_revenue,
  s.net_revenue,
  1 as transaction_count
from {{ ref('sat_transaction_financials') }} s
