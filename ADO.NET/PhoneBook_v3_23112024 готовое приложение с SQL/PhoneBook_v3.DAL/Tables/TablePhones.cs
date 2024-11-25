using PhoneBook_v3.DAL.Models;

namespace PhoneBook_v3.DAL.Tables;

public class TablePhones : DataSourceBase, ITable<Phone>
{
    public TablePhones(string connectionString) : base(connectionString)
    {
    }

    #region ICUD

    public bool Add(Phone obj)
    {
        var sql = $"""
                   INSERT INTO {DbName.TablePhones} (person_id, number, phone_type_id, comment)
                   VALUES({obj.PersonId}, '{obj.Number}', {obj.PhoneTypeId}, '{obj.Comment}');
                   """; //FIXME
        return base.Execute(sql);
    }

    public bool Update(Phone obj)
    {
        var sql = $"""
                   UPDATE {DbName.TablePhones} 
                   SET person_id = {obj.PersonId},
                       number = {obj.Number},
                       phone_type_id = {obj.PhoneTypeId},
                       comment = {obj.Comment}
                   WHERE id = {obj.Id};
                   """; //FIXME
        return base.Execute(sql);
    }

    public bool Delete(Phone obj)
    {
        var sql = $"DELETE FROM {DbName.TablePhones} WHERE id = {obj.Id};"; //FIXME
        return base.Execute(sql);
    }

    #endregion

    #region IFind

    public Phone FindById(int id)
    {
        return base.FindById<Phone>(id);
    }

    public IEnumerable<Phone> FindAllByField(string field, string value)
    {
        return base.FindByField<Phone>(field, value);
    }

    public IEnumerable<Phone> GetAll()
    {
        return base.GetAll<Phone>();
    }

    #endregion
}