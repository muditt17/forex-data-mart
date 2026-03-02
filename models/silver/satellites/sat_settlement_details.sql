{{ config(materialized='incremental', unique_key='settlement_hk', incremental_strategy='merge') }}

with src as (
  select
    {{ hash_key(["settlement_id"]) }} as settlement_hk,
    settlement_id,
    {{ hash_key(["lease_id"]) }} as lease_hk,
    lease_id,
    settlement_date,
    amount_paid,
    payment_status,
    current_timestamp as load_date,
    'bank_settlement_raw' as record_source,
    {{ hashdiff(["lease_id","settlement_date","amount_paid","payment_status"]) }} as hashdiff
  from {{ ref('bank_settlement_raw') }}
  where settlement_id is not null
)

select * from src

{% if is_incremental() %}
  -- merge will update changed settlements by settlement_hk
{% endif %}