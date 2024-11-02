--ДЗ.
-- Создать БД для хранения банковских счетов.
-- Предусмотреть возможности перевода денег между пользователями, пополнения и снятия.

-- тип аккаунта
-- CREATE TABLE public."Account Types" (
--     id integer NOT NULL,
--     description character(50)
-- );

CREATE SCHEMA IF NOT EXISTS bank_transactions;

--<TABLES>--

CREATE TABLE table_person(
    id SERIAL NOT NULL PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    surname TEXT NOT NULL
);

CREATE TABLE table_banks(
    id SERIAL NOT NULL PRIMARY KEY,
    bank_name TEXT NOT NULL UNIQUE
);

CREATE TABLE table_account_numbers(
    id SERIAL NOT NULL PRIMARY KEY,
    account_number TEXT NOT NULL UNIQUE CHECK ( length(account_number) = 18 )
);

CREATE TABLE table_bank_accounts(
    id SERIAL NOT NULL PRIMARY KEY,
    bank_id INTEGER NOT NULL,
    account_number_id INTEGER NOT NULL,
    person_id INTEGER,
    balance REAL NOT NULL CHECK ( balance >= 0 ),
    FOREIGN KEY (bank_id) REFERENCES table_banks(id),
    FOREIGN KEY (account_number_id) REFERENCES table_account_numbers(id),
    FOREIGN KEY (person_id) REFERENCES table_person(id)
);

CREATE TABLE table_transactions(
    id SERIAL NOT NULL PRIMARY KEY,
    sender_id INTEGER NOT NULL,
    recipient_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES table_bank_accounts(id),
    FOREIGN KEY (recipient_id) REFERENCES table_bank_accounts(id)
);

--</TABLES>--

--<VIEWS>--

CREATE VIEW view_transactions AS
    SELECT table_banks.bank_name,
           concat_ws('','*',substring(table_account_numbers.account_number, 15 , 4)) AS account_number,
           concat_ws(' ', table_person.first_name, table_person.surname,concat_ws('',substring(table_person.last_name, 1,1),'.')) AS sender,
           table_banks.bank_name,
           concat_ws('','*',substring(table_account_numbers.account_number, 15 , 4)) AS account_number,
           concat_ws(' ', table_person.first_name, table_person.surname,concat_ws('',substring(table_person.last_name, 1,1),'.')) AS recipient,
           table_transactions.amount
    FROM table_transactions
JOIN table_bank_accounts ON table_transactions.sender_id = table_bank_accounts.id
JOIN table_banks ON table_bank_accounts.bank_id = table_banks.id
JOIN table_person ON table_bank_accounts.person_id = table_person.id
JOIN table_account_numbers ON table_bank_accounts.account_number_id = table_account_numbers.id;

CREATE VIEW view_bank_accounts AS
    SELECT
        concat_ws(' ', table_person.first_name, table_person.surname,concat_ws('',substring(table_person.last_name, 1,1),'.')) AS owner,
        table_banks.bank_name,
        concat_ws('','*',substring(table_account_numbers.account_number, 15 , 4)) AS account_number,
        table_bank_accounts.balance
            FROM table_bank_accounts
        JOIN table_banks ON table_bank_accounts.bank_id = table_banks.id
        JOIN table_account_numbers ON table_bank_accounts.account_number_id = table_account_numbers.id
        JOIN table_person ON table_bank_accounts.person_id = table_person.id;

CREATE VIEW view_transactions AS
    SELECT
        concat_ws(' ', sender.first_name, sender.surname,concat_ws('',substring(sender.last_name, 1,1),'.')) AS sender,
        sender_bank.bank_name AS sender_bank_name,
        concat_ws('','*',substring(sender_account_number.account_number, 15 , 4)) AS sender_account_number,
        concat_ws(' ', recipient.first_name, recipient.surname,concat_ws('',substring(recipient.last_name, 1,1),'.')) AS recipient,
        recipient_bank.bank_name AS recipient_bank_name,
        concat_ws('','*',substring(recipient_account_number.account_number, 15 , 4)) AS recipient_account_number,
        amount
FROM table_transactions
JOIN table_bank_accounts ON table_transactions.sender_id = table_bank_accounts.id
JOIN table_person AS sender ON  table_transactions.sender_id = sender.id
JOIN table_person AS recipient ON table_transactions.recipient_id = recipient.id
JOIN table_banks ON table_bank_accounts.bank_id = table_banks.id
JOIN table_account_numbers AS sender_account_number ON table_transactions.sender_id = sender_account_number.id
JOIN table_account_numbers AS recipient_account_number ON table_transactions.recipient_id = recipient_account_number.id
JOIN table_banks AS sender_bank ON table_transactions.sender_id = sender_bank.id
JOIN table_banks AS recipient_bank ON table_transactions.recipient_id = recipient_bank.id;

--</VIEWS>--

--<PROCEDURES AND FUNCTIONS>--

CREATE OR REPLACE FUNCTION function_if_not_exist_account_number(
    IN _account_number TEXT)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    count INT;
BEGIN

    SELECT count(*)
    into count
    FROM table_account_numbers
    WHERE table_account_numbers.account_number = _account_number;

    IF (count = 0)
        THEN RETURN TRUE;
        ELSE RETURN FALSE;
        END IF;
