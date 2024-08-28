{{ config(materialized='view', dist='album_id') }}

with

source as (

  select * from {{ ref('album_chart') }}

),

renamed as (

  select

    -- ids
    album_id,

    -- numerics
    rank_score::smallint as rank_score,
    peak_position::smallint as peak_position,
    week_count::smallint as week_count,

    -- date
    date::date as dt

  from source

)

select * from renamed
