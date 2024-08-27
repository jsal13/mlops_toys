{{ config(materialized='view', dist='artist_id') }}


with

source as (

    select * from {{ ref('releases') }}

),

renamed as (

    select

        -- ids
        artist_id,
        album_id,

        -- dates
        {{ date_precision_to_date(release_date, release_date_precision) }}

    from source

)

select * from renamed
