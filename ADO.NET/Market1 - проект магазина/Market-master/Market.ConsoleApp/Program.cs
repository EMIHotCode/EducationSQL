using Market.Lib;

// Market.Lib нужно подключить к Market.ConsoleApp правой кнопкой по Dependencies\Add Reference\ Add Market.Lib
// проверить Market.ConsoleApp.csproj появление строки  <ProjectReference Include="..\Market.Lib\Market.Lib.csproj" />

var tableUsers = new TableUsers();  
var tablePersons = new TablePersons();

tablePersons.SetPerson("Олег", "Зайцев", "Юрьевич");

/*
var users = tableUsers.GetAllUsers();
foreach (var user in users)
{
    Console.WriteLine($"{user.Id}: {user.UserName}");
}

var persons = tablePersons.GetAllPersons();
foreach (var person in persons)
{
    Console.WriteLine($"{person.Id}: {person.LastName} {person.FirstName} {person.Patronymic}");
}

var fullInfousers = from user in users
    join person in persons on user.Id equals person.Id
    select new
    {
        Id = user.Id,
        UserName = user.UserName,
        LastName = person.LastName,
        FirstName = person.FirstName,
        Patronymic = person.Patronymic
    };
foreach (var user in fullInfousers)
{
    Console.WriteLine($"{user.Id}: {user.UserName} - {user.LastName} {user.FirstName} {user.Patronymic}");
}
*/