with source as (
    select * from {{ source('loancorp', 'lenders') }}
),
renamed as (
    select
        --ids
        {{ adapter.quote("LENDER_ID") }} as lender_id,
        --strings
        {{ adapter.quote("LENDER_NAME") }} as lender_name
    from source
),
bigints_casted_to_ints as (
    select
        * replace (
            lender_id::int as lender_id
        )
    from
        renamed
)
select * from bigints_casted_to_ints
