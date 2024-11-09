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


--Практический курс по SQL для начинающих - #3 Соединения (JOIN)
-- вывести наименование продукта, наименование компании и количество этого продукта в продаже
SELECT product_name, suppliers.company_name, units_in_stock
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id;

-- сколько единиц товаров в продаже по категориям товаров (приправы, напитки, сладости, и др)
SELECT category_name, SUM(units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT 5;

-- на какую сумму в денежном эквиваленте товаров продается в каждой конкретной категории (фильтр discontinued != 1 товар больше не будет в продаже),
    -- а так же отфильтровать товар, который продается меньше чем на 5000
SELECT category_name, SUM(unit_price * units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
WHERE discontinued <> 1
GROUP BY category_name
HAVING SUM(unit_price * units_in_stock) > 5000  -- выведем товар общая сумма продаж которого более 5000
ORDER BY SUM(unit_price * units_in_stock) DESC;

--На каких работниках завязаны заказы
SELECT order_id, customer_id, first_name, last_name, title
FROM orders
INNER JOIN employees ON orders.employee_id = employees.employee_id;

--В результирующий набор поместить дату сделанного заказа,
-- какой товар был заказан, куда его доставить в какую страну, цену, количество и скидку
SELECT order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id;

-- LEFT JOIN
-- определить компании на которых не висят никакие заказы, это делается при помощи LEFT JOIN
SELECT company_name, order_id
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
WHERE order_id IS NULL;

-- есть ли работники которые не обрабатывают никакие заказы
SELECT last_name, order_id   -- SELECT COUNT(*)  для подсчета количества работников не занятых ничем
FROM employees
LEFT JOIN orders ON orders.employee_id = employees.employee_id
WHERE order_id IS NULL;
-- остановился на 35:24 https://yandex.ru/video/preview/14978149577077395548
