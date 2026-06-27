{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with curr as (
  select
    lease_id,
    currency_code
  from {{ ref('cash_lease_snapshot') }}
  where dbt_valid_to is null
    and lease_id is not null
    and currency_code is not null
),
src as (
  select distinct lease_id, currency_code
  from curr
)

select
  {{ hash_key(['lease_id','currency_code']) }} as link_hk,
  {{ hash_key(['lease_id']) }} as lease_hk,
  {{ hash_key(['currency_code']) }} as currency_hk,
  current_timestamp as load_date,
  'cash_lease_snapshot' as record_source
from src

{% if is_incremental() %}
  where {{ hash_key(['lease_id','currency_code']) }} not in (select link_hk from {{ this }})
{% endif %}