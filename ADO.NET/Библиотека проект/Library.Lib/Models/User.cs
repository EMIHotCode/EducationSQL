namespace Library.Lib.Models;

public record User
{
    public int PersonId { get; set; }
    public string Phone { get; set; }
    
    public string Email { get; set; }
    public int CountBooksTake { get; set; }
    public bool IsActiveUser { get; set; }
}