{{ config(materialized='incremental') }}

select *
from {{ source('raw','feedback_raw') }}
