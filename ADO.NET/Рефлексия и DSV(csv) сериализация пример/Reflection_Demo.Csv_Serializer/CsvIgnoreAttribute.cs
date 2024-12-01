namespace Reflection_Demo.Csv_Serializer;

public class CsvIgnoreAttribute : Attribute
{
    public bool Ignore { get; private set; }

    public CsvIgnoreAttribute(bool ignore)
    {
        Ignore = ignore;
    }
}