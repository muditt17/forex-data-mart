{{ config(materialized='incremental') }}

select *
from {{ source('raw','vault_stock_raw') }}
