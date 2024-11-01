
CREATE DATABASE market_db;
CREATE SCHEMA shop;


-- <TABLES>

CREATE TABLE table_products(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE, -- поле должно быть уникальным
    price REAL NOT NULL CHECK (price >= 0), -- проверка на то чтобы было больше нуля
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
    FOREIGN KEY (id) REFERENCES table_persons(id) -- внешний ключ тоже проверка
    --при попытке добавить в table_users айдишника которого нет в table_persons мы получим ошибку
    -- тоесть позволяет не добавлять отсутствующие id в table_users
);

CREATE SEQUENCE basket_seq;   -- Счетчик, который создаем специально. Будет изменяться на единицу когда будем вызывать функцию nextval

CREATE TABLE table_baskets(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL UNIQUE
        DEFAULT CONCAT_WS('_', 'basket', CURRENT_DATE, nextval('basket_seq')),
    -- CONCAT_WS говорит о том что значения 'basket', CURRENT_DATE, nextval('basket_seq')
    -- будут объединяться через нижнее подчеркивание в одну строку
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
    date DATE NOT NULL DEFAULT CURRENT_DATE, -- ставятся исходя из текущей даты
    time TIME NOT NULL DEFAULT CURRENT_TIME, -- ставятся исходя из текущего времени
    status_id INTEGER NOT NULL DEFAULT 1, -- по умолчанию будет браться 1 значение из таблицы статусов
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

-- создается view для 3 полей id, user_name, full_name
CREATE VIEW view_users AS
    SELECT table_users.id AS id,
           table_users.user_name AS user_name,
           CONCAT(table_persons.last_name, ' ', table_persons.first_name, ' ', table_persons.patronymic) AS full_name
    FROM table_users
        JOIN table_persons
            ON table_users.id = table_persons.id;

-- view на основе данных двух других view-шек
CREATE VIEW view_orders_users AS
    SELECT view_orders.id AS id,
           view_orders.date AS date,
           view_orders.time AS time,
           view_orders.status AS status,
           view_orders.basket_name AS basket_name,
           view_users.full_name AS user_full_name,
           view_users.user_name AS user_name
    FROM view_orders
        -- JOIN не по id а по уникальным полям
        JOIN view_user_baskets -- соединение через промежуточную третью таблицу view_user_baskets
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

-- <LOG>

CREATE SCHEMA log; -- создаем схему

CREATE TYPE dml_type AS ENUM ('INSERT', 'UPDATE', 'DELETE');
CREATE TABLE log.table_dml_logs (  -- создаем таблицу
    id BIGSERIAL NOT NULL PRIMARY KEY,  -- записей много
    schema_name TEXT NOT NULL,          -- имя схемы (т.е. в какой схеме происходили записи тестовая или боевая)
    table_name TEXT NOT NULL,        -- таблица в которой мы производим действия
    old_row_data jsonb,              -- старые данные которые будут храниться
    new_row_data jsonb,              -- какие новые данные
    dml_type dml_type NOT NULL,      -- тип события из ENUM который будет происходить
    dml_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- когда произошло событие
    dml_user_name TEXT NOT NULL DEFAULT CURRENT_USER      --  кем было сделано имя юзера который произвел действие (изменения в таблице)
);
--CREATE OR REPLACE  создать или заменить
--procedure_insert_log - это имя процедуры
CREATE OR REPLACE PROCEDURE log.procedure_insert_log( -- это хранимая процедура, которая поможет записывать в таблицу table_dml_logs действия
    IN _schema_name TEXT,  -- входящие данные имя схемы
    IN _table_name TEXT,   -- входящие данные имя таблицы
    IN _old_row_data jsonb, -- входящие данные старые данные
    IN _new_row_data jsonb, -- входящие данные новые данные
    IN _dml_type dml_type)  -- входящие данные dml тип
LANGUAGE SQL  -- на каком языке будем писать запрос
BEGIN ATOMIC
    INSERT INTO log.table_dml_logs (schema_name, table_name, old_row_data, new_row_data, dml_type)
    VALUES (_schema_name, _table_name, _old_row_data, _new_row_data, _dml_type);
END;

-- BEGIN ATOMIC   END;
-- AS $$          $$; альтернатива

CREATE OR REPLACE FUNCTION log.function_dml_log()
    RETURNS trigger  -- функция возвращает триггер
LANGUAGE plpgsql AS
$$
BEGIN
    IF (tg_op = 'INSERT') THEN  -- tg_op зарезервированная переменная в которой храниться тип операции которая вызвала триггер
        -- CALL вызываем функцию
        CALL log.procedure_insert_log(tg_table_schema, tg_table_name, NULL, to_jsonb(NEW), 'INSERT');  --jsonb бинарный вид
        RETURN NEW;  -- чтобы вернула триггер
    ELSEIF (tg_op = 'UPDATE') THEN
        CALL log.procedure_insert_log(tg_table_schema, tg_table_name, to_jsonb(OLD), to_jsonb(NEW), 'UPDATE');
        RETURN NEW;
    ELSEIF (tg_op = 'DELETE') THEN
        CALL log.procedure_insert_log(tg_table_schema, tg_table_name, to_jsonb(OLD), NULL, 'DELETE');
        RETURN OLD;
    END IF;
END;
$$;

-- </LOG>

-- <TRIGGERS> - это недофункция которые срабатывают при определенных событиях и вызывают какую то функцию
-- триггер пишется для каждой таблицы свой
CREATE TRIGGER trigger_dml_log_for_table_products --trigger_dml_log комманды манипуляции dml для логирования  для таблицы for_table_products
AFTER INSERT OR UPDATE OR DELETE
    ON table_products
    FOR EACH ROW -- для каждой строчки будет срабатывать триггер
EXECUTE FUNCTION log.function_dml_log();  -- что мы будем выполнять

CREATE TRIGGER trigger_dml_log_for_table_baskets
AFTER INSERT OR UPDATE OR DELETE
    ON table_baskets
    FOR EACH ROW
EXECUTE FUNCTION log.function_dml_log();

-- </TRIGGERS