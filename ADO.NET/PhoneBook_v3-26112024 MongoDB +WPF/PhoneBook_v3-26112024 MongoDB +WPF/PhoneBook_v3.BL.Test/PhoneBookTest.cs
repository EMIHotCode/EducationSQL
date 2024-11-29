using PhoneBook_v3.BL.Models;

namespace PhoneBook_v3.BL.Test
{
    public class PhoneBookTest
    {
        private const string ConnectionString = "mongodb://localhost:27017";

        private readonly IEnumerable<Contact> _expectedContacts = new List<Contact>()
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
        
        [Fact]
        public void FindAllByNameTest()
        {
            var phoneBook = new PhoneBook(ConnectionString);
            var actual = phoneBook.FindAllByName("Ivan");
            
            Assert.Equal(_expectedContacts, actual);
        }
        
        [Fact]
        public void FindAllByCommentTest()
        {
            var phoneBook = new PhoneBook(ConnectionString);
            var actual = phoneBook.FindAllByComment("+359");
            
            Assert.Equal(_expectedContacts, actual);
        }
        
        [Fact]
        public void FindAllByPhoneTest()
        {
        var expectedContacts = new List<Contact>()
        {
            new()
            {
                Name = "John1",
                Phones =
                [
                    new Phone()
                    {
                        Type = "Mobile",
                        Number = "12345"
                    }
                ]
            }
        };
            
            var phoneBook = new PhoneBook(ConnectionString);
            var actual = phoneBook.FindAllByPhone("12345");
            
            Assert.Equal(expectedContacts, actual);
        }
    }
}
