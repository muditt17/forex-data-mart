{% snapshot consent_snapshot %}
{{
  config(
    target_schema='snapshots',
    unique_key='consent_id',
    strategy='check',
    check_cols=['customer_id','consent_type','consent_flag','source_system','consent_ts'],
    invalidate_hard_deletes=True
  )
}}
select * from {{ source('raw','consent_raw') }}
{% endsnapshot %}
