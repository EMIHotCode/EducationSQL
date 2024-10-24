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
    FOREIGN KEY (student_id) REFERENCES pass_card.table_student(id)
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
       )
