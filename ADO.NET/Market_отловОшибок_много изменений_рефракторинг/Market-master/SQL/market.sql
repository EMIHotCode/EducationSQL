
-- CREATE DATABASE market_db;
-- CREATE SCHEMA test;


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
           table_persons.last_name AS last_name,
           table_persons.first_name AS first_name,
           table_persons.patronymic AS patronymic
           --CONCAT(table_persons.last_name, ' ', table_persons.first_name, ' ', table_persons.patronymic) AS full_name
    FROM table_users
        JOIN table_persons
            ON table_users.id = table_persons.id;

CREATE VIEW view_orders_users AS
    SELECT view_orders.id AS id,
           view_orders.date AS date,
           view_orders.time AS time,
           view_orders.status AS status,
           view_orders.basket_name AS basket_name,
           CONCAT(view_users.last_name, ' ', view_users.first_name, ' ', view_users.patronymic) AS user_full_name,
           view_users.user_name AS user_name
    FROM view_orders
        JOIN view_user_baskets
            ON view_orders.basket_name = view_user_baskets.basket_name
        JOIN view_users
            ON view_user_baskets.user_name = view_users.user_name;

-- </VIEWS>


-- <PROCEDURES>

CREATE OR REPLACE PROCEDURE procedure_insert_person(
    IN _first_name TEXT,
    IN _last_name TEXT,
    IN _patronymic TEXT,
    IN _user_name TEXT)
LANGUAGE plpgsql
AS
$$
DECLARE
    _id INT;
BEGIN
    IF NOT EXISTS(SELECT *
              FROM table_persons
              WHERE first_name = _first_name
                AND last_name = _last_name
                AND patronymic = _patronymic) THEN
        INSERT INTO table_persons (first_name, last_name, patronymic)
        VALUES (_first_name, _last_name, _patronymic);

        SELECT id INTO _id
        FROM table_persons
        WHERE first_name = _first_name
            AND last_name = _last_name
            AND patronymic = _patronymic;

        IF NOT EXISTS(SELECT *
                      FROM table_users
                      WHERE user_name = _user_name) THEN
            INSERT INTO table_users (id, user_name)
            VALUES (_id, _user_name);

            COMMIT;
        ELSE
            ROLLBACK;
        END IF;
    ELSE
        ROLLBACK;
    END IF;
END;
$$;

/*CREATE OR REPLACE PROCEDURE procedure_insert_person(
    IN _first_name TEXT,
    IN _last_name TEXT,
    IN _patronymic TEXT,
    IN _user_name TEXT)
LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT EXISTS(SELECT *
              FROM table_persons
              WHERE first_name = _first_name
                AND last_name = _last_name
                AND patronymic = _patronymic)
           AND NOT EXISTS(SELECT *
                          FROM table_users
                          WHERE user_name = _user_name) THEN
        INSERT INTO table_persons (first_name, last_name, patronymic)
        VALUES (_first_name, _last_name, _patronymic);

        INSERT INTO table_users (user_name)
        VALUES (_user_name);
    END IF;
END;
$$;*/

-- </PROCEDURES>

-- <TEST DATA>

INSERT INTO table_products (name, price, amount)
VALUES ('хлеб', 65, 10),
       ('батон', 84, 9),
       ('булочка с маком', 120, 11);

INSERT INTO table_persons (first_name, last_name, patronymic)
VALUES ('Иван', 'Иванов', 'Иванович'),
       ('Петр', 'Петров', 'Петрович'),
       ('Василий', 'Васильев', 'Васильевич');

INSERT INTO table_users (user_name)
VALUES ('ivan@ivanov.ru'),
       ('petya@petrov.ru'),
       ('vasiliy@vasiliev.ru');

CALL procedure_insert_person('Иван', 'Иванов', 'Иванович', 'ivan@ivanov.ru');
CALL procedure_insert_person('Иван', 'Иванов', 'Иванович', '1@ivanov.ru');
CALL procedure_insert_person('Иван1', 'Иванов', 'Иванович', 'ivan@ivanov.ru');
CALL procedure_insert_person('Иван1', 'Иванов', 'Иванович', 'ivan1@ivanov.ru');

-- TRUNCATE TABLE table_persons RESTART IDENTITY CASCADE;


INSERT INTO table_order_statuses(status)
VALUES ('Не определено'),
       ('Ожидает'),
       ('Выполнено'),
       ('Отменено');

INSERT INTO table_baskets (user_id)
VALUES ((SELECT id FROM table_users WHERE user_name = 'ivan@ivanov.ru')),
       ((SELECT id FROM table_users WHERE user_name = 'petya@petrov.ru'));

INSERT INTO table_orders (date, time)
VALUES (default, '12:00:00'),
       ('2020-01-02', '13:00:00');

-- </TEST DATA>

-- <SELECTS>

SELECT COUNT(*) FROM table_products;
SELECT MIN(price), MAX(price), AVG(price) FROM table_products;
SELECT MIN(price), MAX(price), AVG(price), SUM(amount * price) FROM table_products;

SELECT price, SUM(amount)
FROM table_products
GROUP BY price
HAVING price < 80;

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

SELECT *
FROM table_products;

SELECT *
FROM view_users;

-- </SELECTS>

-- ALTER TABLE table_users ADD UNIQUE (name);

-- <LOG>

CREATE SCHEMA log;

CREATE TYPE dml_type AS ENUM ('INSERT', 'UPDATE', 'DELETE');
CREATE TABLE log.table_dml_logs (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    schema_name TEXT NOT NULL,
    table_name TEXT NOT NULL,
    old_row_data jsonb,
    new_row_data jsonb,
    dml_type dml_type NOT NULL,
    dml_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dml_user_name TEXT NOT NULL DEFAULT CURRENT_USER
);

CREATE OR REPLACE PROCEDURE log.procedure_insert_log(
    IN _schema_name TEXT,
    IN _table_name TEXT,
    IN _old_row_data jsonb,
    IN _new_row_data jsonb,
    IN _dml_type dml_type)
LANGUAGE SQL
BEGIN ATOMIC
    INSERT INTO log.table_dml_logs (schema_name, table_name, old_row_data, new_row_data, dml_type)
    VALUES (_schema_name, _table_name, _old_row_data, _new_row_data, _dml_type);
END;

CREATE OR REPLACE FUNCTION log.function_dml_log()
    RETURNS trigger
LANGUAGE plpgsql AS
$$
BEGIN
    IF (tg_op = 'INSERT') THEN
        CALL log.procedure_insert_log(tg_table_schema, tg_table_name, NULL, to_jsonb(NEW), 'INSERT');
        RETURN NEW;
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

-- <TRIGGERS>

CREATE TRIGGER trigger_dml_log_for_table_products
AFTER INSERT OR UPDATE OR DELETE
    ON table_products
    FOR EACH ROW
EXECUTE FUNCTION log.function_dml_log();

CREATE TRIGGER trigger_dml_log_for_table_baskets
AFTER INSERT OR UPDATE OR DELETE
    ON table_baskets
    FOR EACH ROW
EXECUTE FUNCTION log.function_dml_log();

-- </TRIGGERS
