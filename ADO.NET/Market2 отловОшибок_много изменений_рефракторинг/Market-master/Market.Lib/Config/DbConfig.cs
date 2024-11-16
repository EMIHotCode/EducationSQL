using System.Text.Json;
using System.Text.Json.Serialization;

namespace Market.Lib.Config;

public class DbConfig
{
    [JsonPropertyName("server")]
    public string Server { get; set; }
    
    [JsonPropertyName("port")]
    public int Port { get; set; }
    
    [JsonPropertyName("database")]
    public string Database { get; set; }
    
    [JsonPropertyName("user")]
    public string User { get; set; }
    
    [JsonPropertyName("password")]
    public string Password { get; set; }
    
    [JsonPropertyName("schema")]
    public string Schema { get; set; }

    public string ConnectionString => $"Server={Server};Port={Port};Database={Database};User Id={User};Password={Password};SearchPath={Schema};";

    public static DbConfig? Load(string configPath = "db_config.json")
    {
        string? json = null;
        try
        {
            json = File.ReadAllText(configPath);
        }
        catch (Exception e)
        {
            throw new FileConfigException(configPath, e);
        }
        
        try
        {
            return JsonSerializer.Deserialize<DbConfig>(json);
        }
        catch(Exception e)
        {
            throw new DbConfigException(e);
        }
    }
}