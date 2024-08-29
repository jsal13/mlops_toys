{{ config(materialized='view', dist='song_id') }}


with

source as (

  select * from {{ ref('songs') }}

),

renamed as (

  select

    -- ids
    song_id,
    artists

  from source

)

select * from renamed
