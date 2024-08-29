{{ config(materialized='view', dist='album_id') }}


with

source as (

  select * from {{ ref('albums') }}

),

renamed as (

  select

    -- ids
    album_id,

    -- strings
    name as album_name,
    billboard,
    album_type,

    -- jsons
    artists as artists_json,

    -- numerics
    popularity::smallint as popularity,
    total_tracks

  from source

)

select * from renamed
