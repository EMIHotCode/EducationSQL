using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace PhoneBook_v3.BL.Models;

public class Contact : IEquatable<Contact>
{
    public ObjectId Id { get; set; }
    
    public required string Name { get; set; }
    
    [BsonIgnoreIfNull]
    public string? LastName { get; set; }
    [BsonIgnoreIfNull]
    public string? Patronymic { get; set; }
    
    public List<Phone> Phones { get; set; } = [];

    #region IEquatable

    public bool Equals(Contact? other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        return Name == other.Name && LastName == other.LastName && Patronymic == other.Patronymic && EqualsPhones(other.Phones);
    }

    private bool EqualsPhones(IEnumerable<Phone>? other)
    {
        if (other is null) return false;
        if (Phones.Count != other.Count()) return false;
        return Phones.All(phone => other.Any(otherPhone => phone.Equals(otherPhone)));
    }

    public override bool Equals(object? obj)
    {
        if (obj is null) return false;
        if (ReferenceEquals(this, obj)) return true;
        if (obj.GetType() != GetType()) return false;
        return Equals((Contact)obj);
    }

    public override int GetHashCode()
    {
        return HashCode.Combine(Name, LastName, Patronymic);
    }

    public static bool operator ==(Contact? left, Contact? right)
    {
        return Equals(left, right);
    }

    public static bool operator !=(Contact? left, Contact? right)
    {
        return !Equals(left, right);
    }

    #endregion
}