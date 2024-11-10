--ДЗ.
--Создать БД для библиотеки.

--Что нужно хранить?
-- - информацию о книге
-- - информацию о состоянии книги
-- - информацию о пользователях библиотеки
-- - информацию о контактах пользователей
-- - информацию о выдаче книг

--Что нужно показывать?
-- - самая часто выдаваемая книга
-- - сколько книг на руках у пользователя
-- - список пользователей кто ни разу не брал книги
-- - список пользователей кто не сдал книги

-- самая часто выдаваемая книга - пройти по всем записям и посчитать по каждой книге количество выдачей. сделать группировку Groupby потом выбрать Select max
-- частота выдачи книг сделать через view а потом искать  самая часто выдав Сделать через view группировку по книге id следуий столбец сколько выдачей


-- сколько книг на руках у пользователя select count обращаемся к таблице ползователей и какие книги у него на руках where id пользователя и id которого ищете

-- автора завести отдельную таблицу а в publicher ссылаться на него его псевдоним год издания
CREATE  SCHEMA IF NOT EXISTS library;

-- принципы соединения select veiew триггеры использование транзакций

--Таблица персон
CREATE TABLE IF NOT EXISTS table_persons(
    id SERIAL NOT NULL PRIMARY KEY,
    surname TEXT NOT NULL,   -- фамилия
    name TEXT NOT NULL,      -- имя
    patronymic TEXT          -- отчество
);

-- Таблица авторов отсутствует, привязка к table_persons
-- CREATE TABLE table_authors(
--    author_id INTEGER NOT NULL primary key ,
--    FOREIGN KEY (author_id) REFERENCES table_persons(id)
-- );

-- Таблица пользователей библиотеки
CREATE TABLE IF NOT EXISTS table_users(
    person_id INTEGER NOT NULL PRIMARY KEY ,
    phone TEXT NOT NULL,                                 -- телефон
    email TEXT NOT NULL,                                 -- email
    count_books_take INTEGER NOT NULL DEFAULT 0,         -- кол-во книг на руках у пользователя
    is_active_user BOOLEAN NOT NULL DEFAULT FALSE,       -- активен ли пользователь
    check ( count_books_take >= 0 ),                 -- проверка кол-ва книг на руках
    FOREIGN KEY (person_id) REFERENCES table_persons(id)
);

-- Таблица издательств
CREATE TABLE IF NOT EXISTS table_publishers(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE     -- название издательства
);

-- Таблица состояний книг
CREATE TABLE IF NOT EXISTS table_conditions(
    id SERIAL NOT NULL PRIMARY KEY,   -- уникальный идентификатор
    name TEXT NOT NULL UNIQUE         -- название состояния книги
);

-- Таблица книг
CREATE TABLE IF NOT EXISTS table_books(
    id SERIAL NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,                                        -- название книги
    author_id INT NOT NULL,                                     -- автор
    year INTEGER NOT NULL CHECK (year > 0),                     -- год издания
    publisher_id INTEGER NOT NULL,                              -- идентификатор издательства
    condition_id INTEGER NOT NULL,                              -- идентификатор состояния книги
    FOREIGN KEY(condition_id) REFERENCES table_conditions(id),
    FOREIGN KEY (publisher_id) REFERENCES table_publishers(id),
    FOREIGN KEY (author_id) REFERENCES table_persons(id)
);


-- Таблица наличия и количества всех книг в библиотеке - картотека
CREATE TABLE IF NOT EXISTS table_library_books(
    book_id INTEGER NOT NULL PRIMARY KEY,           -- идентификатор книги
    quantity INTEGER NOT NULL ,                     -- кол-во экземпляров книги в библиотеке
    count_activity INTEGER NOT NULL DEFAULT 0,      -- кол-во книг на руках
    count_book_take INTEGER NOT NULL DEFAULT 0,     -- общее кол-во раз сколько книгу брали пользователи
    check ( count_activity >= 0 ),                  -- проверка кол-ва книг на руках
    check ( count_book_take >= 0 ),                 -- проверка кол-ва книг на руках
    check ( quantity >= 0 ),                        -- проверка кол-ва книг в библиотеке
    FOREIGN KEY (book_id) REFERENCES table_books(id) -- идентификатор книги
);

