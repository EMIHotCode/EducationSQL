using MongoDB.Bson;
using MongoDB.Driver;
using PhoneBook_v3.BL.Models;

namespace PhoneBook_v3.BL;

public partial class PhoneBook
{
    public IEnumerable<Contact>? FindAllByName(string name)
    {
        var filter = Builders<Contact>.Filter.Eq(p=>p.Name, name);
        return _collection.Find(filter).ToList();
    }
    
    public IEnumerable<Contact>? FindAllByPhone(string number)
    {
        var filter = Builders<Contact>.Filter.ElemMatch("Phones", Builders<Phone>.Filter.Eq(p=>p.Number, number));
        return _collection.Find(filter).ToList();
    }
    
    public IEnumerable<Contact>? FindAllByComment(string comment)
    {
        var filter = Builders<Contact>.Filter.ElemMatch("Phones", Builders<Phone>.Filter.Eq(p=>p.Comment, comment));
        return _collection.Find(filter).ToList();
    }

    public IEnumerable<Contact>? GetAll()
    {
        return _collection.Find(new BsonDocument()).ToList();
    }
}