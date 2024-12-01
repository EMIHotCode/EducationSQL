using Reflection_Demo.Csv_Serializer;

/*var test = new Test(0, "test");
var csv = CsvSerializer.Serialize(test);
Console.WriteLine(csv);

var test2 = new Test2(1, "Starinin", "Andrey", new DateTime(1986, 2, 18));
var csv2 = CsvSerializer.Serialize(test2);
Console.WriteLine(csv2);*/

/*var test3 = new List<Test2>()
{
    new Test2(1, "Starinin", "Andrey", new DateTime(1986, 2, 18)),
    new Test2(1, "Starinin", "Andrey", new DateTime(1986, 2, 18)),
    new Test2(1, "Starinin", "Andrey", new DateTime(1986, 2, 18))
};*/
var test3 = new Dictionary<Test, Test2>()
{
    { new Test(0, "test"), new Test2(1, "Starinin", "Andrey", new DateTime(1986, 2, 18)) },
    { new Test(1, "test1"), new Test2(2, "Starinina", "Anna", new DateTime(1990, 3, 15)) },
};
var csv3 = CsvSerializer.Serialize(test3);
Console.WriteLine(csv3);

return;


class Test
{
    public readonly int id;
    public readonly string name;

    public Test(int id, string name)
    {
        this.id = id;
        this.name = name;
    }
}

[CsvSeparator("|")]
class Test2
{

    [CsvIgnore(true)]   // игнорирование этого атриббута 
    public readonly int id;
    
    [CsvIgnore(false)]   //  атрибуты [CsvIgnore(false)] - атрибут не нужно игнорировать
    public readonly string lastName;
    public readonly string firstName;
        // аттрибут у поля может и не быть поэтому принимает значение при сериализации значение NULL
    public readonly DateTime date;

    public Test2(int id, string lastName, string firstName, DateTime date)
    {
        this.id = id;
        this.lastName = lastName;
        this.firstName = firstName;
        this.date = date;
    }
}