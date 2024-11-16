using Market.Lib.Config;
using Npgsql;

namespace Market.Lib.Tables;

public abstract class BaseTable
{
    protected readonly NpgsqlConnection Connection;

    protected BaseTable()
    {
        var config = DbConfig.Load();
        
        if (config is null) throw new DbConfigException();
        
        Connection = new NpgsqlConnection(config.ConnectionString);
    }
}