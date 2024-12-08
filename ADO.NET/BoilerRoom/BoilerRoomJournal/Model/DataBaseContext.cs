using Microsoft.EntityFrameworkCore;

namespace BoilerRoomJournal.Model;

public class DataBaseContext : DbContext
{
    public DbSet<employee> Employees { get; set; }
    public DbSet<JournalPage> JournalPages { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlite("Data Source=boilerRoom.db"); 
    }
}