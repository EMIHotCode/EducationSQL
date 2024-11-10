CREATE SCHEMA library;

-- <TABLES>
CREATE TABLE library.table_persons (  -- таблица_людей
    id SERIAL NOT NULL PRIMARY KEY ,
    first_name TEXT NOT NULL ,
    last_name TEXT NOT NULL ,
    patronymic TEXT
);
CREATE TABLE library.table_authors(
    author_id INTEGER NOT NULL primary key ,
    FOREIGN KEY (author_id) REFERENCES library.table_persons(id)
);
CREATE TABLE library.table_users(
   user_id INTEGER NOT NULL  PRIMARY KEY ,
   user_name TEXT NOT NULL UNIQUE ,
   FOREIGN KEY (user_id) REFERENCES library.table_persons(id)
);
CREATE TABLE library.table_book_condition (
    id SERIAL NOT NULL  PRIMARY KEY ,
    condition TEXT NOT NULL
);

CREATE TABLE library.table_books (
    id SERIAL NOT NULL PRIMARY KEY ,
    book_name TEXT NOT NULL ,
    author_id INTEGER NOT NULL ,
    year INTEGER CHECK ( year>=0 ),
    condition_id INTEGER NOT NULL ,
    number INTEGER NOT NULL CHECK ( number>=0 ),
    FOREIGN KEY (author_id) REFERENCES library.table_authors(author_id),
    FOREIGN KEY (condition_id) REFERENCES library.table_book_condition(id)
);
CREATE TABLE library.table_card (
    id SERIAL NOT NULL PRIMARY KEY ,
    user_id INTEGER NOT NULL ,
    date_take DATE ,
    date_return DATE,
    book_id INTEGER NOT NULL ,
    FOREIGN KEY (user_id) REFERENCES library.table_users(user_id) ,
    FOREIGN KEY (book_id) REFERENCES library.table_books(id)
);

CREATE TABLE library.table_count_taken_books (
    id SERIAL NOT NULL PRIMARY KEY ,
    user_id INTEGER NOT NULL ,
    number_all INTEGER CHECK ( number_all>=0 ),
    number_returned INTEGER CHECK ( number_returned>=0 ),
    number_on_hand INTEGER CHECK ( number_on_hand>=0 )
);
-- </TABLES>
-- <TEST DATA>
INSERT INTO library.table_persons(first_name, last_name, patronymic)
VALUES ('Кривошта','Татьяна','Юрьевна'),
       ('Ефремов','Михаил','Иванович'),
       ('Курманаев','Сергей','Петрович'),
       ('Колодин','Иван','Александрович'),
       ('Царевская','Элина','Роальдовна'),

       ('Ремарк','Эрих Мария',''),
       ('Моэм','Сомерсет',''),
       ('Чехов','Антон','Павлович'),
       ('Лесков','Николай','Семенович'),
       ('Шекспир','Уильям',''),
       ('Гюго','Виктор',''),
       ('По','Эдгар Алан',''),
       ('Твен','Марк',''),
       ('Пушкин','Александр','Сергеевич'),
       ('Бунин','Иван','Алексеевич');

INSERT INTO library.table_users(user_id, user_name)
VALUES ((SELECT id FROM library.table_persons
                   WHERE first_name='Кривошта'
                   AND last_name='Татьяна'
                   AND patronymic='Юрьевна'),'krivodhta@tatyana'),
    (2,'efremov@mixail'),
    (3,'kurmanaev@sergey'),
    (4,'kolodin@ivan'),
    (5,'tsarevskaya@elina');

INSERT INTO library.table_authors(author_id)
VALUES (6),(7),(8),(9),(10),
       (11),(12),(13),(14),(15);

INSERT INTO library.table_book_condition (condition)
VALUES ('новая'), ('хорошее состояние'),
       ('плохое состояние'),('ветхая');

INSERT INTO library.table_books(book_name, author_id, year, condition_id, number)
VALUES ('Приют грез',6,2023,2,8),
       ('Грамматика любви',15,2001,2,130),
       ('Дама с собачкой',8,1998,2,180);

INSERT INTO library.table_books(book_name, author_id, year, condition_id, number)
VALUES ('Грабеж',9,2002,3,280);

INSERT INTO library.table_books(book_name, author_id, year, condition_id, number) VALUES
       ('Система доктора Смоля и профессора Перро', 12, 2015,2,10),
       ('Ромео и Джульетта',10,2020,3,108),
       ('На западном фронте без перемен', 6,2024,1,8);

