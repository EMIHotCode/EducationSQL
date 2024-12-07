using System.IO;
using System.Windows;
using Microsoft.Extensions.Configuration;

namespace University;

public partial class App : Application
{
    public App()
    {
        Startup += (_, _) =>
        {
            LoadConfig();
        };
    }

    private void LoadConfig()
    {
        var config = new ConfigurationBuilder()  // создается некий строитель 
            .SetBasePath(Directory.GetCurrentDirectory())       //базовый путь где искать конфигурационный файл -- текущая директория где мы запущены
            .AddJsonFile("appsettings.json")                    // добавляем json файл
            .Build();                                               // 
        
        #if DEBUG
        var connectionString = config.GetConnectionString("DefaultConnection");//FIXME DefaultConnection -> TestConnection выбираем какую строку из файла подключить
        #elif RELEASE
        var connectionString = config.GetConnectionString("ProdConnection");
        #endif
        
        this.Resources["ConnectionString"] = connectionString;
    }
}