namespace Reflection_Demo.Csv_Serializer;

public class CsvSeparatorAttribute : Attribute
{
    public string Separator { get; private set; }
    
    public CsvSeparatorAttribute(string separator = ";")
    {
        Separator = separator;
    }
}