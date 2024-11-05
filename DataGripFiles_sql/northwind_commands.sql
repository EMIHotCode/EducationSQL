SELECT *
FROM orders
WHERE ship_country LIKE 'U%';

SELECT order_id, customer_id, orders.freight, orders.ship_country
FROM orders
WHERE ship_country LIKE 'N%'
ORDER BY freight DESC
LIMIT 5;

SELECT first_name, last_name, home_phone, region
FROM employees
WHERE region IS NULL;

-- подсчитать количество доставщиков (которые доставляют товары в Northwind) и сгруппировать их по странам
SELECT country, COUNT(*)
FROM suppliers     -- поставщики
GROUP BY country -- группируем по странам
ORDER BY COUNT(*) DESC; -- сортируем по количеству по нисхождению

-- найти суммарный вес по заказам, сгруппировать по странам доставки ship_country, отфильтровать по ship_region != null


--На каких работниках завязаны заказы
SELECT order_id, customer_id, first_name, last_name, title
FROM orders
INNER JOIN employees ON orders.employee_id = employees.employee_id