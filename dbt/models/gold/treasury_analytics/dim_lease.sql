{{ config(materialized='table') }}

select
  lease_hk as lease_sk,
  lease_id,
  {{ hash_key(['bank_id']) }} as bank_sk,
  {{ hash_key(['currency_code']) }} as currency_sk,
  lease_amount,
  interest_rate,
  lease_start,
  lease_end,
  lease_status
from {{ ref('sat_cash_lease_details') }}
where is_current = true
