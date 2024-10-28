CREATE SCHEMA IF NOT EXISTS test_lesson3;

CREATE TABLE table_users (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE table_in (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    person_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES table_users(id)
);

CREATE TABLE table_out (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    person_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES table_users(id)
);

INSERT INTO table_users (name)
VALUES ('John'), ('Mary'), ('Jane');

INSERT INTO table_in (date, time, person_id)
VALUES ('2020-01-01', '12:00:00', 1),
       ('2020-01-01', '12:00:00', 2);

INSERT INTO table_out (date, time, person_id)
VALUES ('2020-01-01', '12:00:00', 1),
       ('2020-01-01', '12:00:00', 3);

-- входившие и выходившие люди
SELECT table_in.date,
       table_in.time,
       table_users.name
FROM table_in
JOIN table_users
    ON table_in.person_id = table_users.id;

-- ни разу не вошел
SELECT table_in.date,
       table_in.time,
       table_users.name
FROM table_in
RIGHT JOIN table_users
    ON table_in.person_id = table_users.id
WHERE table_in.date IS NULL;

-- ни разу не вышел
SELECT table_out.date,
       table_out.time,
       table_users.name
FROM table_out
RIGHT JOIN table_users
    ON table_out.person_id = table_users.id
WHERE table_out.date IS NULL;

SELECT COUNT(*) -- считает количество строчек
FROM table_in
WHERE table_in.person_id = (SELECT id FROM table_users WHERE name = 'Jane');

SELECT id FROM table_users WHERE name = 'Mary';


SELECT COUNT([{DISTINCT | ALL }] ANY:any)
FROM table_out;

SELECT COUNT(table_out.id)
FROM table_out
RIGHT JOIN table_users
    ON table_out.person_id = table_users.id
WHERE table_out.date IS NULL;
