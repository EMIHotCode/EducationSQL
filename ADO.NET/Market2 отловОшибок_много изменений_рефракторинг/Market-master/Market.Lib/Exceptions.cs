namespace Market.Lib;

public class FileConfigException : Exception
{
    public FileConfigException(string path) : base($"Файл конфигурации {path} не найден")
    { }

    public FileConfigException(string path, Exception innerException) : base($"Файл конфигурации {path} не найден", innerException)
    { }
}

public class DbConfigException : Exception
{
    private static readonly string message = "Ошибка конфигурации БД";

    public DbConfigException() : base(message)
    {
    }
    
    public DbConfigException(Exception innerException) : base(message, innerException)
    {}
}

public class GetDataFromTable : Exception
{
    public GetDataFromTable(string tableName) : base($"Ошибка получения данных из таблицы {tableName}")
    {
    }
    
    public GetDataFromTable(string tableName, Exception innerException) : base($"Ошибка получения данных из таблицы {tableName}", innerException)
    {}
}