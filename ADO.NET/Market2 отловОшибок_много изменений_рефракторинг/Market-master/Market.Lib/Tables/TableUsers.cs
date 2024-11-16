using System.Data;
using Market.Lib.Models;
using Npgsql;

namespace Market.Lib.Tables;

public class TableUsers : BaseTable, ISelect<User>
{
    public IEnumerable<User>? GetAll()
    {
        try
        {
            var result = new List<User>();
            Connection.Open();

            const string sql = """
                               SELECT id, user_name,
                                      last_name, first_name, patronymic
                               FROM view_users
                               """;
            using var command = new NpgsqlCommand(sql, Connection);
            var reader = command.ExecuteReader();

            if (!reader.HasRows) return null;

            while (reader.Read())
            {
                result.Add(CreateUser(reader));
            }

            Connection.Close();
            return result;
        }
        catch (NpgsqlException e)
        {
            throw new GetDataFromTable(nameof(TableUsers), e);
        }
    }

    public User? GetById(int id)
    {
        Connection.Open();

        const string sql = """
                           SELECT id, user_name,
                                  last_name, first_name, patronymic
                           FROM view_users
                           WHERE id = @id
                           """;
        using var command = new NpgsqlCommand(sql, Connection);
        command.Parameters.AddWithValue("@id", id);
        
        var reader = command.ExecuteReader();
        
        if (!reader.HasRows) return null;
        
        reader.Read();

        var user = CreateUser(reader);
        
        Connection.Close();
        return user;
    }

    private User CreateUser(NpgsqlDataReader reader)
    {
        return new User
        {
            Id = reader.GetInt32("id"),
            UserName = reader.GetString("user_name"),
            LastName = reader.GetString("last_name"),
            FirstName = reader.GetString("first_name"),
            Patronymic = reader.GetString("patronymic")
        };
    }
}