--Таблица выдачи и приема книг
CREATE TABLE IF NOT EXISTS table_take_return_books(
    id SERIAL NOT NULL PRIMARY KEY,          -- уникальный идентификатор
    users_id  INTEGER NOT NULL,              -- идентификатор пользователя
    book_id INTEGER NOT NULL,                -- идентификатор книги
    date_take DATE,                          -- дата выдачи книги
    date_return DATE,                        -- дата возврата книги
    CHECK ( DATE(date_take) <= DATE(date_return) ),
    CHECK ( date_take IS NOT NULL OR date_return IS NOT NULL),
    FOREIGN KEY (users_id) REFERENCES table_users(person_id),
    FOREIGN KEY (book_id) REFERENCES table_books(id)
);

-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;



INSERT INTO table_persons(surname, name, patronymic)
VALUES ('Алексеев','Сергей','Александрович'),
       ('Зюзин','Владимир','Анатольевич'),
       ('Зайцев','Сергей','Юрьевич'),
       ('Ваганов','Николай','Александрович'),
       ('Малов','Андрей','Анатольевич'),

       ('Лукьяненко','Сергей',''),  --6
       ('Чехов','Антон','Павлович'),
       ('Лесков','Николай','Семенович'),
       ('По','Эдгар Алан',''),
       ('Пушкин','Александр','Сергеевич'),
       ('Бунин','Иван','Алексеевич');

INSERT INTO table_users(person_id, phone, email, count_books_take, is_active_user)
VALUES ((SELECT id FROM table_persons
                   WHERE surname='Алексеев'
                   AND name='Сергей'
                   AND patronymic='Александрович'),'222-22-22','alex_alex@yand', 1, true),
    (2,'333-34-34', 'testmail@mail',0, false),
    (3, '444-54-54', 'testmail2@sergey', 3,true),
    (4,'123-123-23','test3@vagan',2, true),
    (5,'777-54-56', 'testmail5@malov', 0,false);

INSERT INTO table_publishers(name)
VALUES ('Дрофа'),
       ('Литрес'),
       ('Эксмо'),
       ('Лабиринт'),
       ('Просвещение');

INSERT INTO table_conditions(name)
VALUES ('новая'),
       ('хорошее состояние'),
       ('плохое состояние'),
       ('ветхая');

INSERT INTO table_books(title, author_id, year, publisher_id, condition_id)
VALUES ('Трикс',
        (SELECT id FROM table_persons
                   WHERE surname='Лукьяненко'
                   AND name='Сергей'),1998,2,2),
    ('Золотой жук', 9,1843,4,3),
    ('Евгений онегин', 10,1823,5,4),
    ('Рыцари сорока островов', 6,2001,1,1),
    ('Вишневый сад', 7,1903,3,4),
    ('Левша', 8,1881,4,1),
    ('Темные аллеи', 11,1891,2,2);

INSERT INTO table_library_books(book_id, quantity, count_activity, count_book_take)
VALUES (1, 5, 2, 125),
       (2, 2, 1, 35),
       (3, 3, 0, 47),
       (4, 4, 1, 25),
       (5, 1, 0, 110),
       (6, 2, 1, 77),
       (7, 6, 1, 67);

INSERT INTO table_take_return_books(users_id, book_id, date_take, date_return)
VALUES (1, 1, '05.09.2024',NULL),
       (3, 1, '05.09.2024','25.09.2024'),
       (3, 4, '07.09.2024','22.09.2024'),
       (3, 6, '05.09.2024','05.09.2024'),
       (4, 2, '15.09.2024','18.09.2024'),
       (4, 7, '17.09.2024',NULL);


-- <SELECT>

/*ни разу не брал книгу */
SELECT  CONCAT_WS(' ',surname, name, patronymic)
    FROM table_users
    JOIN table_persons
    ON table_users.person_id=table_persons.id
EXCEPT
SELECT  CONCAT_WS(' ',surname,name, patronymic)
    FROM table_take_return_books
JOIN table_persons
ON table_take_return_books.book_id=table_persons.id;

-- </SELECT>



-- <LOG>
CREATE SCHEMA log; -- создаем схему

