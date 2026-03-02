{{ config(materialized='incremental') }}

select *
from {{ source('raw','transactions_raw') }}
