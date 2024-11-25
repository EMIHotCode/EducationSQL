using PhoneBook_v3.DAL.Models;

namespace PhoneBook_v3.DAL.Tables;

public class TablePhoneTypes : DataSourceBase, ITable<PhoneType>
{
    public TablePhoneTypes(string connectionString) : base(connectionString)
    {
    }

    #region ICUD

    public bool Add(PhoneType obj)
    {
        var sql = $"INSERT INTO {DbName.TablePhoneTypes} (type) VALUES ('{obj.Type}');"; //FIXME
        return base.Execute(sql);
    }

    public bool Update(PhoneType obj)
    {
        var sql = $"UPDATE {DbName.TablePhoneTypes} SET type = '{obj.Type}' WHERE id = {obj.Id};"; //FIXME
        return base.Execute(sql);
    }

    public bool Delete(PhoneType obj)
    {
        var sql = $"DELETE FROM {DbName.TablePhoneTypes} WHERE id = {obj.Id};"; //FIXME
        return base.Execute(sql);
    }

    #endregion
    
    #region IFind

    public PhoneType FindById(int id)
    {
        return base.FindById<PhoneType>(id);
    }

    public IEnumerable<PhoneType> FindAllByField(string field, string value)
    {
        return base.FindByField<PhoneType>(field, value);
    }

    public IEnumerable<PhoneType> GetAll()
    {
        return base.GetAll<PhoneType>();
    }
    
    #endregion
}