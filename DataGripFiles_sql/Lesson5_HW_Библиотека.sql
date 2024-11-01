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

--Таблица персон
CREATE TABLE IF NOT EXISTS library.table_persons(
    id SERIAL NOT NULL PRIMARY KEY,  -- уникальный идентификатор
    surname VARCHAR(255) NOT NULL,   -- фамилия
    name VARCHAR(255) NOT NULL,      -- имя
    patronymic VARCHAR(255)          -- отчество
);

-- Таблица пользователей
CREATE TABLE IF NOT EXISTS library.table_users(
    person_id INTEGER NOT NULL PRIMARY KEY ,      -- id персоны
    login VARCHAR(255) NOT NULL UNIQUE,             -- логин
    phone VARCHAR(255) NOT NULL,                    -- телефон
    email VARCHAR(255) NOT NULL,                    -- email
    FOREIGN KEY (person_id) REFERENCES library.table_persons(id)
);

--Таблица издательств
CREATE TABLE IF NOT EXISTS library.table_publishers(
    id SERIAL NOT NULL PRIMARY KEY,       -- уникальный идентификатор
    name VARCHAR(255) NOT NULL UNIQUE     -- название издательства
);

-- Таблица состояний книг
CREATE TABLE IF NOT EXISTS library.table_conditions(
    id SERIAL NOT NULL PRIMARY KEY,   -- уникальный идентификатор
    name VARCHAR(255) NOT NULL UNIQUE -- название состояния книги
);

-- Таблица книг
CREATE TABLE IF NOT EXISTS library.table_books(
    id SERIAL NOT NULL PRIMARY KEY, -- уникальный идентификатор
    title VARCHAR(255) NOT NULL,    -- название книги
    author VARCHAR(255) NOT NULL,   -- автор
    year INTEGER NOT NULL,          -- год издания
    publisher_id INTEGER NOT NULL,  -- идентификатор издательства
    condition_id INTEGER NOT NULL,  -- идентификатор состояния книги
    quantity INTEGER NOT NULL DEFAULT 1, -- кол-во экземпляров книги
    CHECK (year > 0),
    CHECK ( quantity > 0 ),
    FOREIGN KEY(condition_id) REFERENCES library.table_conditions(id),
    FOREIGN KEY (publisher_id) REFERENCES library.table_publishers(id)
);

--Общая таблица всех пользователей библиотеки                -- убрать таблицу она не нужна без нее расширение
CREATE TABLE IF NOT EXISTS library.table_users_library(
    user_id INTEGER NOT NULL PRIMARY KEY,              -- id пользователя
    count_books_activity INTEGER NOT NULL DEFAULT 0,     -- кол-во книг на руках у пользователя
    is_active_user BOOLEAN NOT NULL DEFAULT FALSE,       -- активен ли пользователь
    check ( count_books_activity >= 0 ),                 -- проверка кол-ва книг на руках
    FOREIGN KEY (user_id) REFERENCES library.table_users(person_id)
);

-- Общая таблица всех книг в библиотеке
CREATE TABLE IF NOT EXISTS library.table_library_books(
    book_id INTEGER NOT NULL PRIMARY KEY,           -- идентификатор книги
    balance_book INTEGER NOT NULL ,                 -- кол-во книг в библиотеке
    count_activity INTEGER NOT NULL DEFAULT 0,      -- кол-во книг на руках
    count_book_issuance INTEGER NOT NULL DEFAULT 0, -- общее кол-во раз сколько книгу брали пользователи
    check ( count_activity >= 0 ),                  -- проверка кол-ва книг на руках
    check ( count_book_issuance >= 0 ),             -- проверка кол-ва книг на руках
    check ( balance_book >= 0 ),                        -- проверка кол-ва книг в библиотеке
    FOREIGN KEY (book_id) REFERENCES library.table_books(id) -- идентификатор книги
);

--Таблица выдачи книг и приема книг
CREATE TABLE IF NOT EXISTS library.table_issuance_return_books(
    id SERIAL NOT NULL PRIMARY KEY,          -- уникальный идентификатор
    users_library_id  INTEGER NOT NULL,      -- идентификатор пользователя
    book_id INTEGER NOT NULL,                -- идентификатор книги
    date_issuance DATE,                      -- дата выдачи книги
    date_return DATE,                        -- дата возврата книги
    CHECK ( DATE(date_issuance) <= DATE(date_return) ),
    CHECK ( date_issuance IS NOT NULL OR date_return IS NOT NULL),
    FOREIGN KEY (users_library_id) REFERENCES library.table_users_library(user_id),
    FOREIGN KEY (book_id) REFERENCES library.table_books(id)
);

-- Функция для инкремента кол-ва книг на руках у пользователя
CREATE OR REPLACE FUNCTION library.increment_count_books_activity()
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





