CREATE DATABASE phonebook_db;
CREATE SCHEMA test;

-- <TABLES>

-- /*
-- drop table test.table_phones cascade;
-- drop table test.table_persons cascade;
-- drop table test.table_phone_types cascade;
-- */

CREATE TABLE table_persons (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    last_name TEXT NULL DEFAULT NULL,
    patronymic TEXT NULL DEFAULT NULL
);

CREATE TABLE table_phone_types (
    id SERIAL NOT NULL PRIMARY KEY,
    type TEXT NOT NULL UNIQUE
);

CREATE TABLE table_phones (
    id SERIAL NOT NULL PRIMARY KEY,
    person_id INT NOT NULL,
    phone TEXT NOT NULL,
    phone_type_id INT NOT NULL,
    comment TEXT NULL,
    FOREIGN KEY (person_id) REFERENCES table_persons(id),
    FOREIGN KEY (phone_type_id) REFERENCES table_phone_types(id)
);

-- </TABLES>

-- <VIEWS>

CREATE view view_person_phones AS
    SELECT table_phones.id AS id,
           table_persons.name AS name,
           table_persons.last_name AS last_name,
           table_persons.patronymic AS patronymic,
           table_phone_types.type AS phone_type,
           table_phones.phone AS phone_number,
           table_phones.comment AS comment
    FROM table_phones
        JOIN table_persons
            ON table_phones.person_id = table_persons.id
        JOIN table_phone_types
            ON table_phones.phone_type_id = table_phone_types.id;

-- </VIEWS>

-- TEST DATA
INSERT INTO table_persons (name, last_name, patronymic)
VALUES ('Ivan', 'Ivanov', 'Ivanovich'),
       ('Petr', DEFAULT, DEFAULT),
       ('Vasya R', NULL, NULL),
       ('Sidorov Sidor Sidorovich', DEFAULT, NULL);

INSERT INTO table_phone_types (type)
VALUES ('mobile'),
       ('home'),
       ('work');

INSERT INTO table_phones (person_id, phone, phone_type_id, comment)
VALUES (1, '+7(999)999-99-99', 1, NULL),
       (1, '+7(999)999-99-99', 2, 'test'),
       (2, '+7(999)999-99-99', 1, NULL),
       (2, '+7(999)999-99-99', 1, NULL),
       (3, '+7(999)999-99-99', 1, NULL),
       (3, '+7(999)999-99-99', 3, 'test'),
       (4, '+7(999)999-99-99', 1, NULL),
       (4, '+7(999)999-99-99', 2, 'test'),
       (4, '+7(999)999-99-99', 3, 'test');

SELECT * FROM view_person_phones;