END;
$$;

CREATE OR REPLACE FUNCTION function_if_not_enough_money(
    IN _account_number TEXT, _amount REAL)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    summ REAL;
BEGIN

SELECT balance
    into summ
    FROM table_bank_accounts
    JOIN table_account_numbers ON table_bank_accounts.account_number_id = table_account_numbers.id
    WHERE account_number = _account_number;

IF ((summ - _amount) < 0) THEN RETURN TRUE;
ELSE RETURN FALSE;
END IF;

END;
$$;

CREATE OR REPLACE PROCEDURE procedure_cash_in(
    IN _account_number TEXT, _amount REAL)
LANGUAGE plpgsql
AS $$
    DECLARE
        if_not_exist BOOLEAN;
        bank_account_id INTEGER;
    BEGIN

        if_not_exist := function_if_not_exist_account_number(_account_number);

        IF (if_not_exist = false) THEN
            SELECT table_bank_accounts.id
        INTO bank_account_id
                   FROM table_bank_accounts
                   JOIN table_account_numbers ON table_bank_accounts.account_number_id = table_account_numbers.id
                   WHERE account_number = _account_number;
            UPDATE table_bank_accounts
            SET balance = balance + _amount
            WHERE table_bank_accounts.id = bank_account_id;
        end if;

    END;
$$;

CREATE OR REPLACE PROCEDURE procedure_cash_out(
    IN _account_number TEXT, _amount REAL)
LANGUAGE plpgsql
AS $$
    DECLARE
        if_not_exist BOOLEAN;
        if_not_enough BOOLEAN;
        bank_account_id INTEGER;
    BEGIN

        if_not_exist := function_if_not_exist_account_number(_account_number);
        if_not_enough := function_if_not_enough_money(_account_number, _amount);

        IF (if_not_exist = false and if_not_enough = false) THEN

        SELECT table_bank_accounts.id
        INTO bank_account_id
                   FROM table_bank_accounts
                   JOIN table_account_numbers ON table_bank_accounts.account_number_id = table_account_numbers.id
                   WHERE account_number = _account_number;

            UPDATE table_bank_accounts
            SET balance = balance - _amount
            WHERE table_bank_accounts.id = bank_account_id;
        end if;

    END;
$$;

CREATE OR REPLACE PROCEDURE procedure_transaction_between_accounts(
    IN sender_account_number TEXT, recipient_account_number TEXT, amount REAL
)
LANGUAGE plpgsql
AS $$
DECLARE
    if_not_exist_sender_number BOOLEAN;
    if_not_exist_recipient_number BOOLEAN;
    if_not_enough BOOLEAN;
    sender_bank_account_id INTEGER;
    recipient_bank_account_id INTEGER;
    BEGIN

        if_not_exist_sender_number := function_if_not_exist_account_number(sender_account_number);
        if_not_exist_recipient_number := function_if_not_exist_account_number(recipient_account_number);
        if_not_enough := function_if_not_enough_money(sender_account_number, amount);

        IF (if_not_enough = FALSE AND
            if_not_exist_sender_number = FALSE AND
           if_not_exist_recipient_number = FALSE) THEN

            SELECT table_bank_accounts.id
            INTO sender_bank_account_id
                   FROM table_bank_accounts
                   JOIN table_account_numbers ON table_bank_accounts.account_number_id = table_account_numbers.id
                   WHERE account_number = sender_account_number;

            SELECT table_bank_accounts.id
            INTO recipient_bank_account_id
                   FROM table_bank_accounts
                   JOIN table_account_numbers ON table_bank_accounts.account_number_id = table_account_numbers.id
                   WHERE account_number = recipient_account_number;

            UPDATE table_bank_accounts
            SET balance = balance - amount
            WHERE table_bank_accounts.id = sender_bank_account_id;

            UPDATE table_bank_accounts
            SET balance = balance + amount
            WHERE table_bank_accounts.id = recipient_bank_account_id;

            INSERT INTO table_transactions (sender_id, recipient_id, amount) VALUES
                (sender_bank_account_id, recipient_bank_account_id, amount);
        end if;
    END;
$$;

--</PROCEDURES AND FUNCTIONS>--

--<TEST DATA>--

CALL procedure_cash_in('407018456456159789', 1500);
CALL procedure_cash_out('407018456456159789', 500);
CALL procedure_transaction_between_accounts('407018456456159789','407018456456151000', 500);

INSERT INTO table_person (last_name, first_name, surname) VALUES ('Иванов','Иван','Иванович');
INSERT INTO table_person (last_name, first_name, surname) VALUES ('Петров','Иван','Иванович');

INSERT INTO table_banks (bank_name) VALUES ('Сбербанк');
INSERT INTO table_banks (bank_name) VALUES ('ВТБ');

INSERT INTO table_account_numbers (account_number) VALUES ('407018456456159789');
INSERT INTO table_account_numbers (account_number) VALUES ('407018456456151000');

INSERT INTO table_bank_accounts (bank_id, account_number_id, person_id, balance) VALUES (1,1,1,1000);
INSERT INTO table_bank_accounts (bank_id, account_number_id, person_id, balance) VALUES (2,2,2,5000);

--</TEST DATA>--

