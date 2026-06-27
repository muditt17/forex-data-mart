{{ config(materialized='incremental', unique_key='link_hk', incremental_strategy='merge') }}

with src as (
  select distinct transaction_id, from_currency, to_currency
  from {{ ref('transactions_raw') }}
  where transaction_id is not null and from_currency is not null and to_currency is not null
)
select
  {{ hash_key(['transaction_id','from_currency','to_currency']) }} as link_hk,
  {{ hash_key(['transaction_id']) }} as transaction_hk,
  {{ hash_key(['from_currency']) }} as from_currency_hk,
  {{ hash_key(['to_currency']) }} as to_currency_hk,
  current_timestamp as load_date,
  'transactions_raw' as record_source
from src

{% if is_incremental() %}
  qualify link_hk not in (select link_hk from {{ this }})
{% endif %}
