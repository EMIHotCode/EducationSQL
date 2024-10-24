--Задание.
--Создать таблицы для хранения данных о студенте:
-- - ФИО
-- - дата рождения
-- - телефон
-- - факультет
-- - дата поступления

CREATE SCHEMA IF NOT EXISTS academy_lesson3;
--DROP TABLE academy.table_persons;
--DROP SCHEMA academy CASCADE;

CREATE TABLE academy_lesson3.table_persons(
    id SERIAL NOT NULL PRIMARY KEY,
    first_name TEXT NOT NULL, -- имя
    last_name TEXT NOT NULL,  -- фамилия
    patronymic TEXT,          -- отчество
    birthday DATE NOT NULL    -- дата рождения
);

CREATE TABLE academy_lesson3.table_phones(
    id SERIAL NOT NULL PRIMARY KEY,
    number TEXT NOT NULL,          -- телефон студента
    person_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES academy_lesson3.table_persons(id)
);

-- Можно добавить адрес проживания студента (домашний или рабочий) с привязкой по id. НЕ ПО ЗАДАНИЮ
-- Если нужно к любому человеку добавить какой-нибудь новое поле данных то по ссылке не изменяя таблицу person
CREATE TABLE academy_lesson3.table_addresses(
    id SERIAL NOT NULL PRIMARY KEY,
    type_of_address TEXT NOT NULL,
    address TEXT NOT NULL,
    person_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES academy_lesson3.table_persons(id)
);

CREATE TABLE academy_lesson3.table_faculties(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL          -- факультет
);

CREATE TABLE academy_lesson3.table_students(
    id SERIAL NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    faculty_id INTEGER NOT NULL,
    date_of_join DATE NOT NULL,     -- дата поступления
    FOREIGN KEY (person_id) REFERENCES academy_lesson3.table_persons(id),
    FOREIGN KEY (faculty_id) REFERENCES academy_lesson3.table_faculties(id)
);


CREATE TABLE academy_lesson3.table_teachers(   -- Таблица преподавателей
    id SERIAL NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    faculty_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES academy_lesson3.table_persons(id),
    FOREIGN KEY (faculty_id) REFERENCES academy_lesson3.table_faculties(id)
);

CREATE TABLE academy_lesson3.table_subjects(  -- Предметы, которые ведут преподаватели
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE academy_lesson3.table_subjects_teachers(  -- Связка преподавателей с предметами, которые они ведут
    id SERIAL NOT NULL PRIMARY KEY,
    subject_id INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES academy_lesson3.table_subjects(id),
    FOREIGN KEY (teacher_id) REFERENCES academy_lesson3.table_teachers(id)
);


INSERT INTO academy_lesson3.table_persons (first_name, last_name, patronymic, birthday) VALUES
        ('Ivan','Ivanov','Ivanovich','1992-02-03'),
        ('Ivan','Petrov','Ivanovich','1995-02-03');

INSERT INTO academy_lesson3.table_faculties (name) VALUES
        ('Биологии'),
        ('Химии'),
        ('Математики'),
        ('Бухгалтерский');

-- заполнение телефонов будет производиться с учетом под запроса
--INSERT INTO academy_lesson3.table_phones (person_id, number) VALUES
--        (1,'+7 888 232323'),
--        (2,'8 800 200 2000');

-- запрос на добавление в базу данных по id возможно ошибиться с выбором числа, поэтому создается подзапрос
--INSERT INTO academy_lesson3.table_students (person_id, faculty_id, date_of_join) VALUES
--        (1, 1, '2022-10-3'),
--        (2, 3, '2022-10-4');

-- добавление в базу с учетом под запроса
INSERT INTO academy_lesson3.table_students(person_id, faculty_id, date_of_join)
VALUES (
        (SELECT id
         FROM academy_lesson3.table_persons
         WHERE first_name = 'Ivan'
           AND last_name = 'Ivanov'
           AND patronymic = 'Ivanovich'),
        (SELECT id
         FROM academy_lesson3.table_faculties
         WHERE name = 'Математики'),
        '2022-09-01'),
    ((SELECT id
         FROM academy_lesson3.table_persons
         WHERE first_name = 'Ivan'
           AND last_name = 'Petrov'
           AND patronymic = 'Ivanovich'),
        (SELECT id
         FROM academy_lesson3.table_faculties
         WHERE name = 'Биологии'),
        '2022-09-02');


INSERT INTO academy_lesson3.table_phones(number, person_id)
VALUES ('+7(999)999-99-99', (SELECT id
         FROM academy_lesson3.table_persons
         WHERE first_name = 'Ivan'
           AND last_name = 'Ivanov'
           AND patronymic = 'Ivanovich')),
       ('+7(222)222-22-22', (SELECT id
         FROM academy_lesson3.table_persons
         WHERE first_name = 'Ivan'
           AND last_name = 'Ivanov'
           AND patronymic = 'Ivanovich')),
       ('+7(333)333-33-33', (SELECT id
         FROM academy_lesson3.table_persons
         WHERE first_name = 'Ivan'
           AND last_name = 'Petrov'
           AND patronymic = 'Ivanovich'));

DELETE
FROM academy_lesson3.table_phones
WHERE id = 2;

-- если нам нужно посмотреть таблицу, настраиваемую с полями
SELECT academy_lesson3.table_persons.last_name,
       academy_lesson3.table_persons.first_name,
       academy_lesson3.table_persons.patronymic,
       academy_lesson3.table_faculties.name,
       academy_lesson3.table_students.date_of_join
FROM academy_lesson3.table_students, academy_lesson3.table_persons, academy_lesson3.table_faculties
WHERE academy_lesson3.table_students.person_id = academy_lesson3.table_persons.id
  AND academy_lesson3.table_students.faculty_id = academy_lesson3.table_faculties.id;


SELECT academy_lesson3.table_persons.last_name,
       academy_lesson3.table_persons.first_name,
       academy_lesson3.table_persons.patronymic,
       academy_lesson3.table_faculties.name,
       academy_lesson3.table_students.date_of_join
FROM academy_lesson3.table_students   -- таблица к которой будем присоединяться
    JOIN academy_lesson3.table_persons  -- кого будем присоединять
        ON academy_lesson3.table_students.person_id = academy_lesson3.table_persons.id   -- на основе какого правила присоединяем
    JOIN academy_lesson3.table_faculties
        ON academy_lesson3.table_students.faculty_id = academy_lesson3.table_faculties.id
WHERE academy_lesson3.table_persons.first_name = 'Ivan';

SELECT * FROM academy_lesson3.table_phones;

SELECT academy_lesson3.table_persons.last_name,
       academy_lesson3.table_persons.first_name,
       academy_lesson3.table_persons.patronymic,
       academy_lesson3.table_phones.number
FROM academy_lesson3.table_phones
RIGHT JOIN academy_lesson3.table_persons
    ON table_persons.id = table_phones.person_id
WHERE table_phones.number IS NULL;