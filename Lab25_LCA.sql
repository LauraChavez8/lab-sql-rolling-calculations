USE sakila;

CREATE OR REPLACE VIEW active_customers AS
SELECT MONTH(rental_date) AS mes, YEAR(rental_date) AS anno, COUNT(customer_id) AS total_customers FROM sakila.rental
GROUP BY MONTH(rental_date), YEAR(rental_date);

SELECT * FROM active_customers;

CREATE OR REPLACE VIEW active_customers_per_month AS
SELECT a1.mes, a1.anno, SUM(a2.total_customers) AS actusers_anterior, SUM(a1.total_customers) AS actusers_actual 
FROM active_customers a1
JOIN active_customers a2
ON a1.mes = a2.mes+1
AND a1.anno = a2.anno
GROUP BY a1.mes, a1.anno;

SELECT * FROM active_customers_per_month;

SELECT *, ((actusers_actual - actusers_anterior) / actusers_anterior) * 100 AS Dif_percentage
FROM active_customers_per_month;

CREATE OR REPLACE VIEW unique_customers AS
SELECT DISTINCT customer_id as active_id, MONTH(rental_date) AS mes, YEAR(rental_date) AS anno 
FROM sakila.rental;

SELECT * FROM unique_customers;

CREATE OR REPLACE VIEW retained_customers AS
SELECT u1.mes, u1.anno, COUNT(DISTINCT u1.active_id) AS retained_customers
FROM unique_customers u1
JOIN unique_customers u2
ON u1.active_id = u2.active_id
AND u2.mes = u1.mes+1
GROUP BY u1.mes, u1.anno;

SELECT * FROM retained_customers;
