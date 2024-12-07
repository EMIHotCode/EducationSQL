namespace University.Models;

public class Subject
{
    public Guid Id { get; set; }
    public string SubjectName { get; set; }
    
    public List<Teacher> Teachers { get; set; }
}