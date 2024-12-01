namespace Reflection_Demo.Example_1;

public class TestClass
{
    private int _id;
    public int Id;
    
    public int Number { get; set; }

    public TestClass()
    {
        _id = -1;
        Id = -2;
        Number = -3;
    }
    
    private string toString()
    {
        return "TestClass";
    }
}