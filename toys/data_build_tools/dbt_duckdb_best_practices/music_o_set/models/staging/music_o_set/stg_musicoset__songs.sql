{{ config(materialized='view') }}


with

source as (

  with unnested_artist_json as (
    select
      song_id,
      song_name,
      song_type,
      popularity,
      explicit,
      unnest(artists::varchar []) as artist_json
    from
      {{ ref('songs') }}
  )

  -- Breaks up artists into their own line.
  select
    song_id,
    song_name,
    song_type,
    popularity,
    explicit,
    (artist_json -> '$.artist_id')[2:-2]::varchar as artist_id
  from
    unnested_artist_json
  order by
    song_id

),

renamed as (

  select

    -- ids
    song_id,
    artist_id,

    -- strings
    song_name,
    song_type,

    -- numeric
    popularity::smallint as popularity,

    -- boolean
    explicit

  from source

)

select * from renamed
