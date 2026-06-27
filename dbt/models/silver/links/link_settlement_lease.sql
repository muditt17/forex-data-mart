{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with src as (
  select distinct settlement_id, lease_id
  from {{ ref('bank_settlement_raw') }}
  where settlement_id is not null and lease_id is not null
)
select
  {{ hash_key(['settlement_id','lease_id']) }} as link_hk,
  {{ hash_key(['settlement_id']) }} as settlement_hk,
  {{ hash_key(['lease_id']) }} as lease_hk,
  current_timestamp as load_date,
  'bank_settlement_raw' as record_source
from src

{% if is_incremental() %}
  qualify link_hk not in (select link_hk from {{ this }})
{% endif %}
