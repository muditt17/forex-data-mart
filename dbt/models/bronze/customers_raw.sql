{{ config(materialized='incremental') }}

select *
from {{ source('raw','customers_raw') }}
