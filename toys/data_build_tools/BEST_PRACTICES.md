# DBT Best Practices

These are best practices from [this doc](https://docs.getdbt.com/best-practices/how-we-structure/2-staging).

## Atomic (Initial) Models Layer

### Files and Folders

-  Use folders and subdirectory based on **source system**.

For example, `stg_[source]_[entity]s`: `stg_stripe__orders.sql`.

- Use plurals for tables!

- **Materialize as Views**.
  
  - Any downstream model (discussed more in marts) referencing our staging models will always get the freshest data possible from all of the component views it’s pulling together and materializing).

  - It avoids wasting space in the warehouse on models that are not intended to be queried by data consumers, and thus do not need to perform as quickly or efficiently.

- **Staging models are the only place we'll use the source macro**, and our staging models should have a 1-to-1 relationship to our source tables.

## Staging Models

"The goal of staging models is to clean and prepare individual source-conformed concepts for downstream usage. We're creating the most useful version of a source system table, which we can use as a new modular component for our project."

**Don't use Joins here.**

✅ Renaming
✅ Type casting
✅ Basic computations (e.g. cents to dollars)
✅ Categorizing

For example,

```sql
-- stg_stripe__payments.sql

with

source as (

    select * from {{ source('stripe','payment') }}

),

renamed as (

    select
        -- ids
        id as payment_id,
        orderid as order_id,

        -- strings
        paymentmethod as payment_method,
        case
            when payment_method in ('stripe', 'paypal', 'credit_card', 'gift_card') then 'credit'
            else 'cash'
        end as payment_type,
        status,

        -- numerics
        amount as amount_cents,
        amount / 100.0 as amount,

        -- booleans
        case
            when status = 'successful' then true
            else false
        end as is_completed_payment,

        -- dates
        date_trunc('day', created) as created_date,

        -- timestamps
        created::timestamp_ltz as created_at

    from source

)

select * from renamed
```

## Intermediate Layer: Purpose-built transformation steps

### Files and Folders

```raw
models/intermediate
└── finance
    ├── _int_finance__models.yml
    └── int_payments_pivoted_to_orders.sql
```

Do the following:

- Subdirectories based on business groupings.

- ✅ int_[entity]s_[verb]s.sql - the variety of transformations that can happen inside of the intermediate layer makes it harder to dictate strictly how to name them. The best guiding principle is to think about verbs (e.g. pivoted, aggregated_to_user, joined, fanned_out_by_quantity, funnel_created, etc.) in the intermediate layer.

### Models

- ❌ Exposed to end users. **Intermediate models should generally not be exposed in the main production schema.** They are not intended for output to final targets like dashboards or applications, so it’s best to keep them separated from models that are so you can more easily control data governance and discoverability.

- ✅ Materialized ephemerally. Considering the above, one popular option is to default to intermediate models being materialized ephemerally. This is generally the best place to start for simplicity. It will keep unnecessary models out of your warehouse with minimum configuration. Keep in mind though that the simplicity of ephemerals does translate a bit more difficulty in troubleshooting, as they’re interpolated into the models that ref them, rather than existing on their own in a way that you can view the output of.

- ✅ Materialized as views in a custom schema with special permissions. A more robust option is to materialize your intermediate models as views in a specific custom schema, outside of your main production schema. This gives you added insight into development and easier troubleshooting as the number and complexity of your models grows, while remaining easy to implement and taking up negligible space.

### What kinds of data transformations?

- ✅ Structural simplification. **Bringing together a reasonable number (typically 4 to 6) of entities or concepts (staging models, or perhaps other intermediate models) that will be joined with another similarly purposed intermediate model to generate a mart** — rather than have 10 joins in our mart, we can join two intermediate models that each house a piece of the complexity, giving us increased readability, flexibility, testing surface area, and insight into our components.

- ✅ Re-graining. Intermediate models are often used to fan out or collapse models to the right composite grain — if we’re building a mart for order_items that requires us to fan out our orders based on the quantity column, creating a new single row for each item, this would be ideal to do in a specific intermediate model to maintain clarity in our mart and more easily view that our grain is correct before we mix it with other components.

