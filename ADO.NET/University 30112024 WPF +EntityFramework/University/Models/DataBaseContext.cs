using Microsoft.EntityFrameworkCore;

namespace University.Models;

public class DataBaseContext : DbContext
{
    // папка Models работает с БД
    public DbSet<Faculty> Faculties { get; set; }
    public DbSet<Subject> Subjects { get; set; }
    public DbSet<Teacher> Teachers { get; set; }

    public DataBaseContext()
    {
        Database.EnsureCreated();
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        const string connectionString = "Host=localhost;Port=5432;Database=teachers_db;Username=postgres;Password=1234;"; //FIXME
        optionsBuilder.UseNpgsql(connectionString);
    }
}