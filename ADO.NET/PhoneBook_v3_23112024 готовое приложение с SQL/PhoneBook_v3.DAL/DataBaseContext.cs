using PhoneBook_v3.DAL.Models;
using PhoneBook_v3.DAL.Tables;

namespace PhoneBook_v3.DAL;

public class DataBaseContext : IContext
{
    public ITable<Person> TablePersons { get; }
    public ITable<PhoneType> TablePhoneTypes { get; }
    public ITable<Phone> TablePhones { get; }

    public DataBaseContext(string connectionString)
    {
        TablePersons = new TablePersons(connectionString);
        TablePhoneTypes = new TablePhoneTypes(connectionString);
        TablePhones = new TablePhones(connectionString);
    }
}