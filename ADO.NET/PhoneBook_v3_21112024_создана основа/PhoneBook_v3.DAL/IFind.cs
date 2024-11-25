namespace PhoneBook_v3.DAL;

public interface IFind
{
    public void FindById(int id);
    public void FindAllByField(string field, string value);
    public void GetAll();
}