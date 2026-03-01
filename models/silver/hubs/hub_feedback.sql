{{ config(materialized='incremental', unique_key='feedback_hk', incremental_strategy='merge') }}

with src as (
  select distinct feedback_id
  from {{ ref('feedback_raw') }}
  where feedback_id is not null
)
select
  {{ hash_key(['feedback_id']) }} as feedback_hk,
  feedback_id as business_key,
  current_timestamp as load_date,
  'feedback_raw' as record_source
from src

{% if is_incremental() %}
  qualify feedback_hk not in (select feedback_hk from {{ this }})
{% endif %}
