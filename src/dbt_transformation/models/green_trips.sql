{{
  config(
    options={
      "partition_by":"year_ref",
      "overwrite_or_ignore": True
    },
    format='parquet',
    location='s3://tlc-data-refined/green_trips'
  )
}}

SELECT
      CASE
        WHEN vendorid = 1 THEN 'Creative Mobile Technologies'
        WHEN vendorid = 2 THEN 'VeriFone Inc'
        ELSE 'N/D'
      END AS vendor
    , lpep_pickup_datetime
    , lpep_dropoff_datetime
    , CASE
        WHEN store_and_fwd_flag = 'Y' THEN 'STORE AND FORWARD TRIP'
        WHEN store_and_fwd_flag = 'N' THEN 'NOT A STORE AND FORWARD TRIP'
        ELSE 'N/D'
      END AS store_and_fwd_flag
    , CASE
        WHEN ratecodeid = 1 THEN 'STANDARD RATE'
        WHEN ratecodeid = 2 THEN 'JFK'
        WHEN ratecodeid = 3 THEN 'NEWARK'
        WHEN ratecodeid = 4 THEN 'NASSAU OR WESTCHESTER'
        WHEN ratecodeid = 5 THEN 'NEGOTIATED FARE'
        WHEN ratecodeid = 6 THEN 'GROUP RIDE'
      END AS ratecode
    , pulocationid
    , dolocationid
    , COALESCE(passenger_count,1) AS passenger_count
    , trip_distance
    , fare_amount
    , extra
    , mta_tax
    , tip_amount
    , tolls_amount
    , improvement_surcharge
    , total_amount
    , CASE
        WHEN payment_type = 1 THEN 'CREDIT CARD'
        WHEN payment_type = 2 THEN 'CASH'
        WHEN payment_type = 3 THEN 'NO CHARGE'
        WHEN payment_type = 4 THEN 'DISPUTE'
        WHEN payment_type = 5 THEN 'UNKNOWN'
        WHEN payment_type = 6 THEN 'VOIDED TRIP'
        ELSE 'N/D'
      END AS payment_type
    , CASE
        WHEN trip_type = 1 THEN 'STREET-HAIL'
        WHEN trip_type = 2 THEN 'DISPATCH'
        ELSE 'N/D'
      END AS trip_type
    , COALESCE(congestion_surcharge,0) AS congestion_surcharge
    ,year(lpep_pickup_datetime) as year_ref
FROM {{ source('minio','green-taxi-trip-records') }}
WHERE 1=1
  AND YEAR(lpep_pickup_datetime) >= 2021
