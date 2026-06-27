{{ config(materialized='incremental', unique_key='transaction_hk', incremental_strategy='merge') }}

with src as (
  select distinct transaction_id
  from {{ ref('transactions_raw') }}
  where transaction_id is not null
)
select
  {{ hash_key(['transaction_id']) }} as transaction_hk,
  transaction_id as business_key,
  current_timestamp as load_date,
  'transactions_raw' as record_source
from src

{% if is_incremental() %}
  qualify transaction_hk not in (select transaction_hk from {{ this }})
{% endif %}
