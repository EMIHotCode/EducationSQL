using PhoneBook_v3.DAL;

namespace PhoneBook_v3.BL;

public partial class PhoneBook
{
    private readonly DataSourceBase _dataSource;

    public PhoneBook(DataSourceBase dataSource)
    {
        _dataSource = dataSource;
    }
    
    public bool AddContact(Contact contact)
    {
        _dataSource.Add();
        
        throw new NotImplementedException();
    }
    
    public bool UpdateContact(Contact contact)
    {
        _dataSource.Update();
        
        throw new NotImplementedException();
    }
    
    public bool DeleteContact(Contact contact)
    {
        _dataSource.Delete();
        
        throw new NotImplementedException();
    }
}