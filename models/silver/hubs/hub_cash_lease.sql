{{ config(materialized='incremental', unique_key='lease_hk', incremental_strategy='merge') }}

with src as (
  select distinct lease_id
  from {{ ref('cash_lease_raw') }}
  where lease_id is not null
)
select
  {{ hash_key(['lease_id']) }} as lease_hk,
  lease_id as business_key,
  current_timestamp as load_date,
  'cash_lease_raw' as record_source
from src

{% if is_incremental() %}
  qualify lease_hk not in (select lease_hk from {{ this }})
{% endif %}
