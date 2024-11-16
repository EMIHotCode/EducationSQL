using System.Collections.ObjectModel;
using System.Windows;
using Dapper;
using Microsoft.Data.Sqlite;

namespace PhoneBook;
// подключаем Microsoft.Data.Sqlite - библиотека для работы с Sqlite 9.0 через Dependencies\Manage NuGet Packages
// подключаем Dapper - библиотеку через Dependencies\Manage NuGet Packages
public partial class MainWindow : Window
{
    private readonly SqliteConnection _db;
    public ObservableCollection<UserPhone> UserPhones { get; set; } = [];
    
    public MainWindow()
    {
        Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
        _db = new SqliteConnection("Data Source=phone_book.db");
        
        InitializeComponent();

        Loaded += (_, _) =>    // событие Loaded когда окно уже загрузилось 
        {
            _db.Open();
            const string sql = "SELECT * FROM view_phones";
            var result = _db.Query<UserPhone>(sql);
            
            foreach (var userPhone in result)
            {
                UserPhones.Add(userPhone);
            }
            //DataGrid.ItemsSource = result;
            _db.Close();
        };
    }
}