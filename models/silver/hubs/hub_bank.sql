{{ config(materialized='incremental', unique_key='bank_hk', incremental_strategy='merge') }}

with src as (
  select distinct bank_id
  from {{ ref('banks_raw') }}
  where bank_id is not null
)
select
  {{ hash_key(['bank_id']) }} as bank_hk,
  bank_id as business_key,
  current_timestamp as load_date,
  'banks_raw' as record_source
from src

{% if is_incremental() %}
  qualify bank_hk not in (select bank_hk from {{ this }})
{% endif %}
