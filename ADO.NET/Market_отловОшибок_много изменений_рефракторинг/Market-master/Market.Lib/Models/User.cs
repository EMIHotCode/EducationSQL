namespace Market.Lib.Models;

public record User
{
    public int Id { get; set; }
    public string UserName { get; set; }
    // 
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Patronymic { get; set; }
}