CREATE TYPE dml_type AS ENUM ('INSERT', 'UPDATE', 'DELETE');
CREATE TABLE log.table_dml_logs (  -- создаем таблицу
    id BIGSERIAL NOT NULL PRIMARY KEY,
    schema_name TEXT NOT NULL,          -- имя схемы (т.е. в какой схеме происходили записи тестовая или боевая)
    table_name TEXT NOT NULL,        -- таблица в которой мы производим действия
    old_row_data jsonb,              -- старые данные которые будут храниться
    new_row_data jsonb,              -- какие новые данные
    dml_type dml_type NOT NULL,      -- тип события из ENUM который будет происходить
    dml_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- когда произошло событие
    dml_user_name TEXT NOT NULL DEFAULT CURRENT_USER      --  кем было сделано имя юзера который произвел действие (изменения в таблице)
);
CREATE OR REPLACE PROCEDURE log.procedure_insert_log( -- это хранимая процедура, которая поможет записывать в таблицу table_dml_logs действия
    IN _schema_name TEXT,  -- входящие данные имя схемы
    IN _table_name TEXT,   -- входящие данные имя таблицы
    IN _old_row_data jsonb, -- входящие данные старые данные
    IN _new_row_data jsonb, -- входящие данные новые данные
    IN _dml_type dml_type)  -- входящие данные dml тип
LANGUAGE SQL  -- на каком языке будем писать запрос
BEGIN ATOMIC
    INSERT INTO log.table_dml_logs (schema_name, table_name, old_row_data, new_row_data, dml_type)
    VALUES (_schema_name, _table_name, _old_row_data, _new_row_data, _dml_type);
END;

-- BEGIN ATOMIC   END;
-- AS $$          $$; альтернатива

CREATE OR REPLACE FUNCTION log.function_dml_log()
    RETURNS trigger  -- функция возвращает триггер
LANGUAGE plpgsql AS
$$
BEGIN
    IF (tg_op = 'INSERT') THEN  -- tg_op зарезервированная переменная, в ней храниться тип операции, которая вызвала триггер
        -- CALL вызываем функцию
        CALL log.procedure_insert_log(tg_table_schema, tg_table_name, NULL, to_jsonb(NEW), 'INSERT');  --jsonb бинарный вид
        RETURN NEW;  -- чтобы вернула триггер
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

-- <TRIGGERS> - это недофункция которые срабатывают при определенных событиях и вызывают какую то функцию
-- триггер пишется для каждой таблицы свой
CREATE TRIGGER trigger_dml_log_for_table_products --trigger_dml_log комманды манипуляции dml для логирования  для таблицы for_table_products
AFTER INSERT OR UPDATE OR DELETE
    ON table_products
    FOR EACH ROW -- для каждой строчки будет срабатывать триггер
EXECUTE FUNCTION log.function_dml_log();  -- что мы будем выполнять

CREATE TRIGGER trigger_dml_log_for_table_baskets
AFTER INSERT OR UPDATE OR DELETE
    ON table_baskets
    FOR EACH ROW
EXECUTE FUNCTION log.function_dml_log();

-- </TRIGGERS



-- Функция для инкремента кол-ва книг на руках у пользователя
CREATE OR REPLACE FUNCTION increment_count_books_activity()
RETURNS TRIGGER AS $$
BEGIN
    -- если date_issuance не равно null, то обновляем кол-во книг на руках у пользователя
    IF NEW.date_issuance IS NOT NULL THEN

    -- Обновляем количество книг на руках у пользователя в таблице table_users_library
    UPDATE library.table_users_library
    SET count_books_activity = count_books_activity + 1
    WHERE user_id = NEW.users_library_id;

     -- Обновляем count_activity в таблице table_library_books
    UPDATE library.table_library_books
    SET count_activity = count_activity + 1
    WHERE book_id = NEW.book_id;

    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Функция для обновления таблиц после возврата книги
CREATE OR REPLACE FUNCTION library.handle_book_return()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем, что дата возврата не равна NULL
    IF NEW.date_return IS NOT NULL THEN
        -- Проверка, что книга принадлежит пользователю и была выдана
        IF EXISTS (
            SELECT 1
            FROM library.table_issuance_return_books
            WHERE users_library_id = NEW.users_library_id
              AND book_id = NEW.book_id
              AND date_issuance IS NOT NULL
        ) THEN
            -- Обновляем date_return в таблице table_issuance_return_books
            UPDATE library.table_issuance_return_books
            SET date_return = NEW.date_return
            WHERE users_library_id = NEW.users_library_id
              AND book_id = NEW.book_id;

            -- Обновляем количество книг на руках у пользователя
            UPDATE library.table_users_library
            SET count_books_activity = count_books_activity - 1
            WHERE user_id = NEW.users_library_id;

            -- Обновляем count_activity и quantity в таблице table_library_books
            UPDATE library.table_library_books
            SET count_activity = count_activity - 1,
                balance_book = balance_book + 1
            WHERE book_id = NEW.book_id;
        ELSE
            RAISE EXCEPTION 'Пользователь не может вернуть книгу, так как она не была выдана ему.';
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


