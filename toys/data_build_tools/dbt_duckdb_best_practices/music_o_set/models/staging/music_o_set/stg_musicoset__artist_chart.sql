{{ config(materialized='view', dist='artist_id') }}

with

source as (

  select * from {{ ref('artist_chart') }}

),

renamed as (

  select

    -- ids
    artist_id,

    -- numerics
    rank_score::smallint as rank_score,
    peak_position::smallint as peak_position,
    weeks_on_chart::smallint as weeks_on_chart,

    -- dates
    week::date as dt_week

  from source

)

select * from renamed
