using PhoneBook_v3.DAL.Models;

namespace PhoneBook_v3.DAL;

public interface IContext
{
    public ITable<Person> TablePersons { get; }
    public ITable<PhoneType> TablePhoneTypes { get; }
    public ITable<Phone> TablePhones { get; }
}