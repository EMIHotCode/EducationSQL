namespace PhoneBook_v3.BL;

public class Contact
{
    public int? Id { get; set; }
    
    public required string Name { get; set; }
    public string? LastName { get; set; }
    public string? Patronymic { get; set; }
    
    public List<Phone> Phones { get; set; } = [];
}