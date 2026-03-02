{{ config(materialized='incremental') }}

select *
from {{ source('raw','banks_raw') }}
