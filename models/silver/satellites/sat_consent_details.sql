{{ config(materialized='view') }}

select
  {{ hash_key(['consent_id']) }} as consent_hk,
  consent_id,
  {{ hash_key(['customer_id']) }} as customer_hk,
  customer_id,
  consent_type,
  consent_flag,
  source_system,
  consent_ts,
  dbt_valid_from as effective_from,
  dbt_valid_to as effective_to,
  (dbt_valid_to is null) as is_current,
  {{ hashdiff(['customer_id','consent_type','consent_flag','source_system','consent_ts']) }} as hashdiff
from {{ ref('consent_snapshot') }}
