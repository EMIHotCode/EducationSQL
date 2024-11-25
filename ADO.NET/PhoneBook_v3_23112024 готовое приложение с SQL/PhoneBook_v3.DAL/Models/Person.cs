namespace PhoneBook_v3.DAL.Models;

public class Person
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public string? LastName { get; set; }
    public string? Patronymic { get; set; }
}