{{ config(materialized='view') }}

select *
from {{ source('raw','fx_rates_raw') }}
