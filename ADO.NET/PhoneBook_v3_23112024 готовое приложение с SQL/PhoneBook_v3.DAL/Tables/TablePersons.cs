using PhoneBook_v3.DAL.Models;

namespace PhoneBook_v3.DAL.Tables;

public class TablePersons : DataSourceBase, ITable<Person>
{
    public TablePersons(string connectionString) : base(connectionString)
    { }

    #region ICUD

    public bool Add(Person obj)
    {
        var sql = $"""
                   INSERT INTO {DbName.TablePersons} (name, last_name, patronymic)
                   VALUES('{obj.Name}', '{obj.LastName}', '{obj.Patronymic}');
                   """; //FIXME
        return base.Execute(sql);
    }

    public bool Update(Person obj)
    {
        var sql = $"""
                   UPDATE {DbName.TablePersons} 
                   SET name = '{obj.Name}', 
                       last_name = '{obj.LastName}', 
                       patronymic = '{obj.Patronymic}'
                   WHERE id = {obj.Id};
                   """; //FIXME
        return base.Execute(sql);
    }

    public bool Delete(Person obj)
    {
        var sql = $"DELETE FROM {DbName.TablePersons} WHERE id = {obj.Id};"; //FIXME
        return base.Execute(sql);
    }

    #endregion

    #region IFind

    public Person FindById(int id)
    {
        return base.FindById<Person>(id);
    }

    public IEnumerable<Person> FindAllByField(string field, string value)
    {
        return base.FindByField<Person>(field, value);
    }

    public IEnumerable<Person> GetAll()
    {
        return base.GetAll<Person>();
    }
    
    #endregion
}