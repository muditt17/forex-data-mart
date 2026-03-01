{{ config(materialized='incremental', unique_key='currency_hk', incremental_strategy='merge') }}

with src as (
  select distinct from_currency as currency_code from {{ ref('transactions_raw') }} where from_currency is not null
  union
  select distinct to_currency as currency_code from {{ ref('transactions_raw') }} where to_currency is not null
  union
  select distinct currency_code from {{ ref('cash_lease_raw') }} where currency_code is not null
  union
  select distinct currency_code from {{ ref('vault_stock_raw') }} where currency_code is not null
)
select
  {{ hash_key(['currency_code']) }} as currency_hk,
  currency_code,
  current_timestamp as load_date,
  'derived' as record_source
from src

{% if is_incremental() %}
  qualify currency_hk not in (select currency_hk from {{ this }})
{% endif %}
