// команды обучение взято с сайта metanit https://metanit.com/nosql/mongodb/2.3.php

show collections;

/*подключится к существующей базе данных или создаст новую с таким именем */
use test_db;
// показать все существующие базы
show dbs;
// показ всех коллекций в базе  - типо таблиц в  postgres
show collections;

// добавление данных
insertOne(): добавляет один документ
insertMany(): добавляет несколько документов

//"name" - ключ : "Bob" - значение
db.test_db.insertMany([{"name": "Bob", "age": 26, "languages": ["english", "french"]},
{"name": "Alice", "age": 31, "languages":["german", "english"]}]);

/*Фильтрация данных find() аналог SELECT SQL   */
db.test_db.find();
db.test_db.find({name: "Tom"});
db.test_db.find({name: "Tom", languages: null});
db.test_db.find({name: "Tom", age: 28});
db.test_db.find({name: "Tom", languages: "spanish"});
db.test_db.find({"languages.0": "english"}); /* всех у кого english стоит на первом месте в массиве */

load("D:/share/обучение программированию/SQL lessons/SQLrepository/MongoDB/my_mongoEducation/basa.js")  // загрузить документы из файла
db.test_db.insertOne({"name": "Bob", "age": 28, friends: [{"name": "Tim"}, {"name": "Tom"}]})
db.test_db.insertOne({"name": "Tim", "age": 29, friends: [{"name": "Bob"}, {"name": "Tom"}]})
db.test_db.insertOne({"name": "Sam", "age": 31, friends: [{"name": "Tom"}]})
db.test_db.insertOne({"name": "Tom", "age": 32, friends: [{"name": "Bob"}, {"name": "Tim"}, {"name": "Sam"}]})
//Выберем все документы, где в массиве friends свойство name первого элемента равно "Bob"
db.test_db.find({"friends.0.name": "Bob"});

db.test_db.find({name: "Tom"}, {age: 1}); // вывести только поле age у документов где name = Tom
db.test_db.find({name: "Tom"}, {age: 0}); // вывести все поля кроме age у документов где name = Tom
db.test_db.find({name: "Tom"}, {age: true, _id: false}) // убираем индефикатор из выборки
db.test_db.find({}, {age: 1, _id: 0}) // все записи без конкретизации имени

/*
Условные операторы
Условные операторы задают условие, которому должно соответствовать значение поля документа:
$eq (равно)
$ne (не равно)
$gt (больше чем)
$lt (меньше чем)
$gte (больше или равно)
$lte (меньше или равно)
$in определяет массив значений, одно из которых должно иметь поле документа
$nin определяет массив значений, которые не должно иметь поле документа
 */


