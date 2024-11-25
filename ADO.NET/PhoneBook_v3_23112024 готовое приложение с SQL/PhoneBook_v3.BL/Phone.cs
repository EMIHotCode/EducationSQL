namespace PhoneBook_v3.BL;

public class Phone
{
    public required string Number { get; set; }
    public required string Type { get; set; }
    public string? Comment { get; set; }
}