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
        var filter = Builders<Contact>.Filter.All(nameof(Contact.Phones), number); //BUG
        return _collection.Find(filter).ToList();
    }
    
    public IEnumerable<Contact>? FindAllByComment(string comment)
    {
        var filter = Builders<Contact>.Filter.All("Phones", new BsonDocument{{ "Comment", comment }}); //BUG
        return _collection.Find(filter).ToList();
    }

    public IEnumerable<Contact>? GetAll()
    {
        return _collection.Find(new BsonDocument()).ToList();
    }
}