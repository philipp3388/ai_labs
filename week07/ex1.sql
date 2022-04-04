DROP TABLE IF EXISTS exercise1;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS customersCounted;
DROP TABLE IF EXISTS customersUnique;
DROP TABLE IF EXISTS itemsCounted;
DROP TABLE IF EXISTS itemsUnique;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS citiesCounted;
DROP TABLE IF EXISTS citiesUnique;
DROP TABLE IF EXISTS customersUniqueCities;

DROP TABLE IF EXISTS topSpenders;

CREATE TABLE exercise1 (
	orderId INT NOT NULL,
	date DATE,
	customerId INT NOT NULL,
	customerName VARCHAR(255),
	city VARCHAR(255),
	itemId INT NOT NULL,
	itemName VARCHAR(255),
	quant INT,
	price REAL,
	
	PRIMARY KEY (orderId, customerId, itemId)
);

INSERT INTO exercise1 (orderId, date, customerId, customerName, city, itemId, itemName, quant, price)
VALUES 
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101, 'Martin', 'Prague', 3786, 'Net', 3, 35.00),
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101, 'Martin', 'Prague', 4011, 'Racket', 6, 65.00),
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101, 'Martin', 'Prague', 9132, 'Pack-3', 8, 4.75),
(2302, TO_DATE('25/02/2011', 'DD/MM/YYYY'), 107, 'Herman', 'Madrid', 5794, 'Pack-6', 4, 5.00),
(2303, TO_DATE('27/02/2011', 'DD/MM/YYYY'), 110, 'Pedro', 'Moscow', 4011, 'Racket', 2, 65.00),
(2303, TO_DATE('27/02/2011', 'DD/MM/YYYY'), 110, 'Pedro', 'Moscow', 3141, 'Cover', 2, 10.00);

--1NF already
SELECT * FROM exercise1;

--2NF
CREATE TABLE orders AS (SELECT orderId, customerId, itemId, date, quant, price FROM exercise1);
CREATE TABLE customers AS (SELECT customerId, customerName, city FROM exercise1);
CREATE TABLE items AS (SELECT itemId, itemName FROM exercise1);

CREATE TABLE customersCounted AS (
	SELECT 
		customerId,
		customerName,
		city,
		ROW_NUMBER() OVER (
			PARTITION BY
				customerName,
				city
			ORDER BY
				customerName,
				city
		) row_num
	FROM 
		customers
);

CREATE TABLE customersUnique AS (SELECT customerId, customerName, city FROM customersCounted WHERE row_num=1);

CREATE TABLE itemsCounted AS (
	SELECT 
		itemId,
		itemName,
		ROW_NUMBER() OVER (
			PARTITION BY
				itemId,
				itemName
			ORDER BY
				itemId,
				itemName
		) row_num
	FROM 
		items
);

CREATE TABLE itemsUnique AS (SELECT itemId, itemName FROM itemsCounted WHERE row_num=1);

--NF2 base:
--orders, customersUnique, itemsUnique.

--NF3 - isolating cities

CREATE TABLE cities AS (SELECT city FROM customers);

CREATE TABLE citiesCounted AS (
	SELECT city, ROW_NUMBER() OVER (
		PARTITION BY city
		ORDER BY city
	) row_num FROM cities
);

CREATE TABLE citiesUnique AS (
	SELECT city, ROW_NUMBER() OVER (
		ORDER BY city asc
	) as cityID FROM citiesCounted WHERE row_num=1
);


CREATE TABLE customersUniqueCities AS ( 
	SELECT customerId, customerName, citiesUnique.cityId FROM customersUnique
	INNER JOIN citiesUnique
	ON customersUnique.city=citiesUnique.city
);
--NF3 complete
--Tables in: orders, citiesUnique, itemsUnique, customersUniqueCities

--Task 1.1
SELECT SUM(quant) FROM orders WHERE orderId=2302; --Quantity of items
SELECT SUM(price) FROM orders WHERE orderId=2302; --Total price for order

--Task 1.2 Look at the ID of top spender customer.
CREATE TABLE topSpenders AS (
	SELECT customerId, SUM(price) as totalSpent FROM orders
	GROUP BY customerId
	ORDER BY totalSpent
);
SELECT * FROM topSpenders;

