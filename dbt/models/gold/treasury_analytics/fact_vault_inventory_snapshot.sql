{{ config(materialized='table') }}

select
  cast(to_char(stock_date,'YYYYMMDD') as integer) as date_sk,
  branch_hk as branch_sk,
  currency_hk as currency_sk,
  branch_id,
  currency_code,
  opening_balance,
  closing_balance,
  (opening_balance - closing_balance) as net_outflow_amount,
  inflow_amount,
  outflow_amount
from {{ ref('sat_vault_stock_daily') }}