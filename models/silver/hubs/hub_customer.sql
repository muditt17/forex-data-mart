{{ config(materialized='incremental', unique_key='customer_hk', incremental_strategy='merge') }}

with src as (
  select distinct customer_id
  from {{ ref('customers_raw') }}
  where customer_id is not null
)
select
  {{ hash_key(['customer_id']) }} as customer_hk,
  customer_id as business_key,
  current_timestamp as load_date,
  'customers_raw' as record_source
from src

{% if is_incremental() %}
  qualify customer_hk not in (select customer_hk from {{ this }})
{% endif %}
