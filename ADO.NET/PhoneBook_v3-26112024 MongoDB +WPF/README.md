# Телефонная книга

## Задание

Создать графическое приложение для телефонной книги.
Данные хранятся в БД. Приложение на WPF.

Что умеет приложение:
- добавление контакта
- редактирование контакта
- удаление контакта
- поиск контактов по имени
- поиск контактов по телефону
- вывод всех контактов
- выгрузка контактов
- загрузка контактов

Что использует программа:
- PostgreSQL
- ADO.Net + Dapper
- WPF (MVVM)
- слоистая архитектура

Из чего состоит `контакт`:
- Фамилия, Имя, Отчество
- телефон: тип, номер
- комментарий

## БД

```mermaid
classDiagram
direction BT
class table_persons {
   text name
   text last_name
   text patronymic
   integer id
}
class table_phone_types {
   text type
   integer id
}
class table_phones {
   integer person_id
   text phone
   integer phone_type_id
   text comment
   integer id
}
class view_person_phones {
   integer id
   text name
   text last_name
   text patronymic
   text phone_type
   text phone_number
   text comment
}

table_phones  -->  table_persons
table_phones  -->  table_phone_types

```
