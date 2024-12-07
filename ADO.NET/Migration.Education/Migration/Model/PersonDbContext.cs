using Microsoft.EntityFrameworkCore;

namespace Migration.Model;

public class PersonDbContext : DbContext
{
    private readonly string _connectionString;
    
    public DbSet<Person> Persons { get; set; }
    public DbSet<Address> Addresses { get; set; }
    public DbSet<Phone> Phones { get; set; }
    public DbSet<Email> Emails { get; set; }
    
    // создаем пустой конструктор 
    public PersonDbContext(string connectionString) : base()
    {
        _connectionString = connectionString;
    }
    // создать конфигурацию подключения с указанием строки подключения, но мы сделаем через конфигурацию json
    // для этого подключаем библиотеку Microsoft.Extensions.Configuration.Json
    // появляется новое поле для строки подключения  private readonly string _connectionString;
    // и она заносится в пустой конструктор. Далее создается метод OnConfiguring

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseNpgsql(_connectionString);
    }
}