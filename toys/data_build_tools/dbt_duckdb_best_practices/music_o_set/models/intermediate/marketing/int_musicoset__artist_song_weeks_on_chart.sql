{{ config(materialized='view') }}

with

source as (

  select
    songs.song_name,
    songs.artist_id,
    songs.song_id,
    mwoc.weeks_on_chart
  from
    {{ ref("stg_musicoset__max_weeks_on_chart") }} as mwoc
  inner join
    {{ ref('stg_musicoset__songs') }} as songs
    on mwoc.song_id = songs.song_id

),

renamed as (

  select

    -- ids
    artist_id,
    song_id,

    -- strings
    song_name,

    -- numerics
    weeks_on_chart

  from source

)

select * from renamed
