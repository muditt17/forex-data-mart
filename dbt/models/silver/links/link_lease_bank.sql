{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with curr as (
  select
    lease_id,
    bank_id
  from {{ ref('cash_lease_snapshot') }}
  where dbt_valid_to is null
    and lease_id is not null
    and bank_id is not null
),
src as (
  select distinct lease_id, bank_id
  from curr
)

select
  {{ hash_key(['lease_id','bank_id']) }} as link_hk,
  {{ hash_key(['lease_id']) }} as lease_hk,
  {{ hash_key(['bank_id']) }} as bank_hk,
  current_timestamp as load_date,
  'cash_lease_snapshot' as record_source
from src

{% if is_incremental() %}
  where {{ hash_key(['lease_id','bank_id']) }} not in (select link_hk from {{ this }})
{% endif %}