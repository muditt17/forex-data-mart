{{ config(materialized='incremental') }}

select *
from {{ source('raw','consent_raw') }}
