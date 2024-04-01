SELECT * FROM kimia_farma.kf_final

CREATE TABLE IF NOT EXISTS kimia_farma.kf_analysis AS
SELECT 
    kft.transaction_id,
    kft.date AS transaction_date,
    kft.branch_id,
    kfc.branch_name,
    kfc.kota,
    kfc.provinsi,
    kfc.rating AS rating_cabang,
    kft.customer_name,
    kft.product_id,
    kfp.product_name,
    kfp.price,
    kft.discount_percentage,
    kft.rating AS rating_transaction
FROM kimia_farma.kf_final_transaction AS kft
LEFT JOIN kimia_farma.kf_product AS kfp ON kfp.product_id = kft.product_id
LEFT JOIN kimia_farma.kf_kantor_cabang AS kfc ON kfc.branch_id = kft.branch_id;

SELECT * FROM kimia_farma.kf_analysis
CREATE TABLE kimia_farma.kf_aggregate AS
SELECT 
    transaction_id,
    customer_name,
    CASE 
        WHEN price <= 50000 THEN 0.10
        WHEN price BETWEEN 50000 AND 100000 THEN 0.15
        WHEN price BETWEEN 100000 AND 300000 THEN 0.20
        WHEN price BETWEEN 300000 AND 500000 THEN 0.25
        WHEN price > 500000 THEN 0.30
    END AS persentase_gross_laba,
    price * (1 - discount_percentage / 100.0) AS nett_sales,
    nett_sales - price AS nett_profit
FROM 
    kimia_farma.kf_analysis;
SELECT * FROM kimia_farma.kf_aggregate

--AGGREGASI
CREATE TABLE kimia_farma.kf_final AS
SELECT 
    A.transaction_date,
    A.branch_id,
    A.branch_name,
    A.kota,
    A.provinsi,
    A.rating_cabang,
    A.product_id,
    A.product_name,
    A.price,
    A.discount_percentage,
    A.rating_transaction,
    B.transaction_id,
    B.customer_name,
    B.persentase_gross_laba,
    ROUND(B.nett_sales, 3) AS nett_sales,
    ROUND(B.nett_profit, 3) AS nett_profit
FROM 
    kimia_farma.kf_analysis AS A
JOIN 
    kimia_farma.kf_aggregate AS B
ON 
    A.transaction_id = B.transaction_id;



select * from kimia_farma.kf_analysis;
select * from kimia_farma.kf_aggregate;
select * from kimia_farma.kf_final;