INSERT INTO library.table_books(book_name, author_id, year, condition_id, number) VALUES
       ('Время жить и время умирать',6,2023,2,18),
       ('Узорный покров',7,1998,4,285),
       ('Тогда и теперь',7,1998,2,100),
       ('Король Лир',10,2000,2,85),
       ('Приключения Гекельберри Финна',13,1980,3,220),
       ('Солнечный удар',15,2010,2,10),
       ('Собор Парижской Богоматери',11,2005,2,65),
       ('Отверженные',6,1985,4,217),
       ('Колодец и маятник',12,1999,3,130),
       ('Медный всадник',14,2024,1,3),
       ('Пиковая дама',14,2014,2,86);

INSERT INTO library.table_books(book_name, author_id, year, condition_id, number)
VALUES ('Приют грез',6,1995,2,250);

INSERT INTO library.table_card ( user_id, date_take, date_return, book_id)
VALUES (1,'01.09.2024','10.09.2024',52),
(1,'01.09.2024',NULL,51);
INSERT INTO library.table_card ( user_id, date_take, date_return, book_id)
VALUES (2,'05.09.2024',NULL,61),
       (2,'05.09.2024',NULL,55),
       (3,'05.09.2024','15.09.2024',6),
       (3,'05.09.2024','15.09.2024',7),
       (3,'05.09.2024','15.09.2024',56),
       (5,'05.09.2024','20.09.2024',60),
       (5,'05.09.2024',NULL,53);
-- </TEST DATA>

-- <VIEWS>
CREATE VIEW library.view_author  AS
     SELECT library.table_authors.author_id,
         CONCAT_WS(' ', first_name, last_name,patronymic) AS автор
 FROM library.table_authors
 JOIN library.table_persons
     ON table_authors.author_id = table_persons.id;

CREATE VIEW library.view_users AS
SELECT library.table_users.user_id,
      CONCAT_WS(' ',first_name,last_name,patronymic) as пользователи_библиотеки,
      library.table_users.user_name
FROM library.table_users
JOIN library.table_persons
ON library.table_users.user_id=library.table_persons.id;


CREATE VIEW library.view_books AS
SELECT library.table_books.id,
       library.table_books.book_name AS название_книги,
       CONCAT_WS(' ',first_name,last_name, patronymic) AS автор,
       library.table_books.year AS год_издания,
       library.table_book_condition.condition AS состояние,
       library.table_books.number AS брали_раз
FROM library.table_books
JOIN library.table_persons
        ON library.table_books.author_id=library.table_persons.id
JOIN library.table_book_condition
ON library.table_books.condition_id=library.table_book_condition.id
ORDER BY table_books.book_name;

SELECT library.table_authors.author_id,
       library.table_persons.first_name,
       library.table_persons.last_name,
       library.table_persons.patronymic
FROM library.table_authors
JOIN library.table_persons
    ON library.table_authors.author_id=library.table_persons.id;

CREATE VIEW library.view_cards AS
SELECT library.table_card.id,
       CONCAT_WS(' ', first_name,last_name, patronymic) AS reader,
       library.table_card.date_take,
       library.table_card.date_return,
       library.table_books.book_name,
       (
           SELECT  CONCAT_WS(' ',first_name,last_name, patronymic) AS автор
           FROM library.table_books
           JOIN library.table_persons
           ON library.table_books.author_id=library.table_persons.id
           where library.table_card.book_id=library.table_books.id
           )
FROM library.table_card
JOIN library.table_persons
ON library.table_card.user_id=library.table_persons.id
JOIN library.table_books
ON library.table_card.book_id=library.table_books.id;
-- </VIEWS>




SELECT library.table_card.id,
       CONCAT_WS(' ', first_name,last_name, patronymic) AS reader,
       library.table_card.date_take,
       library.table_card.date_return,
       library.table_books.book_name,
       library.table_books.author_id
FROM library.table_card
JOIN library.table_persons
ON library.table_card.user_id=library.table_persons.id
JOIN library.table_books
ON library.table_card.book_id=library.table_books.id;

-- <SELECTS>
/*второй возможный вариант view_card*/
 SELECT library.table_card.id,
       CONCAT_WS(' ', users.first_name,users.last_name, users.patronymic) AS reader,
       library.table_card.date_take,
       library.table_card.date_return,
       library.table_books.book_name,
       CONCAT_WS(' ',author.first_name,author.last_name, author.patronymic) AS автор

FROM library.table_card
JOIN library.table_persons as users ON library.table_card.user_id=users.id
JOIN library.table_books ON library.table_card.book_id=library.table_books.id
JOIN library.table_persons as author ON library.table_books.author_id = author.id;
/**/

