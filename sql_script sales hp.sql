SELECT * FROM latihan_kaggle.global_mobile_prices_2025_extended;

#nyari 10 HP dengan harga tertinggi
SELECT brand, model, price_usd 
FROM latihan_kaggle.global_mobile_prices_2025_extended
ORDER BY price_usd DESC
LIMIT 10;

#nyari android
SELECT * FROM latihan_kaggle.global_mobile_prices_2025_extended
WHERE os="Android";

#RAM HP >=12
SELECT * FROM latihan_kaggle.global_mobile_prices_2025_extended
WHERE ram_gb >="12";

#Tampilkan HP dengan baterai lebih dari 5000 mAh dan harga < $600
SELECT * FROM latihan_kaggle.global_mobile_prices_2025_extended
WHERE battery_mah > "5000" AND price_usd < "600";

#Urutkan semua HP dari yang baterainya paling besar sampai paling kecil.
SELECT brand, model, battery_mah from latihan_kaggle.global_mobile_prices_2025_extended
ORDER BY battery_mah DESC;

SELECT brand, model, battery_mah from latihan_kaggle.global_mobile_prices_2025_extended
ORDER BY battery_mah;

#Hitung berapa total HP dalam dataset.
SELECT count(price_usd), brand FROM latihan_kaggle.global_mobile_prices_2025_extended
GROUP BY brand;

#Hitung rata-rata harga HP Android.
SELECT AVG (price_usd) FROM latihan_kaggle.global_mobile_prices_2025_extended;

#Cari harga tertinggi, terendah, dan rata-rata untuk setiap brand

SELECT max(price_usd), brand FROM latihan_kaggle.global_mobile_prices_2025_extended
GROUP BY brand;

SELECT min(price_usd), brand FROM latihan_kaggle.global_mobile_prices_2025_extended
GROUP BY brand;

SELECT avg(price_usd), brand FROM latihan_kaggle.global_mobile_prices_2025_extended
GROUP BY brand;

#Tampilkan semua model yang memiliki kata “Pro” di bagian nama.

SELECT * FROM latihan_kaggle.global_mobile_prices_2025_extended
Where model LIKE "Pro";

#Cari HP dengan harga antara 300–700 USD.

SELECT (brand), price_usd FROM latihan_kaggle.global_mobile_prices_2025_extended
Where price_usd between "300" AND "700";

#Tampilkan HP dengan display size antara 6.5–7.0 inch.

SELECT (brand), model, display_size_inch FROM latihan_kaggle.global_mobile_prices_2025_extended
Where display_size_inch between "6.5" AND "7.0" ORDER BY display_size_inch;


