WITH dim_payments AS (
    SELECT * FROM {{ ref('dim_payments') }}
),
dim_ratecodes AS (
    SELECT * FROM {{ ref('dim_ratecodes') }}
),
dim_services AS (
    SELECT * FROM {{ ref('dim_services') }}
),
dim_vendors AS (
    SELECT * FROM {{ ref('dim_vendors') }}
),
dim_pu_zones AS (
    SELECT * FROM {{ ref('dim_pu_zones') }}
),
dim_do_zones AS (
    SELECT * FROM {{ ref('dim_do_zones') }}
),
stg_fat_trips AS (
    SELECT * FROM {{ ref('stg_taxi_trips') }}
)
SELECT  DISTINCT
          A.fat_key
        , E.vendor_key
        , C.ratecode_key
        , B.payment_key
        , D.service_key
        , F.pu_zone_key
        , G.do_zone_key
        , A.passenger_count
        , A.trip_distance
        , A.trip_distance_km
        , A.fare_amount
        , A.extra
        , A.mta_tax
        , A.tip_amount
        , A.tolls_amount
        , A.improvement_surcharge
        , A.total_amount
        , A.fee
        , A.congestion_surcharge
        , A.pickup_datetime
        , A.dropoff_datetime
        , A.duration_trip
        , CURRENT_TIMESTAMP AS created_at
        , A.loaded_at
FROM stg_fat_trips A
INNER JOIN dim_payments B   ON A.payment_id = B.payment_id
INNER JOIN dim_ratecodes C  ON A.ratecode_id = C.ratecode_id
INNER JOIN dim_services D   ON A.service_id =  D.service_id
INNER JOIN dim_vendors E    ON A.vendor_id = E.vendor_id
INNER JOIN dim_pu_zones F   ON A.pu_location_id = F.pu_location_id
INNER JOIN dim_do_zones G   ON A.do_location_id = G.do_location_id
