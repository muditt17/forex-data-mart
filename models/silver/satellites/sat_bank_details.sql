{{ config(materialized='view') }}

with src as (
  select
    {{ hash_key(["bank_id"]) }} as bank_hk,
    bank_id,
    bank_name,
    country,
    bank_type,
    current_timestamp as load_date,
    'banks_raw' as record_source,
    {{ hashdiff(["bank_name","country","bank_type"]) }} as hashdiff
  from {{ ref('banks_raw') }}
  where bank_id is not null
)

select * from src