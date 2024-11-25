using PhoneBook_v3.DAL.Models;

namespace PhoneBook_v3.DAL.Tables;

public static class DbName
{
    public static string TablePersons => "table_persons";
    public static string TablePhones => "table_phones";
    public static string TablePhoneTypes => "table_phone_types";
    
    public static Dictionary<Type, string> TableNames => new()
    {
        { typeof(Person), TablePersons },
        { typeof(Phone), TablePhones },
        { typeof(PhoneType), TablePhoneTypes }
    };
}