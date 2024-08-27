{{ config(materialized='view', dist='artist_id') }}


with

source as (

    select * from {{ ref('artists') }}

),

renamed as (

    select

        -- ids
        artist_id,

        -- list 
        genres::varchar[] as genres,

        -- numerics
        popularity::smallint as popularity,
        case
            when followers = 'None' then null
            else followers::integer
        end as followers,

        -- strings
        name as artist_name,
        case
            when main_genre = '-' then null
            else main_genre
        end as main_genre,
        case
            when artist_type = '-' then null
            else artist_type
        end as artist_type

    from source

)

select * from renamed
