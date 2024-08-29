{{ config(materialized='view', dist='artist_id') }}


with

source as (

  select * from {{ ref('tracks') }}

),

renamed as (

  select

    -- ids
    song_id,
    album_id,

    -- numerics
    track_number::smallint,
    {{ date_precision_to_date(
      'release_date', 
      'release_date_precision'
    ) }} as release_date
  from source

)

select * from renamed
