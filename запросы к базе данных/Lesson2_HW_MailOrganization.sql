--ДЗ.
--Создать БД для хранения информации о почтовой корреспонденции организации. Нужно сохранять:
-- - кто отправитель
-- - дата отправления
-- - кому письмо
-- - содержимое письма
-- - тип письма (судебное, от человека, от организации и т.п.)
-- - статус (принято, в работе, отвечено, отложено и т.п.)
-- - кому назначено
-- - текст ответа

CREATE SCHEMA IF NOT EXISTS organizationMail;

CREATE TABLE organizationMail.table_status( -- статус
    id SERIAL NOT NULL PRIMARY KEY,
    status TEXT NOT NULL      -- статус
);

INSERT INTO organizationMail.table_status (status) VALUES
                                                      ('Принято'),
                                                      ('Принято');

CREATE TABLE organizationMail.table_sender( -- отправитель/получатель
    id SERIAL NOT NULL PRIMARY KEY,
    sender_type TEXT NOT NULL      -- связь с отправителем
);

CREATE TABLE organizationMail.table_sender_organization( -- организация отправитель/получатель
    id SERIAL NOT NULL PRIMARY KEY,
    organization_name TEXT NOT NULL      -- название организации
);

CREATE TABLE organizationMail.table_sender_person( -- отправитель
    id SERIAL NOT NULL PRIMARY KEY,
    person_id INTEGER NOT NULL,      -- связь с человеком
    FOREIGN KEY (person_id) REFERENCES organizationMail.table_person(id)
);

CREATE TABLE organizationMail.table_employee( -- работник
    id SERIAL NOT NULL PRIMARY KEY,
    position TEXT NOT NULL,     -- должность
    person_id INTEGER NOT NULL,      -- связь с человеком
    FOREIGN KEY (person_id) REFERENCES organizationMail.table_person(id)
);

CREATE TABLE organizationMail.table_person(  -- человек
    id SERIAL NOT NULL PRIMARY KEY,
    first_name TEXT NOT NULL,     -- имя
    last_name TEXT NOT NULL,      -- фамилия
    patronymic TEXT               -- отчество
);

CREATE TABLE organizationMail.table_text_mail(  -- текст ответа
    id SERIAL NOT NULL PRIMARY KEY,
    text TEXT     -- текст ответа
);
--DROP TABLE organizationMail.table_mail;
CREATE TABLE organizationMail.table_mail(  -- почта
    id SERIAL NOT NULL PRIMARY KEY,
    sender_id INTEGER NOT NULL,     -- отправитель
    date DATE NOT NULL,             -- дата отправления
    status_id INTEGER NOT NULL,     -- статус письма
    mail_text TEXT NOT NULL,        -- текст письма
    recipient_id INTEGER NOT NULL,  -- получатель письма
    txt_answer_id INTEGER NOT NULL,    -- текст ответа на письмо
    FOREIGN KEY (sender_id) REFERENCES organizationMail.table_sender_person(id),
    FOREIGN KEY (status_id) REFERENCES organizationMail.table_status(id),
    FOREIGN KEY (recipient_id) REFERENCES organizationMail.table_employee(id),
    FOREIGN KEY (txt_answer_id) REFERENCES organizationMail.table_text_mail(id)
);