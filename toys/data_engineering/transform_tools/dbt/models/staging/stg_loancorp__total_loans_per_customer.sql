with source as (
    select * from {{ ref("base_loancorp__loan_customer_lookup") }}
),
aggregated as (
    select
        customer_id,
        count(distinct loan_id)::integer as number_of_loan_ids
    from
        source
    group by
        1
)
select * from aggregated
