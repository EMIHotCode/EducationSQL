namespace PhoneBook_v3.DAL.Models;

public class Phone
{
    public int Id { get; set; }
    public required int PersonId { get; set; }
    public required string Number { get; set; }
    public required int PhoneTypeId { get; set; }
    public string? Comment { get; set; }
}