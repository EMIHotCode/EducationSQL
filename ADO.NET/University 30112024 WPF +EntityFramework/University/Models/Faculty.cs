namespace University.Models;

public class Faculty
{
    public Guid Id { get; set; }
    public string FacultyName { get; set; }

    public List<Teacher> Teachers { get; set; }
}