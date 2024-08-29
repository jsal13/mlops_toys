{{ config(materialized='table') }}

with

source as (

  select
    aswoc.artist_id,
    artists.artist_name,
    count(distinct aswoc.song_id) as song_count
  from
    {{ ref("int_musicoset__artist_song_weeks_on_chart") }} as aswoc
  inner join

    {{ ref("stg_musicoset__artists") }} as artists
    on aswoc.artist_id = artists.artist_id

  where aswoc.weeks_on_chart > 0
  group by 1, 2

),

renamed as (

  select

  -- ids
    artist_id,

    -- strings
    artist_name,

    -- numerics
    song_count

  from source

)

select * from renamed
