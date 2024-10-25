CREATE SCHEMA IF NOT EXISTS phones;

CREATE TABLE IF NOT EXISTS phones.table_manufacturers (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS phones.table_os (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS phones.table_phones (
    id SERIAL NOT NULL PRIMARY KEY,
    model TEXT NOT NULL,
    manufacturer_id INTEGER NOT NULL,
    os_id INTEGER NOT NULL,
    price REAL NOT NULL,
    FOREIGN KEY (manufacturer_id) REFERENCES phones.table_manufacturers(id),
    FOREIGN KEY (os_id) REFERENCES phones.table_os(id)
);