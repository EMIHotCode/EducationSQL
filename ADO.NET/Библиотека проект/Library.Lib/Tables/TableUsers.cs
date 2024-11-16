using System.Data;
using Dapper;
using Library.Lib.Models;
using Npgsql;

namespace Library.Lib.Tables;

public class TableUsers : BaseTable, ISelect<User>
{
    public IEnumerable<User>? GetAll()
    {
        try
        {
            Connection.Open();

            const string sql = """
                               SELECT person_id, phone,
                                      email, count_books_take, is_active_user
                               FROM table_users
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
                           SELECT person_id, phone,
                           email, count_books_take, is_active_user
                           FROM table_users
                           WHERE person_id = @id
                           """;
        var user = Connection.QuerySingleOrDefault<User>(sql, new { id });// dapper
        
        Connection.Close();
        return user;
    }
}