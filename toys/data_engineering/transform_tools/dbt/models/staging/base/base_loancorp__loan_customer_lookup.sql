with source as (
    select * from {{ source('loancorp', 'loan_customer_lookup') }}
),
renamed as (
    select
        --ids
        {{ adapter.quote("LOAN_ID") }} as loan_id,
        {{ adapter.quote("CUSTOMER_ID") }} as customer_id
    from source
),
bigints_casted_to_ints as (
    select
        * replace (

            loan_id::int as loan_id,
            customer_id::int as customer_id
        )
    from
        renamed
)
select * from bigints_casted_to_ints
