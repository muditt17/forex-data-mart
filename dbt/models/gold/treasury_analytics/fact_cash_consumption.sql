{{ config(materialized='table') }}

with inv as (
  select
    branch_id,
    currency_code,
    stock_date,
    opening_balance,
    closing_balance,
    (opening_balance - closing_balance) as total_sold_amount
  from {{ ref('sat_vault_stock_daily') }}
),
active_lease as (
  select
    lease_id,
    bank_id,
    currency_code,
    lease_amount,
    interest_rate,
    lease_start,
    lease_end
  from {{ ref('sat_cash_lease_details') }}
  where is_current = true
),
picked as (
  select
    inv.*,
    al.lease_id,
    al.bank_id,
    al.lease_amount
  from inv
  left join active_lease al
    on inv.currency_code = al.currency_code
   and inv.stock_date between al.lease_start and al.lease_end
)
select
  cast(to_char(stock_date,'YYYYMMDD') as integer) as date_sk,
  {{ hash_key(['branch_id']) }} as branch_sk,
  {{ hash_key(['currency_code']) }} as currency_sk,
  {{ hash_key(['bank_id']) }} as bank_sk,
  {{ hash_key(['lease_id']) }} as lease_sk,
  branch_id,
  currency_code,
  bank_id,
  lease_id,
  opening_balance,
  closing_balance,
  total_sold_amount,
  case when lease_amount is null or lease_amount = 0 then null else total_sold_amount / lease_amount end as consumption_rate
from picked