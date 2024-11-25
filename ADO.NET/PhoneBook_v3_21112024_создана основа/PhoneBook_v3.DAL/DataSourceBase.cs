namespace PhoneBook_v3.DAL;

public abstract class DataSourceBase : ICUD, IFind
{
    public bool Add()
    {
        throw new NotImplementedException();
    }

    public bool Update()
    {
        throw new NotImplementedException();
    }

    public bool Delete()
    {
        throw new NotImplementedException();
    }

    public void FindById(int id)
    {
        throw new NotImplementedException();
    }

    public void FindAllByField(string field, string value)
    {
        throw new NotImplementedException();
    }

    public void GetAll()
    {
        throw new NotImplementedException();
    }
}