--ДЗ.
-- Создать БД для хранения банковских счетов.
-- Предусмотреть возможности перевода денег между пользователями, пополнения и снятия.

-- тип аккаунта
CREATE TABLE public."Account Types" (
    id integer NOT NULL,
    description character(50)
);

-- аккаунт
CREATE TABLE public."Accounts" (
    id integer NOT NULL,
    customer_id integer,
    "openingDate" date,
    balance numeric,
    type_id integer
);

-- тип кредита
CREATE TABLE public."Loan Types" (
    id integer NOT NULL,
    description character(100) NOT NULL
);

-- кредит
CREATE TABLE public."Loan" (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    type_id integer NOT NULL,
    amount numeric NOT NULL
);

-- таблица клиентов
CREATE TABLE public."Customers" (
    id integer NOT NULL,
    login character(20) NOT NULL,      -- логин клиента
    "passHash" character(40) NOT NULL, -- пароль клиента
    name character(20) NOT NULL,       -- ФИО клиента
    phone character(20) NOT NULL,      -- телефон
    email character(50) NOT NULL,      -- почтовый адрес Email
    "registrationDate" date NOT NULL   -- дата регистрации клиента
);



CREATE TABLE public."Transaction type" (
    id integer NOT NULL,
    description character(50) NOT NULL
);


CREATE TABLE public."Transactions" (
    id integer NOT NULL,
    datetime timestamp without time zone NOT NULL,
    amount numeric NOT NULL,
    account_id integer NOT NULL,
    type_id integer NOT NULL
);

