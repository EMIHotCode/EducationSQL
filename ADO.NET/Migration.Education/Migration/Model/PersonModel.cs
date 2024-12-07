namespace Migration.Model;

public class Person
{
    public Guid Id { get; set; }
    public string LastName { get; set; }
    public string FirstName { get; set; }

    public List<Phone> Phones { get; set; } = [];
    public List<Address> Addresses { get; set; } = [];
    public List<Email> Emails { get; set; } = [];
}

public class Phone
{
    public Guid Id { get; set; }
    public string Number { get; set; }
    
    public Guid PersonId { get; set; }
    public Person Person { get; set; }
}

public class Address
{
    public Guid Id { get; set; }
    public string Street { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }

    public Guid PersonId { get; set; }
    public Person Person { get; set; }
}
public class Email
{
    public Guid Id { get; set; }
    public string EmailAddress { get; set; }
    
    public Guid PersonId { get; set; }
    public Person Person { get; set; }
}
