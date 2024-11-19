-- один файл это одна база данных поэтому не создаем базу данных и схемы а сразу таблицы
-- sqlLite - база данных из одного файла заранее созданного желательно в корне проекта с расширением .db  .
-- Нет логина и пароля по умолчанию. Не надо запускать сервер и отключать его. 
-- файл  с  расширением .db нужно чтобы копировался туда где расположен .exe программы. Чтобы цепляться к БД из приложения 
-- нужно правой кнопкой мыши нажать и выбрать Properties \ Copy to output directory \ Copy if newer \ Ok

-- создаем только таблицы
CREATE TABLE table_users (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,  -- AUTOINCREMENT нужно писать для sqLite
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth TEXT NOT NULL   
);

CREATE TABLE table_phone_types (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL
);

CREATE TABLE table_phones (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    phone_type_id INTEGER NOT NULL,
    phone_number TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES table_users(id),
    FOREIGN KEY (phone_type_id) REFERENCES table_phone_types(id)   
);
--в новом файле .sql нет кнопки запуска запроса - она есть по нажатии правой кнопкой мыши - execute
-- добавление таблиц правой кнопкой мыши \ Execute \ для первой пустой таблици \ данные авотматически добавятся в базу с .exe файлом 

INSERT INTO table_users (first_name, last_name, date_of_birth) VALUES ('John', 'Doe', '1990-01-01'),
                                                                      ('Jane', 'Dallas', '1995-05-10');

INSERT INTO table_phone_types (type) VALUES ('Home'),
                                             ('Work');

INSERT INTO table_phones (user_id, phone_type_id, phone_number) VALUES (1,1,'123-345'),
                                                                       (1,2,'789-012'),
                                                                       (2,1,'333-444');

CREATE VIEW view_phones AS 
SELECT table_phones.id AS id,
       table_users.first_name ,  
       table_users.last_name AS last_name,  -- AS такие же как и в классе переменные для dapper на русском не прокатит
       table_users.date_of_birth AS date_of_birth,
       table_phone_types.type AS phone_type,
       table_phones.phone_number AS phone_number   
FROM table_phones
    JOIN table_users
        ON table_phones.user_id = table_users.id
    JOIN table_phone_types 
        ON table_phones.phone_type_id = table_phone_types.id;
