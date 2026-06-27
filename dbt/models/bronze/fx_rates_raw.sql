{{ config(materialized='incremental') }}

select *
from {{ source('raw','fx_rates_raw') }}
