db.test_db.insertMany([{"name": "Bob", "age": 26, "languages": ["english", "french"]},
{"name": "Alice", "age": 31, "languages":["german", "english"]}]);

db.test_db.insertOne({"name": "Bob", "age": 28, friends: [{"name": "Tim"}, {"name": "Tom"}]})
db.test_db.insertOne({"name": "Tim", "age": 29, friends: [{"name": "Bob"}, {"name": "Tom"}]})
db.test_db.insertOne({"name": "Sam", "age": 31, friends: [{"name": "Tom"}]})
db.test_db.insertOne({"name": "Tom", "age": 32, friends: [{"name": "Bob"}, {"name": "Tim"}, {"name": "Sam"}]})

