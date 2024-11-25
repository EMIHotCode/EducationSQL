using PhoneBook_v3.DAL;
using DAL_Models = PhoneBook_v3.DAL.Models;

namespace PhoneBook_v3.BL;

public partial class PhoneBook
{
    private readonly IContext _dataSource;

    public PhoneBook(IContext context)
    {
        _dataSource = context;
    }
    
    public bool AddContact(Contact contact)
    {
        var person = new DAL_Models.Person()
        {
            Name = contact.Name,
            LastName = contact.LastName,
            Patronymic = contact.Patronymic
        };
        _dataSource.TablePersons.Add(person);

        var personId = 0; //FIXME

        foreach (var contactPhone in contact.Phones)
        {
            var phoneType = new DAL_Models.PhoneType()
            {
                Type = contactPhone.Type
            };
            _dataSource.TablePhoneTypes.Add(phoneType);

            var phone = 0; //FIXME
        }
        
        throw new NotImplementedException();
    }
    
    public bool UpdateContact(Contact contact)
    {
        throw new NotImplementedException();
    }
    
    public bool DeleteContact(Contact contact)
    {
        throw new NotImplementedException();
    }
}