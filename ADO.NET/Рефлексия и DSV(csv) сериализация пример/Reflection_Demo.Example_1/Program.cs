using System.Reflection;
using Reflection_Demo.Example_1;

var test = new TestClass();

var type = test.GetType();

/*
Console.WriteLine(type.Name);
Console.WriteLine(type.FullName);
Console.WriteLine(type.Assembly.FullName);
Console.WriteLine(type.Assembly.Location);

foreach (var method in type.GetMethods())
{
    Console.WriteLine(method.Name);
}

foreach (var property in type.GetProperties())
{
    Console.WriteLine(property.Name);
}

foreach (var field in type.GetFields())
{
    Console.WriteLine(field.Name);
}

foreach (var constructor in type.GetConstructors())
{
    Console.WriteLine(constructor.Name);
}

foreach (var interfaceInfo in type.GetInterfaces())
{
    Console.WriteLine(interfaceInfo.Name);
}

foreach (MemberInfo member in type.GetMembers(BindingFlags.DeclaredOnly
                                                | BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public))
{
    Console.WriteLine($"{member.DeclaringType} {member.MemberType} {member.Name}");
}*/

var toString = type.GetMethod("toString", BindingFlags.Instance | BindingFlags.NonPublic);

var result = toString.Invoke(test, null);
Console.WriteLine(result);