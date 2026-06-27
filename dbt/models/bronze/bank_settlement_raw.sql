{{ config(materialized='incremental') }}

select *
from {{ source('raw','bank_settlement_raw') }}
