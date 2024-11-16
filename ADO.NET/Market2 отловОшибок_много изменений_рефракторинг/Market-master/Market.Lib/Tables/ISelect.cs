namespace Market.Lib.Tables;

public interface ISelect<out T>
{
    public IEnumerable<T>? GetAll();
    public T? GetById(int id);
}