namespace PhoneBook_v3.BL;

public partial class PhoneBook
{
    public IEnumerable<Contact>? FindAllByName(string name)
    {
        _dataSource.FindAllByField("name", name);
        
        return null;
    }
    
    public IEnumerable<Contact>? FindAllByPhone(string number)
    {
        _dataSource.FindAllByField("phone", number);
        
        return null;
    }
    
    public IEnumerable<Contact>? FindAllByComment(string comment)
    {
        _dataSource.FindAllByField("comment", comment);
        
        return null;
    }

    public IEnumerable<Contact>? GetAll()
    {
        _dataSource.GetAll();
        
        return null;
    }
}