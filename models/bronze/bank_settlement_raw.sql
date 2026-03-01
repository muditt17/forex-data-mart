{{ config(materialized='view') }}

select *
from {{ source('raw','bank_settlement_raw') }}
