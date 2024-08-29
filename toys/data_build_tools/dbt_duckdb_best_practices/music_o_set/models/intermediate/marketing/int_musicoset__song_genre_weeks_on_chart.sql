{{ config(materialized='view') }}

with

source as (

  select
    -- ids
    aswoc.artist_id,

    -- strings
    aswoc.song_name,
    amgl.main_genre,

    -- numerics
    aswoc.weeks_on_chart

  from
    {{ ref ("int_musicoset__artist_song_weeks_on_chart") }} as aswoc
  inner join
    {{ ref("stg_musicoset__artist_main_genre_lookup") }} as amgl
    on aswoc.artist_id = amgl.artist_id

),

renamed as (

  select

    -- ids
    artist_id,

    -- strings
    song_name,
    main_genre,

    -- numerics
    weeks_on_chart

  from source

)

select * from renamed
