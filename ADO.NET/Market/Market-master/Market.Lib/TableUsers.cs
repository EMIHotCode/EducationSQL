using System.Data;
using Market.Lib.Models;
using Npgsql;

namespace Market.Lib;

public class TableUsers
{
    private const string ConnectionString = "Server=127.0.0.1;Port=5432;Database=market_db;User Id=postgres;Password=1234;SearchPath=public;";
/*
    private readonly NpgsqlConnection _connection; - от этой записи с конструктором отказываемся хотя она более правильная, чтобы все записать в одну строку см. ниже
    public TableUsers()
    {
        _connection = new NpgsqlConnection(ConnectionString);
    }
*/  
    private readonly NpgsqlConnection _connection = new(ConnectionString); // readonly - будет создана только один раз. НЕ НАДО писать пустой конструктор public TableUsers() с такой записью

    public IEnumerable<User>? GetAllUsers()  // получение всех пользователей
    {
        var result = new List<User>();  // будет наполняться данными 
        _connection.Open();

        const string sql = "SELECT id, user_name FROM table_users"; // можно SELECT * -  но лучше перечислить поля даже если их много
        using var command = new NpgsqlCommand(sql, _connection);
        var reader = command.ExecuteReader();  
        
        if (!reader.HasRows) return null;  // проверка если reader не может вернуть ниодну запись, т.е. получили данные или нет
        
        while (reader.Read())   // построчно добавляем пользователей в список
        {
            result.Add(new User
            {
                Id = reader.GetInt32("id"),
                UserName = reader.GetString("user_name")
            });
        }
        
        _connection.Close();
        return result;
    }

    public User? GetUserById(int id)
    {
        _connection.Open();  // открыли подключение к базе данных 

        const string sql = "SELECT id, user_name FROM table_users WHERE id = @id";  // @id - параметр чтобы исключить sql иньекции
        using var command = new NpgsqlCommand(sql, _connection);
        command.Parameters.AddWithValue("@id", id); // создаем для комманды параметры. Поле "@id" будет равно id
        /*var parameter = new NpgsqlParameter("@id", id);
        command.Parameters.Add(parameter);*/
        
        var reader = command.ExecuteReader();
        
        if (!reader.HasRows) return null;
        
        reader.Read();
        
        var user = new User
        {
            Id = reader.GetInt32("id"),
            UserName = reader.GetString("user_name")
        };
        
        _connection.Close();
        return user;
    }
}