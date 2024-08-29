{{ config(materialized='table') }}

with

source as (

  select
    amgl.main_genre,
    count(distinct aswoc.song_id) as song_count
  from
    {{ ref("int_musicoset__artist_song_weeks_on_chart") }} as aswoc
  inner join

    {{ ref("stg_musicoset__artist_main_genre_lookup") }} as amgl
    on aswoc.artist_id = amgl.artist_id
  inner join
    {{ ref("stg_musicoset__song_chart") }} as sc
    on aswoc.song_id = sc.song_id

  where
    aswoc.weeks_on_chart > 0
    and sc.peak_position <= 10
    and amgl.main_genre is not null
  group by 1

),

renamed as (
  select
    main_genre,
    song_count
  from
    source
)

select * from renamed
