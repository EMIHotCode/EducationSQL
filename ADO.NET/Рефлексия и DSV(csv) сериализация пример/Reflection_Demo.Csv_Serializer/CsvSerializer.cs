using System.Reflection;
using System.Text;

namespace Reflection_Demo.Csv_Serializer;

public static class CsvSerializer
{
    public static string Serialize<T>(T obj, string separator = ";")  // Мы будем возвращать строку ОЧЕНЬ ВАЖНО. Хоть в передачу в файл, хоть передача по сети, хоть вывод на консоль
    {
        //var type = typeof(T);
        var type = obj.GetType();
        var separatorAttr = type.GetCustomAttribute<CsvSeparatorAttribute>();
        if (separatorAttr != null)
        {
            separator = separatorAttr.Separator;
        }
        
        var sb = new StringBuilder(); // если бы просто использовали тип string то при каждом += конкатенации создавалась бы новая строка это затратно при множественном выполрнении 

        var interfaces = type.GetInterfaces();
        foreach (var @interface in interfaces)
        {
            if (@interface.IsGenericType && @interface.GetGenericTypeDefinition() == typeof(IEnumerable<>))
            {
                var enumerable = obj as IEnumerable<object>;
                foreach (var o in enumerable)
                {
                    sb.Append(Serialize(o, separator));
                    sb.Append(Environment.NewLine);
                }
            }
            //TODO добавить обработку Dictionary<T1, T2>
        }
        
        var fields = type.GetFields();
        foreach (var field in fields)
        {
            var attr = field.GetCustomAttribute<CsvIgnoreAttribute>(); // атрибуты [CsvIgnore(false)] - атрибут не нужно игнорировать
            if (attr is { Ignore: true }) continue;

            sb.Append(field.GetValue(obj));
            sb.Append(separator);
        }

        sb.Remove(sb.Length - 1, 1);

        return sb.ToString();
    } 
}