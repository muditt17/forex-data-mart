{{ config(materialized='view') }}

select *
from {{ source('raw','banks_raw') }}
