{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with src as (
  select distinct lease_id, currency_code
  from {{ ref('cash_lease_raw') }}
  where lease_id is not null and currency_code is not null
)
select
  {{ hash_key(['lease_id','currency_code']) }} as link_hk,
  {{ hash_key(['lease_id']) }} as lease_hk,
  {{ hash_key(['currency_code']) }} as currency_hk,
  current_timestamp as load_date,
  'cash_lease_raw' as record_source
from src

{% if is_incremental() %}
  qualify link_hk not in (select link_hk from {{ this }})
{% endif %}
