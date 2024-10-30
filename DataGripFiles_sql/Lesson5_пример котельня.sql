--Задание.
--Создать таблицу для хранения показателей котельной:
-- дата,
-- время,
-- температура на улице,
-- температура теплоносителя.

-- Написать запросы для получения данных:
-- - найти записи с наибольшим показателем температуры теплоносителя за какой-либо промежуток времени
-- - найти усреднённые показания температуры на улице и температуры теплоносителя разбитые по дням.
DROP TABLE boiler CASCADE;
CREATE TABLE  boiler (
    data DATE NOT NULL,
    time TIME NOT NULL,
    temperature_weather FLOAT,
    temperature_boiler FLOAT
);

INSERT INTO boiler (data, time, temperature_weather, temperature_boiler) VALUES
        ('2024-10-24','08:00:00',6,45),
        ('2024-10-24','10:00:00',7,44),
        ('2024-10-24','12:00:00',9,43),
        ('2024-10-24','14:00:00',9,43),
        ('2024-10-24','16:00:00',6,44),
        ('2024-10-24','18:00:00',5,45),
        ('2024-10-24','20:00:00',4,45),
        ('2024-10-24','22:00:00',3,46),

        ('2024-10-25','08:00:00',4,45),
        ('2024-10-25','10:00:00',5,44),
        ('2024-10-25','12:00:00',6,43),
        ('2024-10-25','14:00:00',7,43),
        ('2024-10-25','16:00:00',3,44),
        ('2024-10-25','18:00:00',3,45),
        ('2024-10-25','20:00:00',2,48),
        ('2024-10-25','22:00:00',2,45),

        ('2024-10-26','08:00:00',4,45),
        ('2024-10-26','10:00:00',3,46),
        ('2024-10-26','12:00:00',2,45),
        ('2024-10-26','14:00:00',1,43),
        ('2024-10-26','16:00:00',1,45),
        ('2024-10-26','18:00:00',1,45),
        ('2024-10-26','20:00:00',0,45),
        ('2024-10-26','22:00:00',0,45);

--день с максимальной температурой (выводит последнюю дату если несколько значений)
SELECT boiler.data,
       boiler.time,
       boiler.temperature_boiler
FROM boiler WHERE boiler.temperature_boiler = (SELECT MAX(temperature_boiler)
   FROM boiler);
--усреднённые показания температуры на улице и температуры теплоносителя разбитые по дням
SELECT data,
       AVG(temperature_weather) AS Средняя_температура_уличная,
       AVG(temperature_boiler) AS Средняя_температура_котельная
FROM boiler
GROUP BY data
ORDER BY data;
-- максимальные температуры по датам
SELECT boiler.data,
       boiler.time,
       boiler.temperature_boiler
FROM boiler WHERE boiler.temperature_boiler = (SELECT MAX(temperature_boiler)
   FROM boiler WHERE data BETWEEN '2024-10-24' AND '2024-10-26');


--Задание.
--Создать таблицы для фамилий, имён и отчеств.
--Создать представление для ФИО. Не забыть про ограничения для таблиц

DROP TABLE table_person CASCADE;
CREATE TABLE  first_name (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE  last_name (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE  patronymic (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
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
INSERT INTO last_name (name)   VALUES ('Иванов'), ('Петров'), ('Сидоров');
INSERT INTO patronymic (name)   VALUES ('Петрович'), ('Алексеевич'), ('Дмитриевич');

INSERT INTO table_person (name_id, surename_id, patronymic_id)
    VALUES (1,1,1),
           (2,2,2),
            (3,3,3);


CREATE VIEW view_person AS
    SELECT CONCAT(last_name, ' ', first_name, ' ', patronymic) AS full_name
    FROM table_person
        JOIN last_name ON last_name.id = table_person.name_id
        JOIN first_name ON first_name.id = table_person.surename_id
        JOIN patronymic ON patronymic.id = table_person.patronymic_id