{{ config(materialized='view', dist='artist_id') }}


with

source as (

  select * from {{ ref('stg_musicoset__artists') }}

),

renamed as (

  select

    -- ids
    artist_id,

    -- strings
    main_genre

  from source

)

select * from renamed
