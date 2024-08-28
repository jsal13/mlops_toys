{{ config(materialized='view') }}

with

source as (

  select * from {{ ref('stg_musicoset__artists') }}

),

renamed as (

  select distinct main_genre as genre from source where main_genre is not null

)

select * from renamed
