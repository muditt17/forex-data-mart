{{ config(materialized='view') }}

select *
from {{ source('raw','vault_stock_raw') }}
