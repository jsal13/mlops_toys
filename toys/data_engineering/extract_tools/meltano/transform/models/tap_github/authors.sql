{{ config(materialized='table') }}

with source as (
    select distinct commit -> 'author' -> 'name' as authors
    from
        {{ source('tap_github', 'commits') }}
),

renamed as (
    select authors
    from
        source
)

select * from renamed
