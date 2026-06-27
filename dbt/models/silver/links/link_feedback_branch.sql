{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with src as (
  select distinct feedback_id, branch_id
  from {{ ref('feedback_raw') }}
  where feedback_id is not null and branch_id is not null
)
select
  {{ hash_key(['feedback_id','branch_id']) }} as link_hk,
  {{ hash_key(['feedback_id']) }} as feedback_hk,
  {{ hash_key(['branch_id']) }} as branch_hk,
  current_timestamp as load_date,
  'feedback_raw' as record_source
from src

{% if is_incremental() %}
  qualify link_hk not in (select link_hk from {{ this }})
{% endif %}
