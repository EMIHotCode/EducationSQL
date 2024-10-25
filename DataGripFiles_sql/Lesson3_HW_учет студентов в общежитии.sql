--ДЗ.
--Создать базу данных для учёта проходящих студентов в общежитие по карточкам доступа.
-- - показать информацию какие студенты ни разу не входили
-- - показать информацию какие студенты ни разу не выходили
-- - показать информацию о входе и выходе студентов за определённый день

--DROP SCHEMA pass_card CASCADE;
CREATE SCHEMA IF NOT EXISTS pass_card;

CREATE TABLE pass_card.table_person(
    id SERIAL NOT NULL PRIMARY KEY,
    first_name TEXT NOT NULL, -- имя
    last_name TEXT NOT NULL,  -- фамилия
    patronymic TEXT,          -- отчество
    birthday DATE NOT NULL    -- дата рождения
);

CREATE TABLE pass_card.table_dormitory(  -- название общежития к которому подходит карточка доступа
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE pass_card.table_student(
    id SERIAL NOT NULL PRIMARY KEY,
    fio_id INTEGER NOT NULL,        -- id данных из table_person
    dormitory_id INTEGER NOT NULL,  -- id общежития table_dormitory
    room_number INTEGER NOT NULL,   -- номер комнаты
    FOREIGN KEY (fio_id) REFERENCES pass_card.table_person(id),
    FOREIGN KEY (dormitory_id) REFERENCES pass_card.table_dormitory(id)
);

CREATE TABLE pass_card.table_passing_by_card(  -- таблица студентов проходящих по карточкам
    id SERIAL NOT NULL PRIMARY KEY,
    student_id INTEGER NOT NULL,  -- id данные о студенте из table_student
    date DATE NULL,               -- дата входа в общежитие
    num_enter INT DEFAULT NULL,   -- число входов
    num_exit INT DEFAULT 0,       -- число выходов
    FOREIGN KEY (student_id) REFERENCES pass_card.table_student(fio_id)
);

INSERT INTO pass_card.table_person (first_name, last_name, patronymic, birthday) VALUES
        ('Ivan','Ivanov','Ivanovich','2002-02-03'),
        ('Petr','Petrov','Ivanovich','2005-10-03');

INSERT INTO pass_card.table_dormitory (name) VALUES
        ('Общежитие №1'),
        ('Общежитие №2'),
        ('Общежитие №3');

INSERT INTO pass_card.table_student(fio_id, dormitory_id, room_number)
VALUES (
        (SELECT id
         FROM pass_card.table_person
         WHERE first_name = 'Ivan'
           AND last_name = 'Ivanov'
           AND patronymic = 'Ivanovich'),
        (SELECT id
         FROM pass_card.table_dormitory
         WHERE name = 'Общежитие №2'),
        201),
    ((SELECT id
         FROM pass_card.table_person
         WHERE first_name = 'Petr'
           AND last_name = 'Petrov'
           AND patronymic = 'Ivanovich'),
        (SELECT id
         FROM pass_card.table_dormitory
         WHERE name = 'Общежитие №3'),
        122);

SELECT * FROM pass_card.table_passing_by_card;

INSERT INTO pass_card.table_passing_by_card (student_id, date, num_enter, num_exit)
VALUES (
        (SELECT id
         FROM pass_card.table_student
         WHERE pass_card.table_student.id = 1),
        '2024-10-23',
        5,
        7
       ),
        ((SELECT id
         FROM pass_card.table_student
         WHERE pass_card.table_student.id = 2),
        '2023-02-23',
        5,
        7
       );



/* входили в заданную дату */
SELECT  pass_card.table_person.first_name
    FROM pass_card.table_passing_by_card
        JOIN table_person ON  table_passing_by_card.student_id = table_person.id
WHERE table_passing_by_card.date = '2023-02-23'
AND table_passing_by_card.num_enter - table_passing_by_card.num_exit < 0;

/* ни разу не входили или ни разу не выходили
SELECT  dormitory.person.first_name,
        dormitory.person.last_name,
       dormitory.person.patronymic,
       dormitory.report.action_id
FROM dormitory.person
LEFT JOIN dormitory.report
     ON dormitory.report.person_id=dormitory.person.id
WHERE   dormitory.report.person_id IS NULL;


SELECT *
FROM dormitory.person
WHERE NOT EXISTS(
    SELECT dormitory.person.first_name,
           dormitory.person.last_name,
           dormitory.person.patronymic,
     dormitory.report.action_id
    FROM dormitory.report
    WHERE dormitory.report.person_id=dormitory.person.id
);
*/

/*кто ни разу не входил и ни разу не выходил
SELECT  dormitory.person.first_name,
        dormitory.person.last_name,
       dormitory.person.patronymic,
       dormitory.report.day,
       dormitory.report.time
FROM dormitory.report
RIGHT JOIN dormitory.person
     ON dormitory.report.person_id=dormitory.person.id
WHERE   dormitory.report.day IS NULL;
*/

/*никогда не входил в определенную дату
SELECT dormitory.person.first_name,
        dormitory.person.last_name,
        dormitory.person.patronymic
FROM dormitory.person
EXCEPT
SELECT  dormitory.person.first_name,
        dormitory.person.last_name,
        dormitory.person.patronymic
FROM dormitory.report
JOIN dormitory.person
     ON dormitory.report.person_id=dormitory.person.id
JOIN dormitory.action
        ON dormitory.report.action_id=dormitory.action.id
WHERE  dormitory.report.day='13.09.2024'
AND  dormitory.report.action_id=1;
*/

/*никогда не выходил в определенную дату
SELECT dormitory.person.first_name,
        dormitory.person.last_name,
        dormitory.person.patronymic
FROM dormitory.person
EXCEPT
SELECT  dormitory.person.first_name,
        dormitory.person.last_name,
        dormitory.person.patronymic
FROM dormitory.report
JOIN dormitory.person
     ON dormitory.report.person_id=dormitory.person.id
JOIN dormitory.action
        ON dormitory.report.action_id=dormitory.action.id
WHERE  dormitory.report.day='13.09.2024'
AND  dormitory.report.action_id=2;
*/
