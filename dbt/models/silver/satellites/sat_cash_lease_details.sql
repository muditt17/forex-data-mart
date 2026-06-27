{{ config(materialized='view') }}

select
  {{ hash_key(['lease_id']) }} as lease_hk,
  lease_id,
  bank_id,
  currency_code,
  lease_amount,
  interest_rate,
  lease_start,
  lease_end,
  case
    when current_date < lease_start then 'scheduled'
    when current_date > lease_end then 'ended'
    else 'active'
  end as lease_status,
  dbt_valid_from as effective_from,
  dbt_valid_to as effective_to,
  (dbt_valid_to is null) as is_current,
  {{ hashdiff(['bank_id','currency_code','lease_amount','interest_rate','lease_start','lease_end']) }} as hashdiff
from {{ ref('cash_lease_snapshot') }}
