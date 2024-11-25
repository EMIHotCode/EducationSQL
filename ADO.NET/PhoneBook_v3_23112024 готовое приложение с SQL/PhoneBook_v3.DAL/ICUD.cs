namespace PhoneBook_v3.DAL;

public interface ICUD<in T>
{
    public bool Add(T obj);
    public bool Update(T obj);
    public bool Delete(T obj);
}