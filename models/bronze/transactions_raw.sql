{{ config(materialized='view') }}

select *
from {{ source('raw','transactions_raw') }}
