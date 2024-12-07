using Microsoft.EntityFrameworkCore;

namespace University.Models;

public class DataBaseContext : DbContext
{
    private readonly string _connectionString; // создаем поле для хранения строки подключения для работы с appsettings.json файлом 
    
    public DbSet<Faculty> Faculties { get; set; }
    public DbSet<Subject> Subjects { get; set; }
    public DbSet<Teacher> Teachers { get; set; }

    public DataBaseContext(string connectionString)
    {
        _connectionString = connectionString; // инициализация строки подключения 
        
        Database.EnsureCreated();
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseNpgsql(_connectionString); // передадим приватную переменную строки подключения которую проинициализировали
    }
}