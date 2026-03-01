{{ config(materialized='incremental', unique_key='settlement_hk', incremental_strategy='merge') }}

with src as (
  select distinct settlement_id
  from {{ ref('bank_settlement_raw') }}
  where settlement_id is not null
)
select
  {{ hash_key(['settlement_id']) }} as settlement_hk,
  settlement_id as business_key,
  current_timestamp as load_date,
  'bank_settlement_raw' as record_source
from src

{% if is_incremental() %}
  qualify settlement_hk not in (select settlement_hk from {{ this }})
{% endif %}
