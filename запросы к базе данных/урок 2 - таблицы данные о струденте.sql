CREATE SCHEMA IF NOT EXISTS academy;
CREATE TABLE academy.table_persons(
    id SERIAL NOT NULL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    patronymic TEXT,
    birthday DATE NOT NULL
);
INSERT INTO academy.table_persons (first_name, last_name, patronymic, birthday) VALUES
        ('Mikel','Efremov','Ivanovich','1984-12-3'),
        ('Ivan','Brinov','Alexeyevich','1964-2-19');

CREATE TABLE academy.table_phones(
    id SERIAL NOT NULL PRIMARY KEY,
    number TEXT NOT NULL,
    person_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES academy.table_persons(id)
);

INSERT INTO academy.table_phones (person_id, number) VALUES
        (1,'+7 888 232323'),
        (2,'8 800 200 2000');

CREATE TABLE academy.table_addresses(
    id SERIAL NOT NULL PRIMARY KEY,
    type_of_address TEXT NOT NULL,
    address TEXT NOT NULL,
    person_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES academy.table_persons(id)
);

CREATE TABLE academy.table_faculties(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);

INSERT INTO academy.table_faculties (name) VALUES
        ('Биологии'),
        ('Химии'),
        ('Математики'),
        ('Бухгалтерский');

CREATE TABLE academy.table_students(
    id SERIAL NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    faculty_id INTEGER NOT NULL,
    date_of_join DATE NOT NULL,
    FOREIGN KEY (person_id) REFERENCES academy.table_persons(id),
    FOREIGN KEY (faculty_id) REFERENCES academy.table_faculties(id)
);

INSERT INTO academy.table_students (person_id, faculty_id, date_of_join) VALUES
        (1, 1, '2022-10-3'),
        (2, 3, '2022-10-4');

CREATE TABLE academy.table_subjects(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);


CREATE TABLE academy.table_teachers(
    id SERIAL NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    faculty_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES academy.table_persons(id),
    FOREIGN KEY (faculty_id) REFERENCES academy.table_faculties(id)
);

CREATE TABLE academy.table_subjects_teachers(
    id SERIAL NOT NULL PRIMARY KEY,
    subject_id INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES academy.table_subjects(id),
    FOREIGN KEY (teacher_id) REFERENCES academy.table_teachers(id)
);



SELECT * FROM academy.table_students;
--DROP SCHEMA students CASCADE;