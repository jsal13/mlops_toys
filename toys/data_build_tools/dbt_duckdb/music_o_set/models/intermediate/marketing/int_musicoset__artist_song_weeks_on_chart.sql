{{ config(materialized='view') }}

with

source as (


  with max_weeks_on_chart as (
    select
      song_id,
      max(weeks_on_chart) as weeks_on_chart
    from
      {{ ref('stg_musicoset__song_chart') }}
    group by
      song_id
  ),

  artists_array as (
    select
      songs.song_name,
      songs.artists,
      mwoc.weeks_on_chart
    from
      max_weeks_on_chart as mwoc
    inner join
      {{ ref('stg_musicoset__songs') }} as songs
      on mwoc.song_id = songs.song_id
  )

  select
    song_name,
    artists,
    weeks_on_chart
  from artists_array
),

renamed as (

  select

    -- strings
    song_name,

    -- some kind'a list
    artists,

    -- numerics
    weeks_on_chart

  from source

)

select * from renamed