SELECT MAX(number)
FROM library.table_books;

/*книга, которую чаще всего брали*/
 SELECT library.table_books.book_name as название_книги,
        (
             SELECT  CONCAT_WS(' ',first_name,last_name, patronymic) AS автор
           FROM library.table_books
           JOIN library.table_persons
           ON library.table_books.author_id=library.table_persons.id
           where number=(SELECT MAX(number)
               FROM library.table_books)
        ),
        library.table_books.number as число_раз
 FROM library.table_books
 WHERE number=(SELECT MAX(number)
               FROM library.table_books);

/*взято книг*/
SELECT COUNT(library.table_card.date_take)
FROM library.table_card
WHERE user_id=1;
/*возвращено книг*/
SELECT COUNT(library.table_card.date_return)
FROM library.table_card
WHERE user_id=1;
/*не сдано книг*/
select count(case
                  when  library.table_card.date_return IS null then  1
             end) as не_сдано
from library.table_card
WHERE user_id=1;

/*кто не сдал книги  */
SELECT DISTINCT library.table_card.user_id,
      CONCAT_WS(' ',first_name,last_name, patronymic)
FROM library.table_card
JOIN  library.table_persons
ON library.table_card.user_id=library.table_persons.id
WHERE date_return ISNULL;

/*кто не сдал без повторов, но только с использованием уникальных имен*/
SELECT library.table_users.user_name
FROM library.table_users
JOIN  library.table_card
ON library.table_users.user_id=library.table_card.user_id
WHERE library.table_card.date_return ISNULL
GROUP BY library.table_users.user_name;

/*связка уникального имени и полного имени*/
SELECT library.table_users.user_name,
       CONCAT_WS(' ',first_name,last_name, patronymic)
FROM library.table_users
join  library.table_card
ON library.table_users.user_id=library.table_card.user_id
join library.table_persons
ON library.table_users.user_id=library.table_persons.id
WHERE library.table_card.date_return ISNULL;

/*ни разу не брал книгу */
SELECT  CONCAT_WS(' ',first_name,last_name, patronymic)
    FROM library.table_users
    JOIN library.table_persons
    ON library.table_users.user_id=library.table_persons.id
EXCEPT
SELECT  CONCAT_WS(' ',first_name,last_name, patronymic)
    FROM library.table_card
JOIN library.table_persons
ON library.table_card.user_id=library.table_persons.id;

/*перечень книг, которые не сданы*/
SELECT library.table_card.id,
       library.table_books.book_name,
       (
           SELECT  CONCAT_WS(' ',first_name,last_name, patronymic) AS автор
           FROM library.table_books
           JOIN library.table_persons
           ON library.table_books.author_id=library.table_persons.id
           where library.table_card.book_id=library.table_books.id
           ),
       CONCAT_WS(' ', first_name,last_name, patronymic) AS reader,
       library.table_card.date_take
FROM library.table_card
JOIN library.table_persons
ON library.table_card.user_id=library.table_persons.id
JOIN library.table_books
ON library.table_card.book_id=library.table_books.id
WHERE library.table_card.date_return ISNULL ;

-- </SELECTS>

--<LOG>
CREATE SCHEMA log;
CREATE TYPE  dml_type AS ENUM ('INSERT', 'UPDATE', 'DELETE');
CREATE TABLE log.table_dml_logs (
    id BIGSERIAL NOT NULL PRIMARY KEY ,
    schema_name TEXT NOT NULL,
    table_name TEXT NOT NULL,
    old_row_data jsonb,
    new_row_data jsonb,
    dml_type dml_type NOT NULL,
    dml_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dml_user_name TEXT NOT NULL DEFAULT CURRENT_USER
);

CREATE OR REPLACE PROCEDURE log.procedure_insert_log(
    IN _schema_name TEXT,
    IN _table_name TEXT,
    IN _old_row_data jsonb,
    IN _new_row_data jsonb,
    IN _dml_type dml_type
    )
LANGUAGE SQL
BEGIN ATOMIC
    INSERT INTO log.table_dml_logs (schema_name, table_name, old_row_data, new_row_data, dml_type)
    VALUES (_schema_name, _table_name, _old_row_data,
            _new_row_data, _dml_type);
END;

/*функция инкремента в таблице books сколько  раз была выдана книга */
CREATE OR REPLACE FUNCTION library.inkrement_number()
RETURNS TRIGGER
LANGUAGE plpgsql AS
    $$
    BEGIN
            UPDATE library.table_books
            SET  number=number+1
            WHERE id=NEW.book_id;
            RETURN NEW;
    END ;
    $$;