--Функция для изменения статуса пользователя на активный
CREATE OR REPLACE FUNCTION library.change_active_user()
RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.date_issuance IS NOT NULL THEN
        UPDATE library.table_users_library
        SET is_active_user = TRUE
         WHERE user_id = NEW.users_library_id AND is_active_user = FALSE;
        END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Функция для декремента кол-ва книг в библиотеке после взятия книги пользователем
CREATE OR REPLACE FUNCTION library.decrement_count_books_library()
RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.book_id IS NOT NULL THEN
            UPDATE library.table_library_books
            SET balance_book = balance_book - 1
            WHERE book_id = NEW.book_id;
        END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Функция для инкремента общего кол-во раз сколько книгу брали пользователи
CREATE OR REPLACE FUNCTION library.increment_count_book_issuance()
RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.book_id IS NOT NULL THEN
            UPDATE library.table_library_books
            SET count_book_issuance = count_book_issuance + 1
            WHERE book_id = NEW.book_id;
       END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Функция создания первичной таблицы для книги в table_library_books
CREATE OR REPLACE FUNCTION library.create_table_library_books()
RETURNS TRIGGER AS $$
     DECLARE
        balance INTEGER;
    BEGIN
        -- Получаем количество книг из таблицы table_books
        SELECT quantity INTO balance
        FROM library.table_books
        WHERE id = NEW.id;

        INSERT INTO library.table_library_books
        (book_id, balance_book, count_book_issuance, count_activity)
        VALUES (NEW.id, balance, 0, 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Функция создания первичной таблицы для пользователей в table_users_library
CREATE OR REPLACE FUNCTION library.create_table_users_library()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO library.table_users_library
        (user_id)
        VALUES (NEW.person_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Триггер, который срабатывает после добавления нового пользователя
CREATE TRIGGER trigger_add_table_users_library
    AFTER INSERT ON library.table_users
    FOR EACH ROW
    EXECUTE FUNCTION library.create_table_users_library();

--Триггер, который срабатывает после добавления новой книги
CREATE TRIGGER trigger_add_table_library_books
AFTER INSERT ON library.table_books
FOR EACH ROW
EXECUTE FUNCTION library.create_table_library_books();

--Триггер для инкремента кол-ва книг на руках у пользователя
CREATE TRIGGER trigger_increment_count_books_activity
    AFTER INSERT ON library.table_issuance_return_books
    FOR EACH ROW
    WHEN ( NEW.date_issuance IS NOT NULL)
    EXECUTE FUNCTION library.increment_count_books_activity();

--Триггер для обновления таблиц при возврате книги пользователем
CREATE TRIGGER trigger_handle_book_return
    BEFORE INSERT ON library.table_issuance_return_books
    FOR EACH ROW
    WHEN ( NEW.date_return IS NOT NULL)
    EXECUTE FUNCTION library.handle_book_return();

--Триггер для изменения статуса пользователя на активный
CREATE TRIGGER trigger_change_active_user
    AFTER INSERT ON library.table_issuance_return_books
    FOR EACH ROW
    WHEN ( NEW.date_issuance IS NOT NULL)
    EXECUTE FUNCTION library.change_active_user();

--Триггер для декремента кол-ва книг в библиотеке после взятия книги пользователем
CREATE TRIGGER trigger_decrement_count_books_library
    AFTER INSERT ON library.table_issuance_return_books
    FOR EACH ROW
    WHEN ( NEW.book_id IS NOT NULL AND NEW.date_issuance IS NOT NULL)
    EXECUTE FUNCTION library.decrement_count_books_library();

--Триггер для инкремента общего кол-во раз сколько книгу брали пользователи
CREATE TRIGGER trigger_increment_count_book_issuance
    AFTER INSERT ON library.table_issuance_return_books
    FOR EACH ROW
    WHEN ( NEW.book_id IS NOT NULL AND NEW.date_issuance IS NOT NULL)
    EXECUTE FUNCTION library.increment_count_book_issuance();





