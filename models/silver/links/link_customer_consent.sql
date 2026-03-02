{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with curr as (
  select
    consent_id,
    customer_id
  from {{ ref('consent_snapshot') }}
  where dbt_valid_to is null
    and consent_id is not null
    and customer_id is not null
),
src as (
  select distinct consent_id, customer_id
  from curr
)

select
  {{ hash_key(['consent_id','customer_id']) }} as link_hk,
  {{ hash_key(['consent_id']) }} as consent_hk,
  {{ hash_key(['customer_id']) }} as customer_hk,
  current_timestamp as load_date,
  'consent_snapshot' as record_source
from src

{% if is_incremental() %}
  where {{ hash_key(['consent_id','customer_id']) }} not in (select link_hk from {{ this }})
{% endif %}