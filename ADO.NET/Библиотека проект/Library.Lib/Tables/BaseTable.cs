using Library.Lib.Config;
using Npgsql;

namespace Library.Lib.Tables;

public abstract class BaseTable
{
    protected readonly NpgsqlConnection Connection;

    protected BaseTable()
    {
        var config = DbConfig.Load();
        
        if (config is null) throw new DbConfigException();
        
        Connection = new NpgsqlConnection(config.ConnectionString);
        
        //Включение сопоставления имён с нижним подчёркиванием
        Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
    }
}