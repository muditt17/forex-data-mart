{{ config(materialized='view') }}

select
  {{ hash_key(['customer_id']) }} as customer_hk,
  customer_id,
  first_name,
  last_name,
  nationality,
  risk_rating,
  kyc_status,
  dbt_valid_from as effective_from,
  dbt_valid_to as effective_to,
  (dbt_valid_to is null) as is_current,
  {{ hashdiff(['first_name','last_name','nationality','risk_rating','kyc_status']) }} as hashdiff
from {{ ref('customer_snapshot') }}
