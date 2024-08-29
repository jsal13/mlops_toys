{{ config(materialized='view', dist='song_id') }}

with

source as (

  select * from {{ ref('song_pop') }}

),

renamed as (

  select

    -- ids
    song_id,

    -- numeric
    year_end_score::integer as year_end_score,
    is_pop::boolean as is_pop,

    -- string
    year::varchar(4) as dt_year -- Should this be a date?

  from source

)

select * from renamed
