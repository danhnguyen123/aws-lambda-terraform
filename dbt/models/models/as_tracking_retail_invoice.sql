{{ config(materialized='table') }}

SELECT
    invoice_id,
    stock_code,
    description,
    quantity,
    invoice_date,
    price,
    customer_id,
    country,
    invoice_datetime,
    -- Add any transformations here
    price * quantity as total_amount
FROM {{ source('argisung_rawdata', 'retail_invoice') }}