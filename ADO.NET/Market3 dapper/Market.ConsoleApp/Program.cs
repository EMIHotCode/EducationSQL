using Market.Lib.Tables;

try
{
    var tableUsers = new TableUsers();

    var users = tableUsers.GetAll();
    foreach (var user in users)
    {
        Console.WriteLine(user);
    }
}
catch (Exception ex)
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.WriteLine(ex.Message);
    Console.ResetColor();
}

Console.ReadKey();