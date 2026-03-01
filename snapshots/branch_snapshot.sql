{% snapshot branch_snapshot %}
{{
  config(
    target_schema='snapshots',
    unique_key='branch_id',
    strategy='check',
    check_cols=['branch_name','city','country'],
    invalidate_hard_deletes=True
  )
}}
select * from {{ source('raw','branches_raw') }}
{% endsnapshot %}
