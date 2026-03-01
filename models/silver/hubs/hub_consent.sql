{{ config(materialized='incremental', unique_key='consent_hk', incremental_strategy='merge') }}

with src as (
  select distinct consent_id
  from {{ ref('consent_raw') }}
  where consent_id is not null
)
select
  {{ hash_key(['consent_id']) }} as consent_hk,
  consent_id as business_key,
  current_timestamp as load_date,
  'consent_raw' as record_source
from src

{% if is_incremental() %}
  qualify consent_hk not in (select consent_hk from {{ this }})
{% endif %}
