
CREATE DATABASE market_db;
CREATE SCHEMA shop;


-- <TABLES>

CREATE TABLE table_products(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    price REAL NOT NULL CHECK (price >= 0),
    amount INTEGER NOT NULL CHECK (amount >= 0)
);

CREATE TABLE table_persons(
    id SERIAL NOT NULL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    patronymic TEXT
);

CREATE TABLE table_users(
    id SERIAL NOT NULL PRIMARY KEY,
    user_name TEXT NOT NULL UNIQUE,
    FOREIGN KEY (id) REFERENCES table_persons(id)
);

CREATE SEQUENCE basket_seq;
CREATE TABLE table_baskets(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL UNIQUE
        DEFAULT CONCAT_WS('_', 'basket', CURRENT_DATE, nextval('basket_seq')),
    FOREIGN KEY (user_id) REFERENCES table_users(id)
);

CREATE TABLE table_basket_products(
    id SERIAL NOT NULL PRIMARY KEY,
    basket_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    amount INTEGER NOT NULL CHECK (amount >= 0),
    FOREIGN KEY (basket_id) REFERENCES table_baskets(id),
    FOREIGN KEY (product_id) REFERENCES table_products(id)
);

CREATE TABLE table_order_statuses(
    id SERIAL NOT NULL PRIMARY KEY,
    status TEXT NOT NULL UNIQUE
);

CREATE TABLE table_orders(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIME NOT NULL DEFAULT CURRENT_TIME,
    status_id INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (id) REFERENCES table_baskets(id),
    FOREIGN KEY (status_id) REFERENCES table_order_statuses(id)
);

-- <TEST DATA>

INSERT INTO table_products (name, price, amount)
VALUES ('хлеб', 65, 10),
       ('батон', 84, 9),
       ('булочка с маком', 120, 11);

INSERT INTO table_products (name, price, amount)
VALUES ('чёрный хлеб', 65, 10);

DELETE FROM table_products WHERE id=4;

INSERT INTO table_persons (first_name, last_name, patronymic)
VALUES ('Иван', 'Иванов', 'Иванович'),
       ('Петр', 'Петров', 'Петрович'),
       ('Василий', 'Васильев', 'Васильевич');

INSERT INTO table_users (user_name)
VALUES ('ivan@ivanov.ru'),
       ('petya@petrov.ru'),
       ('vasiliy@vasiliev.ru');

INSERT INTO table_order_statuses(status)
VALUES ('Не определено'),
       ('Ожидает'),
       ('Выполнено'),
       ('Отменено');

INSERT INTO table_baskets (user_id)
VALUES ((SELECT id FROM table_users WHERE user_name = 'ivan@ivanov.ru')),
       ((SELECT id FROM table_users WHERE user_name = 'petya@petrov.ru'));

INSERT INTO table_orders (date, time)
VALUES ('2020-01-01', '12:00:00'),
       ('2020-01-02', '13:00:00');

-- </TEST DATA>

-- </TABLES>

-- <VIEWS>

CREATE VIEW view_orders AS
    SELECT table_orders.id AS id,
           table_orders.date AS date,
           table_orders.time AS time,
           table_order_statuses.status AS status,
           table_baskets.name AS basket_name
    FROM table_orders
        JOIN table_order_statuses
            ON table_orders.status_id = table_order_statuses.id
        JOIN table_baskets
            ON  table_orders.id = table_baskets.id;

CREATE VIEW view_user_baskets AS
    SELECT table_users.user_name AS user_name,
           table_baskets.name AS basket_name
    FROM table_baskets
        JOIN table_users
            ON table_baskets.user_id = table_users.id;

CREATE VIEW view_users AS
    SELECT table_users.id AS id,
           table_users.user_name AS user_name,
           CONCAT(table_persons.last_name, ' ', table_persons.first_name, ' ', table_persons.patronymic) AS full_name
    FROM table_users
        JOIN table_persons
            ON table_users.id = table_persons.id;

CREATE VIEW view_orders_users AS
    SELECT view_orders.id AS id,
           view_orders.date AS date,
           view_orders.time AS time,
           view_orders.status AS status,
           view_orders.basket_name AS basket_name,
           view_users.full_name AS user_full_name,
           view_users.user_name AS user_name
    FROM view_orders
        JOIN view_user_baskets
            ON view_orders.basket_name = view_user_baskets.basket_name
        JOIN view_users
            ON view_user_baskets.user_name = view_users.user_name;

-- </VIEWS>

-- <SELECTS>

SELECT COUNT(*) FROM table_products;   -- выводит 3 (количество записей в table_products)
SELECT MIN(price), MAX(price), ROUND(AVG(price)::numeric,2) FROM table_products; -- какая у нас большая цена, меньшая цена и средняя цена на продукты
SELECT MIN(price), MAX(price), AVG(price), SUM(amount * price) FROM table_products;

--группировать товары по той или иной цены (количество продуктов определенной цены)
SELECT price, SUM(amount)   -- сумма будет браться из GROUP BY price и считаться правильно по одной цене
FROM table_products
GROUP BY price;

-- выбираем те группы которые меньше 80
SELECT price, SUM(amount)
FROM table_products
GROUP BY price
HAVING price < 80;
--HAVING указывает, какие группы будут включены в выходной результат, то есть выполняет фильтрацию групп.
-- Его использование аналогично применению оператора WHERE. Но WHERE не работает с GROUP BY

SELECT *
FROM table_products
WHERE name LIKE '%хлеб%';  -- любое количество до и после слова хлеб
-- name = 'хлеб' точное указание не находит 'черный хлеб'
-- name LIKE 'х_еб' - нижнее подчеркивание любой пропущенный символ

SELECT *
FROM table_products         -- MIN(price) нельзя сразу использовать нужно делать подзапрос
WHERE price BETWEEN (SELECT MIN(price)        -- подзапрос SELECT MIN(price) FROM table_products
                     FROM table_products)
    AND (SELECT AVG(price)
         FROM table_products);

SELECT *
FROM table_products
WHERE price BETWEEN 80 AND 150;  --

SELECT *
FROM table_products
WHERE name BETWEEN 'батон' AND 'булочка с маком';

SELECT *
FROM table_products
WHERE name NOT IN ('хлеб', 'батон');

SELECT *
FROM table_products;

SELECT *
FROM view_users;

-- </SELECTS>

-- ALTER TABLE table_users ADD UNIQUE (name);