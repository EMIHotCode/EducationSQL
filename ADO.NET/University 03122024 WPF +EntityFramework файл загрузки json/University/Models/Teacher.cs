using System.ComponentModel.DataAnnotations.Schema;

namespace University.Models;

public class Teacher
{
    public Guid Id { get; set; }
    [NotMapped]
    public string ShortId => $"{Id.ToString("B")[1..9]}";
    public string LastName { get; set; }
    public string FirstName { get; set; }
    
    [NotMapped]
    public string FullName => $"{LastName} {FirstName}";

    public Guid FacultyId { get; set; }
    public Faculty Faculty { get; set; }
    
    public List<Subject> Subjects { get; set; }
}