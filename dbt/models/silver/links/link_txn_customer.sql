{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with src as (
  select distinct transaction_id, customer_id
  from {{ ref('transactions_raw') }}
  where transaction_id is not null and customer_id is not null
)
select
  {{ hash_key(['transaction_id','customer_id']) }} as link_hk,
  {{ hash_key(['transaction_id']) }} as transaction_hk,
  {{ hash_key(['customer_id']) }} as customer_hk,
  current_timestamp as load_date,
  'transactions_raw' as record_source
from src

{% if is_incremental() %}
  qualify link_hk not in (select link_hk from {{ this }})
{% endif %}
