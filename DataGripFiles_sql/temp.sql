/*
sql - это интерпритируемый язык, т.е. в момент запуск построчное выполнение
-- 'текст содержит''кавычку внутри' если в тексе есть кавычка одинарная то она экранируется второй кавычкой.

FROM academy.table_students   -- таблица к которой будем присоединяться
    JOIN academy.table_persons  -- кого будем присоединять
        ON academy.table_students.person_id = academy.table_persons.id   -- на основе какого правила присоединяем
условий ON может быть несколько, тогда они записываются через and, or и др.

SELECT COUNT(*) FROM table_products;
SELECT MIN(price), MAX(price), AVG(price) FROM table_products;
SELECT MIN(price), MAX(price), AVG(price), SUM(amount * price) FROM table_products;

SELECT price, SUM(amount) FROM table_products
    GROUP BY price
    HAVING price < 80;

where name like '%хлеб%'
where name like 'х_еб' - любая буква между х и е
where price BETWEEN 80 AND 150
WHERE price BETWEEN (SELECT MIN(price) FROM table_products)
    and ((SELECT AVG(price) FROM table_products)

where name BETWEEN 'батон' AND 'xлеб'

SELECT *
FROM table_products
WHERE name LIKE '%хлеб%';

SELECT *
FROM table_products
WHERE price BETWEEN (SELECT MIN(price)
                     FROM table_products)
    AND (SELECT AVG(price)
         FROM table_products);

SELECT *
FROM table_products
WHERE name BETWEEN 'батон' AND 'булочка с маком';

SELECT *
FROM table_products
WHERE name NOT IN ('хлеб', 'батон');
*/

-- хранимые процедуры
-- хранимые функции
-- триггеры
