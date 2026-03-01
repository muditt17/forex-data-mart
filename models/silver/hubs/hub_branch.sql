{{ config(materialized='incremental', unique_key='branch_hk', incremental_strategy='merge') }}

with src as (
  select distinct branch_id
  from {{ ref('branches_raw') }}
  where branch_id is not null
)
select
  {{ hash_key(['branch_id']) }} as branch_hk,
  branch_id as business_key,
  current_timestamp as load_date,
  'branches_raw' as record_source
from src

{% if is_incremental() %}
  qualify branch_hk not in (select branch_hk from {{ this }})
{% endif %}
