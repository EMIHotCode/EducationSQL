using System.Data;
using Dapper;
using Market.Lib.Models;
using Npgsql;

namespace Market.Lib.Tables;

public class TableUsers : BaseTable, ISelect<User>
{
    public IEnumerable<User>? GetAll()
    {
        try
        {
            Connection.Open();

            const string sql = """
                               SELECT id, user_name,
                                      last_name, first_name, patronymic
                               FROM view_users
                               """;
            /*using var command = new NpgsqlCommand(sql, Connection);
            var reader = command.ExecuteReader();

            if (!reader.HasRows) return null;

            while (reader.Read())
            {
                result.Add(CreateUser(reader));
            }*/

            var result = Connection.Query<User>(sql);
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
        var user = Connection.QuerySingleOrDefault<User>(sql, new { id });
        
        Connection.Close();
        return user;
    }
}