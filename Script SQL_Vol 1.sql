Create DATABASE sql_vol1;
USE sql_vol1;
Create table costumers (
costumer_id integer not null PRIMARY KEY,
name varchar (30),
city varchar (50)
);

Create table products (
product_id int not null PRIMARY KEY,
product_name varchar (30),
price int
);

Create table orders (
order_id int not null,
costumer_id int not null,
product_id int not null,
quantity int ,
order_date date
);

INSERT INTO costumers (costumer_id, name, city)
VALUES 
('1', 'Andi', 'Jakarta'),
('2', 'Budi', 'Bandung'),
('3', 'Clara', 'Surabaya'),
('4', 'Della', 'Jakarta')
;
SELECT * FROM costumers;

INSERT INTO products (product_id, product_name, price)
VALUES
('101', 'Keyboard', '15000'),
('102', 'Mouse', '80000'),
('103', 'Headset', '250000'),
('104', 'Webcam', '300000');

SELECT * FROM products;

SET SQL_SAFE_UPDATES = 0;


UPDATE products
SET product_id = 101, price = 150000
WHERE product_name = 'Keyboard'
;
SELECT * FROM products;

INSERT INTO orders (order_id, costumer_id, product_id, 
quantity, order_date)
VALUES 
('1', '1', '101', '1', '2024-11-01'),
('2', '2', '102', '2', '2024-11-02'),
('3', '1', '103', '1', '2024-11-05'),
('4', '3', '104', '1', '2024-11-10'),
('5', '4', '102', '3', '2024-11-11');

SELECT * FROM orders;

#total pembelian setiap nama
Select c.name, SUM(price * o.quantity) AS total_sale
FROM products AS p JOIN orders AS o 
ON p.product_id = o.product_id JOIN costumers AS c 
ON o.costumer_id = c.costumer_id 
GROUP BY name
ORDER BY name;

#produk yang paling banyak dibeli
Select SUM(o.quantity) AS total_produk, product_name
FROM products AS p JOIN orders AS o 
ON p.product_id = o.product_id JOIN costumers AS c 
ON o.costumer_id = c.costumer_id 
GROUP BY product_name
-- HAVING total_produk > 3--
ORDER BY total_produk DESC
LIMIT 1
;


#orang jakarta pernah order apa (nama, produk)
Select c.name, product_name 
FROM products AS p JOIN orders AS o 
ON p.product_id = o.product_id JOIN costumers AS c 
ON o.costumer_id = c.costumer_id 
WHERE CITY = 'Jakarta'
ORDER BY c.name
;

#pendapatan toko dari semua transaksi
Select SUM(price * quantity) AS total_pendapatan 
FROM products AS p JOIN orders AS o 
ON p.product_id = o.product_id JOIN costumers AS c 
ON o.costumer_id = c.costumer_id 
;

#cek produk yang quantitynya lebih dari 1
Select * From Orders
WHERE quantity > 1
;

#total transaksi perproduk
SELECT * FROM products;
SELECT product_name, SUM(price) AS total_price
FROM products
GROUP BY product_name
ORDER BY total_price
;

#produk yang menghasilkan pendapatan paling besar (revenue)

SELECT product_name, SUM(p.price * o.quantity) 
AS total_revenue FROM 
products p JOIN orders o ON
p.product_id = o.product_id
GROUP BY product_name;

#costumer yang belanja lebih dari 1 jenis produk (nama, quantity)
SELECT * FROM products;
SELECT * FROM orders;

SELECT name, quantity FROM orders o
JOIN costumers c ON o.costumer_id = c.costumer_id
WHERE quantity > 1
;

#pilih Tampilkan data customer + produk tetapi hanya 
#untuk order yang quantity-nya PALING TINGGI dalam seluruh tabel.

SELECT product_name, name, quantity FROM costumers c JOIN 
orders o ON c.costumer_id = o.costumer_id
JOIN products ON o.product_id = o.product_id
ORDER BY quantity DESC
LIMIT 1
;

#costumer yang tidak pernah melakukan order (LEFT JOIN)
SELECT * FROM costumers c
LEFT JOIN orders o ON c.costumer_id = o.costumer_id
WHERE o.order_id IS NULL
;

#kategorikan level total spend costumer 

SELECT 
    c.name,
    SUM(p.price * o.quantity) AS total_spend,
    CASE
        WHEN SUM(p.price * o.quantity) >= 300000 THEN 'BIG SPENDER'
        WHEN SUM(p.price * o.quantity) >= 200000 
             AND SUM(p.price * o.quantity) < 300000 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS spender_level
FROM costumers c
JOIN orders o ON c.costumer_id = o.costumer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.name;

-- Ranking costumer berdasarkan total pengeluaran (terbesar-terkecil) --

WITH total_spending AS 
(SELECT c.name, SUM(p.price * o.quantity) AS total_spend
FROM 
costumers c
JOIN orders o ON c.costumer_id = o.costumer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.name
)

SELECT 
name,
total_spend,
RANK() OVER (ORDER BY total_spend DESC) AS rank_spend,
DENSE_RANK() OVER (ORDER BY total_spend DESC) AS dense_rank_spend
FROM total_spending
;

-- Ranking costumer berdasarkan total pengeluaran (terbesar-terkecil- perproduk ) --
WITH spend_per_product AS (
SELECT 
c.name,
p.product_name,
SUM(p.price * o.quantity) AS total_spend
FROM costumers c
JOIN orders o ON c.costumer_id = o.costumer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY name, p.product_name
)

SELECT
name,
product_name,
total_spend,
DENSE_RANK() OVER (
PARTITION BY product_name
ORDER BY total_spend DESC
) AS rank_within_product,
RANK () OVER (
PARTITION BY product_name
ORDER BY total_spend DESC
) AS rank_product
FROM spend_per_product
ORDER BY rank_within_product, rank_product DESC;


-- 3 produk paling banyak menghasilkan pendapatan (top 3 revenue ) --

SELECT product_name, 
SUM(p.price * o.quantity) AS revenue_product
FROM costumers c
JOIN orders o ON c.costumer_id = o.costumer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY product_name
ORDER BY revenue_product DESC
LIMIT 3
;

-- costumer yang memiliki pengeluaran diatas rata-rata seluruh costumer  --

SELECT SUM(o.quantity * p.price)
AS total_spend, name
FROM costumers c
JOIN orders o ON c.costumer_id = o.costumer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY name
HAVING SUM(p.price * o.quantity) > 
(
SELECT AVG (total_spend)
FROM (
SELECT 
SUM(p.price * o.quantity) AS total_spend
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY o.costumer_id) AS avg_table
); 

-- Hitung persentase kontribusi masing-masing produk terhadap total revenue keseluruhan --

SELECT product_name,
SUM(p.price * o.quantity) AS total_revenue,
SUM(p.price * o.quantity)*100/SUM(SUM(price * quantity))
OVER () AS percentage_products
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_name
;

-- Kelompokkan customer menjadi kategori berdasarkan total quantity yang dia beli --

SELECT name, 
COUNT(quantity) AS total_product,
CASE 
WHEN COUNT(quantity)  > 10 THEN 'Heavy Buyer'
WHEN COUNT(quantity) BETWEEN 5 AND 9 THEN 'Medium Buyer'
ELSE 'Light Buyer'
END AS category_buyer
FROM 
costumers c
JOIN orders o ON c.costumer_id = o.costumer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY name;

-- Tampilkan produk yang dibeli oleh hanya satu customer saja --