- ✅ Isolating complex operations. **It’s helpful to move any particularly complex or difficult to understand pieces of logic into their own intermediate models.** This not only makes them easier to refine and troubleshoot, but simplifies later models that can reference this concept in a more clearly readable way. For example, in the quantity fan out example above, we benefit by isolating this complex piece of logic so we can quickly debug and thoroughly test that transformation, and downstream models can reference order_items in a way that’s intuitively easy to grasp.

## Marts: Business-defined entities

### Files and Folders

The last layer of our core transformations is below, providing models for both finance and marketing departments.

```raw
models/marts
├── finance
│   ├── _finance__models.yml
│   ├── orders.sql
│   └── payments.sql
└── marketing
    ├── _marketing__models.yml
    └── customers.sql
```

- ✅ **Group by department or area of concern.** If you have fewer than 10 or so marts you may not have much need for subfolders, so as with the intermediate layer, don’t over-optimize too early. If you do find yourself needing to insert more structure and grouping though, use useful business concepts here. In our marts layer, we’re no longer worried about source-conformed data, so grouping by departments (marketing, finance, etc.) is the most common structure at this stage.

- ✅ **Name by entity. Use plain English to name the file based on the concept that forms the grain of the mart customers, orders.** Note that for pure marts, there should not be a time dimension (orders_per_day) here, that is typically best captured via metrics.

- ❌ Build the same concept differently for different teams. finance_orders and marketing_orders is typically considered an anti-pattern. There are, as always, exceptions — a common pattern we see is that, finance may have specific needs, for example reporting revenue to the government in a way that diverges from how the company as a whole measures revenue day-to-day. Just make sure that these are clearly designed and understandable as separate concepts, not departmental views on the same concept: tax_revenue and revenue not finance_revenue and marketing_revenue.

### Models

**The most important aspect of marts is that they contain all of the useful data about a particular entity at a granular level.**

```sql
-- customers.sql

with

customers as (

    select * from {{ ref('stg_jaffle_shop__customers')}}

),

orders as (

    select * from {{ ref('orders')}}

),

customer_orders as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value

    from orders

    group by 1

),

customers_and_customer_orders_joined as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value

    from customers

    left join customer_orders on customers.customer_id = customer_orders.customer_id

)

select * from customers_and_customer_orders_joined
```

- ✅ Materialized as tables or incremental models. Once we reach the marts layer, it’s time to start building not just our logic into the warehouse, but the data itself. This gives end users much faster performance for these later models that are actually designed for their use, and saves us costs recomputing these entire chains of models every time somebody refreshes a dashboard or runs a regression in python.
  - A good general rule of thumb regarding materialization is to always start with a view (as it takes up essentially no storage and always gives you up-to-date results), once that view takes too long to practically query, build it into a table, and finally once that table takes too long to build and is slowing down your runs, configure it as an incremental model.

- ✅ **Wide and denormalized. (!!!)** Unlike old school warehousing, in the modern data stack storage is cheap and it’s compute that is expensive and must be prioritized as such, packing these into very wide denormalized concepts that can provide everything somebody needs about a concept as a goal.

- ❌ Too many joins in one mart. 

## General Tips

```raw
-- dbt_project.yml

models:
  jaffle_shop:
    staging:
      +materialized: view
    intermediate:
      +materialized: ephemeral
    marts:
      +materialized: table
      finance:
        +schema: finance
      marketing:
        +schema: marketing
```

- ✅ seeds for lookup tables. The most common use case for seeds is loading lookup tables that are helpful for modeling but don’t exist in any source systems — think mapping zip codes to states, or UTM parameters to marketing campaigns. In this example project we have a small seed that maps our employees to their customer_ids, so that we can handle their purchases with special logic.

- ❌ seeds for loading source data. Do not use seeds to load data from a source system into your warehouse. If it exists in a system you have access to, you should be loading it with a proper EL tool into the raw data area of your warehouse. dbt is designed to operate on data in the warehouse, not as a data-loading tool.