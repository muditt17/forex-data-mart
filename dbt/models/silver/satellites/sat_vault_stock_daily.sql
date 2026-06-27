{{ config(materialized='incremental', unique_key="branch_currency_date_hk", incremental_strategy='merge') }}

with src as (
  select
    {{ hash_key(["branch_id","currency_code","cast(stock_date as varchar)"]) }} as branch_currency_date_hk,
    {{ hash_key(["branch_id"]) }} as branch_hk,
    {{ hash_key(["currency_code"]) }} as currency_hk,
    branch_id,
    currency_code,
    stock_date,
    opening_balance,
    closing_balance,
    inflow_amount,
    outflow_amount,
    current_timestamp as load_date,
    'vault_stock_raw' as record_source,
    {{ hashdiff(["opening_balance","closing_balance","inflow_amount","outflow_amount"]) }} as hashdiff
  from {{ ref('vault_stock_raw') }}
  where branch_id is not null
    and currency_code is not null
    and stock_date is not null
)

select * from src

{% if is_incremental() %}
  -- update if same hk changed (merge handles it)
  -- optionally filter source to new dates only if you have ingestion watermark
{% endif %}