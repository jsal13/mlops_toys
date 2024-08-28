{{ config(materialized='view') }}


with

source as (

  select * from {{ ref('songs') }}

),

renamed as (

  select

    -- ids
    song_id,

    -- strings
    song_name,
    song_type,

    -- json
    artists,

    -- numeric
    popularity::smallint as popularity,

    -- boolean
    explicit

  from source

)

select * from renamed
