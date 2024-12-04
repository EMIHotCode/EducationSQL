using Microsoft.EntityFrameworkCore;
using universitet_mikl;
using universitet_mikl.Models;

var db = new DataBaseContext();


 //Ввод данных в базу делается один раз и больше не используется 
// должна быть заранее заведена база данных с таким иметем и включен сервер postgres
 /*
var faculty1 = new Faculty()
{
   Id = Guid.NewGuid(),
   FacultyName = "Faculty1"
};
var faculty2 = new Faculty()
{
   Id = Guid.NewGuid(),
   FacultyName = "Faculty2"
};
db.Faculties.AddRange(faculty1, faculty2);

var subject1 = new Subject()
{
   Id = Guid.NewGuid(),
   SubjectName = "Subject1"
};
var subject2 = new Subject() { Id = Guid.NewGuid(), SubjectName = "Subject2" };
db.Subjects.AddRange(subject1, subject2);

var teacher1 = new Teacher()
{
   Id = Guid.NewGuid(),
   FirstName = "John",
   LastName = "Doe",
   Faculty = faculty1,
   Subjects = [subject1]
};
var teacher2 = new Teacher()
{
   Id = Guid.NewGuid(),
   FirstName = "Jane",
   LastName = "Delay",
   Faculty = faculty2,
   Subjects = [subject1, subject2]
};
db.Teachers.AddRange(teacher1, teacher2);
db.SaveChanges();
// таблица SubjectTeacher создается автоматически. Отношение многие(Subject) ко многим(Teacher) генерирует отдельную таблицу
*/


// Вывод данных из базы
// Жадная загрузка использует Include явно указывает что вы хотите загрузить.
// В отличии от ленивой  https://metanit.com/sharp/efcore/3.3.php
   var teachersDb = db.Teachers
        .Include(t=>t.Faculty)
        .Include(t=>t.Subjects)
        .ToList();
    foreach (var teacher in teachersDb)
    {
        Console.WriteLine($"{teacher.Id}: {teacher.LastName} {teacher.FirstName} ({teacher.Faculty.FacultyName})");
        foreach (var subject in teacher.Subjects)
        {
            Console.WriteLine($"\t{subject.SubjectName}");
        }
    }

Console.WriteLine("\n\n");

    foreach (var faculty in db.Faculties)
    {
        Console.WriteLine(faculty.FacultyName);
        foreach (var teacher in faculty.Teachers)
        {
            Console.WriteLine($"\t{teacher.LastName} {teacher.FirstName}");
        }
    }
    
    Console.WriteLine("\n\n");

    foreach (var subject in db.Subjects)
    {
        Console.WriteLine(subject.SubjectName);
        foreach (var teacher in subject.Teachers)
        {
            Console.WriteLine($"\t{teacher.LastName} {teacher.FirstName} ({teacher.Faculty.FacultyName})");
        }
    }