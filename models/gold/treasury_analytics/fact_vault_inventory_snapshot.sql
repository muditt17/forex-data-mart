{{ config(materialized='table') }}

select
  to_number(to_char(stock_date,'YYYYMMDD')) as date_sk,
  {{ hash_key(['branch_id']) }} as branch_sk,
  {{ hash_key(['currency_code']) }} as currency_sk,
  branch_id,
  currency_code,
  opening_balance,
  closing_balance,
  (opening_balance - closing_balance) as net_outflow_amount
from {{ ref('vault_stock_raw') }}
