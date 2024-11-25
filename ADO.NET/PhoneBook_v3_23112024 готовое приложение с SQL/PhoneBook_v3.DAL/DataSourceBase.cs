using Dapper;
using Npgsql;
using PhoneBook_v3.DAL.Tables;

namespace PhoneBook_v3.DAL;

public abstract class DataSourceBase
{
    private readonly NpgsqlConnection _db;

    protected DataSourceBase(string connectionString)
    {
        Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
        
        _db = new NpgsqlConnection(connectionString);
    }

    #region ICUD

    protected bool Execute(string sql)
    {
        _db.Open();
        var result = _db.Execute(sql);
        _db.Close();
        
        return result > 0;
    }

    #endregion

    #region IFind
    
    protected IEnumerable<T> FindByField<T>(string fieldName, string value)
    {
        _db.Open();
        var tableName = DbName.TableNames[typeof(T)];
        var sql = $"SELECT * FROM {tableName} WHERE {fieldName} = @value";
        var result = _db.Query<T>(sql, new { @value = value });
        _db.Close();
        
        return result;
    }
    
    protected T FindById<T>(int id)
    {
        _db.Open();
        var tableName = DbName.TableNames[typeof(T)];
        var sql = $"SELECT * FROM {tableName} WHERE id = @id";
        var result = _db.QuerySingle<T>(sql, new { @id = id });
        _db.Close();
        
        return result;
    }

    protected IEnumerable<T> GetAll<T>()
    {
        _db.Open();
        var tableName = DbName.TableNames[typeof(T)];
        var sql = $"SELECT * FROM {tableName}";
        var result = _db.Query<T>(sql);
        _db.Close();
        
        return result;
    }
    
    #endregion
}