using universitet_mikl.Models;

namespace universitet_mikl;

public class Teacher
{
    public Guid Id { get; set; }
    public string LastName { get; set; }
    public string FirstName { get; set; }
    

    public Guid FacultyId { get; set; }
    public Faculty Faculty { get; set; }
    
    public List<Subject> Subjects { get; set; }
}