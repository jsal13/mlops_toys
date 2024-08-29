{{ config(materialized='view', dist='song_id') }}

with

source as (

  select
    song_id,
    max(weeks_on_chart) as weeks_on_chart
  from
    {{ ref('stg_musicoset__song_chart') }}
  group by
    song_id


),

renamed as (

  select
    song_id,
    weeks_on_chart
  from
    source

)

select * from renamed
