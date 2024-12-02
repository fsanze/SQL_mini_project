USE bicis;
-- Vemos todas las tablas
SHOW TABLES;

-- Seleccionamos datos de todas las tablas

SELECT*
FROM brands;

SELECT brand_name
FROM brands;

SELECT*
FROM categories;

SELECT category_name
FROM categories;

SELECT*
FROM customers;

SELECT state
FROM customers;

SELECT CONCAT(first_name, ' ', last_name) as nombre_completo
FROM customers;

SELECT*
FROM order_items;

SELECT*
FROM orders;

SELECT order_date
FROM orders;

SELECT order_date, required_date, shipped_date
FROM orders;

SELECT*
FROM products;

SELECT product_name, model_year
FROM products;

SELECT*
FROM staffs;

SELECT staff_id, CONCAT(first_name, ' ', last_name) as nombre_completo, email, phone
FROM staffs;

SELECT*
FROM stocks;

SELECT product_id, quantity
FROM stocks;

SELECT*
FROM stores;

SELECT store_id, store_name, city, state
FROM stores;

SELECT*
FROM products
WHERE brand_id = 9;

SELECT*
FROM products
WHERE list_price < 2000
ORDER BY list_price DESC;

SELECT*
FROM products
WHERE list_price BETWEEN 2000 AND 5000
ORDER BY list_price;

SELECT*
FROM customers
WHERE phone IS NOT NULL;

SELECT state, COUNT(state)
FROM customers
GROUP BY state;


-- mostrar todos los campos de la tabla customers, y agregar una columna adicional con el valor del número de teléfono. 
-- Si el número de teléfono es NULL, entonces se muestra el texto 'Not available'; si no es NULL, se muestra el número de teléfono tal como está.
SELECT *, 
CASE 
WHEN phone IS NULL THEN 'Not available'
ELSE phone
END AS phone
FROM customers; 


-- actualizar los valores de una o más columnas en un registro específico de una tabla
UPDATE customers
SET phone = 9172323532
WHERE customer_id=245;

SET SQL_SAFE_UPDATES = 1;


-- obtener los primeros 10 nombres de clientes más frecuentes en la tabla customers. 
-- Se agrupa por first_name y se cuenta cuántos clientes tienen el mismo nombre, mostrando los nombres que más se repiten.
SELECT first_name, COUNT(first_name) as client_number
from customers
GROUP BY first_name
ORDER BY client_number DESC
LIMIT 10;


-- obtener todos los registros de la tabla customers donde el valor de la columna email comienza con la cadena Al
SELECT *
FROM customers
WHERE email LIKE 'Al%';

-- Descuentos en order >=10%
SELECT *
FROM order_items
WHERE discount >= 0.1;

-- obtener el precio promedio de los productos por marca, pero solo incluir aquellas marcas cuyo precio promedio (list_price_AVG) sea mayor a 900
SELECT brand_id, ROUND(AVG(list_price)) AS list_price_AVG
FROM products
GROUP BY brand_id
HAVING list_price_AVG > 900;

-- la consulta mostrará los resultados agrupados por los identificadores de la marca y la categoría,

SELECT brand_id, category_id,  ROUND(AVG(list_price)) AS list_price_AVG
FROM products
WHERE model_year >=2017
GROUP BY brand_id, category_id
ORDER BY brand_id;

-- obtener el precio promedio de los productos, agrupados por marca y categoría, y filtrando por productos que tienen un año de modelo mayor o igual a 2017. 
-- Además, la consulta ordena los resultados por el nombre de la marca
SELECT brand_name, category_name,  ROUND(AVG(list_price)) AS list_price_AVG
FROM products
JOIN brands 
USING (brand_id)
JOIN categories
USING (category_id)
WHERE model_year >=2017
GROUP BY brand_name, category_name
ORDER BY brand_name;

-- La consulta que has proporcionado está diseñada para calcular el precio promedio (AVG(list_price)) de los productos de cada marca 
-- y luego ordenar los resultados por el precio promedio de forma descendente.
SELECT brand_name, ROUND(AVG(list_price)) AS list_price_AVG
FROM products
JOIN brands
USING (brand_id)
GROUP BY brand_name
ORDER BY list_price_AVG DESC;

-- información detallada sobre los pedidos realizados por los clientes, incluyendo detalles sobre el cliente, la tienda, los productos y las categorías de esos productos
SELECT order_id, s.store_name, CONCAT(c.first_name, ' ', c.last_name) as full_name, p.product_name, ca.category_name
FROM orders 
JOIN customers as c
USING (customer_id)
JOIN stores as s
USING (store_id)
JOIN order_items 
USING (order_id)
JOIN products as p
USING (product_id)
JOIN categories as ca
USING (category_id)
ORDER BY full_name;

-- Vamos a sacar el número de ventas/orders de bicicletas Trek de Road Bikes por estado usando subqueries_atope
SELECT state, COUNT(order_id)
FROM orders 
JOIN customers
USING (customer_id)
WHERE order_id IN (
	SELECT order_id 
	FROM order_items
    WHERE product_id IN (
		SELECT product_id
        FROM products
        WHERE brand_id IN(
			SELECT brand_id
            FROM brands
            WHERE brand_name = 'Trek')))
AND order_id IN (
	SELECT order_id 
	FROM order_items
    WHERE product_id IN (
		SELECT product_id
        FROM products
        WHERE category_id IN(
			SELECT category_id
            FROM categories
            WHERE category_name = 'Road Bikes')))
GROUP BY state;

-- catálogo de bicis

SELECT product_id, product_name, brand_name, category_name, model_year, list_price
FROM products
JOIN brands
USING (brand_id)
JOIN categories
USING (category_id)
WHERE brand_id
ORDER BY brand_name;

-- Usamos una Window para añadir el número de fila, Partition ordena por brand_name y 
-- ORDER BY list_price DESC: Ordena dentro de cada grupo (marca) por el precio de lista, de mayor a menor.
SELECT product_id, product_name, brand_name, category_name, model_year, list_price,
    ROW_NUMBER() OVER (PARTITION BY brand_name ORDER BY list_price DESC) AS row_num
FROM products
JOIN brands USING (brand_id)
JOIN categories USING (category_id)
WHERE brand_id IS NOT NULL
ORDER BY brand_name;

