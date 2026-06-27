{{ config(materialized='incremental', unique_key='feedback_hk', incremental_strategy='merge') }}

with src as (
  select
    {{ hash_key(['feedback_id']) }} as feedback_hk,
    feedback_id,
    {{ hash_key(['customer_id']) }} as customer_hk,
    {{ hash_key(['branch_id']) }} as branch_hk,
    rating,
    comments,
    feedback_ts,
    current_timestamp as load_date,
    {{ hashdiff(['rating','comments','feedback_ts']) }} as hashdiff
  from {{ ref('feedback_raw') }}
  where feedback_id is not null
)
select * from src

{% if is_incremental() %}
  qualify feedback_hk not in (select feedback_hk from {{ this }})
{% endif %}
