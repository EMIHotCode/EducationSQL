using MongoDB.Driver;
using PhoneBook_v3.BL.Models;

namespace PhoneBook_v3.BL;

public partial class PhoneBook
{
    private readonly IMongoCollection<Contact> _collection;
    
    public PhoneBook(string connectionString)
    {
        var client = new MongoClient(connectionString);
        var database = client.GetDatabase("phonebook_db");
        _collection = database.GetCollection<Contact>("phonebook");
    }
    
    public bool AddContact(Contact contact) //TODO
    {
        _collection.InsertOne(contact);
        return true;
    }
    
    public bool UpdateContact(Contact contact) //TODO
    {
        //_collection.FindOneAndReplace(new BsonDocument("_id", contact.Id), contact);
        
        var filter = Builders<Contact>.Filter.Eq(p=>p.Id, contact.Id);
        _collection.FindOneAndReplace(filter, contact);
        
        return true; 
    }
    
    public bool DeleteContact(Contact contact) //TODO
    {
        var filter = Builders<Contact>.Filter.Eq(p=>p.Id, contact.Id);
        _collection.DeleteOne(filter);

        return true;
    }
}