/*функция изменения в таблице выданных и возвращенных книг*/
CREATE OR REPLACE FUNCTION library.changes_in_numbers()
RETURNS TRIGGER
LANGUAGE plpgsql AS
    $$
    BEGIN
         IF (tg_op='INSERT') THEN
             UPDATE library.table_count_taken_books
             SET number_on_hand=number_on_hand+1,
                 number_all=number_all+1



             FROM library.table_card
             WHERE library.table_card.user_id=library.table_count_taken_books.user_id;
             RETURN NEW;
         end IF;
    END;
    $$;
/*функция добавления пользователя при его создании в таблицу учета взятых книг - table_count_taken_books*/
CREATE OR REPLACE FUNCTION library.changes_count_taken_books_add_user()
RETURNS TRIGGER
LANGUAGE plpgsql AS
    $$
    BEGIN
        INSERT INTO library.table_count_taken_books( user_id, number_all, number_returned, number_on_hand)
        VALUES (NEW.user_id,0,0,0);
    RETURN NEW;
    END;
    $$;
/**/
CREATE OR REPLACE FUNCTION library.change_data_return_book()
RETURNS TRIGGER
LANGUAGE plpgsql AS
    $$
    BEGIN
        IF EXISTS(SELECT 1
                  FROM library.table_card
                  WHERE user_id=NEW.user_id
                  AND book_id=NEW.book_id)
            THEN
            UPDATE library.table_card
            SET date_return=NEW.date_return
             WHERE user_id=NEW.user_id
             AND book_id=NEW.book_id;

            UPDATE library.table_count_taken_books
            SET number_on_hand=number_on_hand-1
            WHERE user_id=NEW.user_id;
        end if;
        RETURN NULL; /*только обновляет*/
   END;
   $$;


--<TRIGGERS>
CREATE TRIGGER  trigger_dml_log_for_return_book
    BEFORE INSERT
    ON library.table_card
    FOR EACH ROW
    WHEN (New.date_return is not null and new.date_take is null)
    EXECUTE FUNCTION library.change_data_return_book();

CREATE TRIGGER  trigger_dml_log_for_table_books
    AFTER INSERT
    ON library.table_card
    FOR EACH ROW
    EXECUTE FUNCTION library.inkrement_number();

CREATE TRIGGER  trigger_dml_log_table_numbers
    AFTER INSERT
    ON library.table_card
    FOR EACH ROW
    WHEN ( NEW.date_take IS NOT NULL )
    EXECUTE FUNCTION library.changes_in_numbers();

CREATE TRIGGER trigger_dml_log_for_table_count_taken_books
    AFTER INSERT
    ON library.table_users
    FOR EACH ROW
    EXECUTE FUNCTION library.changes_count_taken_books_add_user();

--</TRIGGERS>
INSERT INTO library.table_card ( user_id, date_take, date_return, book_id)
VALUES (1,'05.09.2024',NULL,7);
INSERT INTO library.table_card ( user_id, date_take, date_return, book_id)
VALUES (1,'05.09.2024','10.09.2024',62);

INSERT INTO library.table_persons(first_name, last_name, patronymic)
VALUES ('Иванов','Иван','Иванович' );

INSERT INTO library.table_users(user_id, user_name)
VALUES (16,'ii@iii');

INSERT INTO library.table_card ( user_id, date_take, date_return, book_id)
VALUES (17,'05.09.2024','25.09.2024',50);


INSERT INTO library.table_persons(first_name, last_name, patronymic)
VALUES ('Федоров','Иван','Алексеевич' );
INSERT INTO library.table_users(user_id, user_name)
VALUES (17,'ff@fff');

INSERT INTO library.table_persons(first_name, last_name, patronymic)
VALUES ('Сосновский','Сергей','Алексеевич' );
INSERT INTO library.table_users(user_id, user_name)
VALUES (18,'sss@sos');
INSERT INTO library.table_card ( user_id, date_take, date_return, book_id)
VALUES (18,'05.09.2024',NULL,63);

INSERT INTO library.table_card(user_id,date_return,book_id)
VALUES (18,'30.10.2024',63);

INSERT INTO library.table_persons(first_name, last_name, patronymic)
VALUES ('Пупкин','Сергей','Алексеевич' );
INSERT INTO library.table_users(user_id, user_name)
VALUES (19,'ppp@pp');
INSERT INTO library.table_card ( user_id, date_take, date_return, book_id)
VALUES (19,'05.09.2024',NULL,4);
INSERT INTO library.table_card ( user_id, date_return, book_id)
VALUES (19,'15.09.2024',4);
