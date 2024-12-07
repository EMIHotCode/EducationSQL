// автоматически подключилась EntityFrameworkCore.Design так как мы подключили  Microsoft.EntityFrameworkCore.Tools 

using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace Migration.Model;
// подключаем фабрику. Нужна для правильной работы с файлом конфигурации
public class PersonDbContextFactory : IDesignTimeDbContextFactory<PersonDbContext>
{
    public PersonDbContext CreateDbContext(string[] args)
    {
        var connectionString = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json")
            .Build()
            .GetConnectionString("DefaultConnection");

        return new PersonDbContext(connectionString);

    }
}