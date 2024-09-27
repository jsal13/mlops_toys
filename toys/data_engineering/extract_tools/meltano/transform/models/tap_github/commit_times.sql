{{ config(materialized='table') }}

with source as (
    select
        commit_timestamp,
        date_part('day', commit_timestamp) as commit_date,
        extract(dow from commit_timestamp) as day_of_week
    from
        {{ source('tap_github', 'commits') }}
),

renamed as (
    select
        commit_timestamp,
        commit_date,
        day_of_week
    from
        source
)

select * from renamed
