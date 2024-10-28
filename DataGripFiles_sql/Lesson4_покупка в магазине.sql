DROP TABLE table_products;

CREATE TABLE table_products(   -- таблица продуктов
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    amount INTEGER NOT NULL
);

CREATE TABLE table_users(     -- таблица пользователей
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE table_baskets(   -- таблица корзина заказов
    id BIGSERIAL NOT NULL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES table_users(id)
);

CREATE TABLE table_basket_products(
    id SERIAL NOT NULL PRIMARY KEY,
    basket_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    FOREIGN KEY (basket_id) REFERENCES table_baskets(id),
    FOREIGN KEY (product_id) REFERENCES table_products(id)
);

CREATE TABLE table_order_status(     -- таблица статуса заказа
    id SERIAL NOT NULL PRIMARY KEY,
    status TEXT NOT NULL
);

CREATE TABLE table_orders(    -- таблица заказов
    id BIGSERIAL NOT NULL PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL,
    status_id INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES table_baskets(id),
    FOREIGN KEY (status_id) REFERENCES table_order_status(id)
);
