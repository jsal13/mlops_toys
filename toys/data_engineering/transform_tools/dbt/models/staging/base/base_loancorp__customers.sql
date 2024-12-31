with source as (
    select * from {{ source('loancorp', 'customers') }}
),
renamed as (
    select
        --ids
        {{ adapter.quote("CUSTOMER_ID") }} as customer_id,
        --strings
        {{ adapter.quote("NAME") }} as full_name,
        {{ adapter.quote("ADDRESS") }} as customer_address,
        {{ adapter.quote("SSN") }} as ssn,
        --int
        {{ adapter.quote("AGE") }} as customer_age
    from source
),
bigints_casted_to_ints as (
    select
        * replace (
            customer_id::int as customer_id,
            customer_age::int as customer_age
        )
    from
        renamed
),
mask_pii as (
    select
        * replace (
            {{ dbt_privacy.safe_mask("ssn", n=8, keep_n=4,) }} as ssn
        )
    from bigints_casted_to_ints
)
select * from mask_pii
