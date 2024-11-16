using System.Data;
using Market.Lib.Models;
using Npgsql;

namespace Market.Lib;

public class TablePersons
{
    private const string ConnectionString = "Server=127.0.0.1;Port=5432;Database=market_db;User Id=postgres;Password=1234;SearchPath=public;"; 
    //SearchPath - имя схемы подключения в существующей базе данных
    private readonly NpgsqlConnection _connection = new(ConnectionString);

    public IEnumerable<Person>? GetAllPersons()
    {
        var result = new List<Person>();
        _connection.Open();
        
        // запись через """ позволяет писать сырые многострочные запросы 
        const string sql = """    
                           SELECT id, 
                                  first_name, last_name, patronymic 
                           FROM table_persons
                           """;
        using var command = new NpgsqlCommand(sql, _connection);
        var reader = command.ExecuteReader();
        
        if (!reader.HasRows) return null;
        
        while (reader.Read())
        {
            result.Add(new Person()
            {
                Id = reader.GetInt32("id"),
                LastName = reader.GetString("last_name"),
                FirstName = reader.GetString("first_name"),
                Patronymic = reader.GetString("patronymic")
            });
        }
        
        _connection.Close();
        return result;
    }

    public Person? GetPersonById(int id)
    {
        _connection.Open();

        const string sql = """
                           SELECT id, 
                                  first_name, last_name, patronymic 
                           FROM table_persons
                           WHERE id = @id
                           """;
        using var command = new NpgsqlCommand(sql, _connection);
        command.Parameters.AddWithValue("@id", id);
        /*var parameter = new NpgsqlParameter("@id", id);
        command.Parameters.Add(parameter);*/
        
        var reader = command.ExecuteReader();
        
        if (!reader.HasRows) return null;
        
        reader.Read();
        
        var person = new Person()
        {
            Id = reader.GetInt32("id"),
            LastName = reader.GetString("last_name"),
            FirstName = reader.GetString("first_name"),
            Patronymic = reader.GetString("patronymic")
        };
        
        _connection.Close();
        return person;
    }
    
    /**/
      public int SetPerson(string firstName, string lastName, string patronymic)
      {
          _connection.Open();
          string sql = "INSERT INTO table_persons (first_name, last_name, patronymic) VALUES (@firstName, @lastName, @patronymic)";
          using var command = new NpgsqlCommand(sql, _connection);
          command.Parameters.AddWithValue("@firstName", firstName);
          command.Parameters.AddWithValue("@lastName", lastName);
          command.Parameters.AddWithValue("@patronymic", patronymic);

                  int result = command.ExecuteNonQuery();
                  Console.WriteLine($"Добавлено объектов: {result}");
                  return result;
      }

    
}