{{ config(materialized='view') }}

select
  {{ hash_key(['branch_id']) }} as branch_hk,
  branch_id,
  branch_name,
  city,
  country,
  dbt_valid_from as effective_from,
  dbt_valid_to as effective_to,
  (dbt_valid_to is null) as is_current,
  {{ hashdiff(['branch_name','city','country']) }} as hashdiff
from {{ ref('branch_snapshot') }}
