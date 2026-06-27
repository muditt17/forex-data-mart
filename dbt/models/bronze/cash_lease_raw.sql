{{ config(materialized='incremental') }}

select *
from {{ source('raw','cash_lease_raw') }}
