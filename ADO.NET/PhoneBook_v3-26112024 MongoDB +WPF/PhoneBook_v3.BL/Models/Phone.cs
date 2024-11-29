using MongoDB.Bson.Serialization.Attributes;

namespace PhoneBook_v3.BL.Models;

public class Phone : IEquatable<Phone>
{
    public required string Number { get; set; }
    public required string Type { get; set; }
    
    [BsonIgnoreIfNull]
    public string? Comment { get; set; }

    #region IEquatable

    public bool Equals(Phone? other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        return Number == other.Number && Type == other.Type && Comment == other.Comment;
    }

    public override bool Equals(object? obj)
    {
        if (obj is null) return false;
        if (ReferenceEquals(this, obj)) return true;
        if (obj.GetType() != GetType()) return false;
        return Equals((Phone)obj);
    }

    public override int GetHashCode()
    {
        return HashCode.Combine(Number, Type, Comment);
    }
    
    public static bool operator ==(Phone? left, Phone? right)
    {
        return Equals(left, right);
    }

    public static bool operator !=(Phone? left, Phone? right)
    {
        return !Equals(left, right);
    }

    #endregion
}