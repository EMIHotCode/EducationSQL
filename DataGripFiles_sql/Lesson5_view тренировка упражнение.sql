--Задание.
--Создать таблицы для фамилий, имён и отчеств.
--Создать представление для ФИО. Не забыть про ограничения для таблиц

DROP TABLE first_name, last_name, patronymic, table_person CASCADE;

CREATE TABLE  first_name (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL CHECK ( length(name) > 1 ) UNIQUE
);

CREATE TABLE  last_name (
    id SERIAL NOT NULL PRIMARY KEY,
    last_name TEXT NOT NULL UNIQUE
);

CREATE TABLE  patronymic (
    id SERIAL NOT NULL PRIMARY KEY,
    patronymic TEXT UNIQUE
);

CREATE TABLE  table_person (
    id SERIAL NOT NULL PRIMARY KEY,
    name_id INTEGER NOT NULL,
    surename_id INTEGER NOT NULL,
    patronymic_id INTEGER NOT NULL,
    FOREIGN KEY (name_id) REFERENCES first_name(id),
    FOREIGN KEY (surename_id) REFERENCES last_name(id),
    FOREIGN KEY (patronymic_id) REFERENCES patronymic(id)
);

INSERT INTO first_name (name)  VALUES ('Олег'), ('Артем'), ('Генадий');
INSERT INTO last_name (last_name)   VALUES ('Иванов'), ('Петров'), ('Сидоров');
INSERT INTO patronymic (patronymic)   VALUES ('Петрович'), ('Алексеевич'), ('');

INSERT INTO table_person (name_id, surename_id, patronymic_id)
    VALUES (1,1,1),
           (2,2,2),
            (3,3,3);

--представление для ФИО
DROP VIEW view_person;
CREATE VIEW view_person AS
    SELECT CONCAT(' ', last_name, name, patronymic) AS Полное_ФИО -- значения полей таблиц которые будем JOIN
    FROM table_person
        JOIN last_name ON last_name.id = table_person.surename_id
        JOIN first_name ON first_name.id = table_person.name_id
        JOIN patronymic ON patronymic.id = table_person.patronymic_id
