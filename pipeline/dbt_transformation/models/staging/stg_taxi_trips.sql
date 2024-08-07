WITH stg_yellow_trips AS (
    SELECT
        vendorid AS vendor_id
        ,tpep_pickup_datetime AS pickup_datetime
        ,tpep_dropoff_datetime AS dropoff_datetime
        ,COALESCE(passenger_count,1) AS passenger_count
        ,trip_distance
        ,ratecodeid AS ratecode_id
        ,pulocationid AS pulocation_id
        ,dolocationid AS dolocation_id
        ,payment_type AS payment_id
        ,1 AS service_id
        ,fare_amount
        ,extra
        ,mta_tax
        ,tip_amount
        ,tolls_amount
        ,improvement_surcharge
        ,total_amount
        ,COALESCE(airport_fee,0) as fee
        ,COALESCE(congestion_surcharge,0) AS congestion_surcharge
    FROM {{ source('bronze','raw_yellow_taxi_trip_records') }}
    WHERE 1=1
    AND YEAR(tpep_pickup_datetime) >= 2020
),
stg_green_trips AS (
    SELECT
        vendorid AS vendor_id
        , lpep_pickup_datetime AS pickup_datetime
        , lpep_dropoff_datetime AS dropoff_datetime
        , COALESCE(passenger_count,1) AS passenger_count
        , trip_distance
        , ratecodeid AS ratecode_id
        , pulocationid AS pulocation_id
        , dolocationid AS dolocation_id
        , payment_type AS payment_id
        , 2 AS service_id
        , fare_amount
        , extra
        , mta_tax
        , tip_amount
        , tolls_amount
        , improvement_surcharge
        , total_amount
        , COALESCE(ehail_fee,0) as fee
        , COALESCE(congestion_surcharge,0) AS congestion_surcharge
    FROM {{ source('bronze','raw_green_taxi_trip_records') }}
    WHERE 1=1
    AND YEAR(lpep_pickup_datetime) >= 2020
),
stg_fat_trips AS (
    SELECT *
    FROM stg_yellow_trips
    UNION ALL
    SELECT *
    FROM stg_green_trips
)
SELECT DISTINCT
         {{ dbt_utils.surrogate_key(['vendor_id','payment_id','ratecode_id','service_id','pickup_datetime','dropoff_datetime','pulocation_id','dolocation_id']) }} as fat_key
        , vendor_id
        , pickup_datetime
        , dropoff_datetime
        , DATEDIFF('minute', pickup_datetime, dropoff_datetime) AS duration_trip
        , passenger_count
        , trip_distance
        , {{ miles_to_km('trip_distance') }} AS trip_distance_km
        , ratecode_id
        , pulocation_id AS pu_location_id
        , dolocation_id AS do_location_id
        , payment_id
        , service_id
        , fare_amount
        , extra
        , mta_tax
        , tip_amount
        , tolls_amount
        , improvement_surcharge
        , total_amount
        , fee
        , congestion_surcharge
        , CURRENT_TIMESTAMP AS loaded_at
FROM stg_fat_trips
