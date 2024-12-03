using Microsoft.EntityFrameworkCore;
using universitet_mikl.Models;

namespace universitet_mikl;

public class DataBaseContext : DbContext
{
    public DbSet<Faculty> Faculties { get; set; } // представляет набор сущностей, хранящихся в базе данных
    public DbSet<Subject> Subjects { get; set; }
    public DbSet<Teacher> Teachers { get; set; }

    public DataBaseContext()  // конструктор по умолчанию
    {
        Database.EnsureCreated();
    }
    
    //OnConfiguring это метод в Entity Framework Core, который позволяет настроить параметры подключения к базе данных
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        const string connectionString = "Host=localhost;Port=5432;Database=teachers_db;Username=postgres;Password=1234;";
        optionsBuilder.UseNpgsql(connectionString);
    }
    
}