using PhoneBook_v3.BL.Models;

namespace PhoneBook_v3.BL.Test
{
    public class PhoneBookTest
    {
        private const string ConnectionString = "mongodb://localhost:27017";
        
        [Fact]
        public void FindAllByNameTest()
        {
            var expected = new List<Contact>()
            {
                new()
                {
                    Name = "Ivan",
                    LastName = "Doe",
                    Phones =
                    [
                        new Phone()
                        {
                            Type = "Mobile",
                            Number = "1234567890"
                        },

                        new Phone()
                        {
                            Type = "Home",
                            Number = "1234567890",
                            Comment = "+359"
                        }
                    ]
                }
            };
            
            var phoneBook = new PhoneBook(ConnectionString);
            var actual = phoneBook.FindAllByName("Ivan");
            
            Assert.Equal(expected, actual);
        }
    }
}
