{{ config(materialized='view') }}

select *
from {{ source('raw','customers_raw') }}
