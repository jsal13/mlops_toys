with loans_info_payments as (
    select distinct
        loan_id,
        due_interest_amount,
        due_principal_amount,
        due_escrow_amount,
        due_fees_amount
    from
        {{ ref ("stg_loancorp__loan_info") }}
),
customer_to_loans_agg as (
    select
        lcl.customer_id,
        sum(lip.due_interest_amount) as due_interest_amount_sum,
        sum(lip.due_principal_amount) as due_principal_amount_sum,
        sum(lip.due_escrow_amount) as due_escrow_amount_sum,
        sum(lip.due_fees_amount) as due_fees_amount_sum
    from
        loans_info_payments as lip
    inner join
        {{ ref("stg_loancorp__loan_customer_lookup" ) }} as lcl
        on lip.loan_id = lcl.loan_id
    group by
        1
)
select * from customer_to_loans_agg
