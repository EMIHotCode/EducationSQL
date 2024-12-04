using System.Collections.ObjectModel;
using System.Windows.Input;
using Microsoft.EntityFrameworkCore;
using University.Models;

namespace University.ViewModels;

public class MainWindowViewModel : ViewModelBase
{
    private readonly DataBaseContext _db;
    
    //сюда записываются все наблюдаемые свойства 
    #region ObservableProperties  

    private string? _searchText; // для текста поиска input text
    public string? SearchText
    {
        get => _searchText;
        set => SetField(ref _searchText, value);
    }
    
    public ObservableCollection<Teacher> Teachers { get; } = [];
    
    private Teacher? _selectedTeacher;
    public Teacher? SelectedTeacher
    {
        get => _selectedTeacher;
        set
        { 
            var result = SetField(ref _selectedTeacher, value);
            
            if (!result) return;
            
            Id = value?.Id.ToString();
            LastName = value?.LastName;
            FirstName = value?.FirstName;
            SelectedFaculty = value?.Faculty;
            InitSubjects(value!.Subjects);  // ! - гарантируем что не null 
        }
    }

    private string? _id; // id string так как его выводим только на экран 
    public string? Id
    {
        get => _id; 
        set => SetField(ref _id, value);
    }
    
    private string? _lastName;
    public string? LastName
    {
        get => _lastName;
        set => SetField(ref _lastName, value);
    }
    
    private string? _firstName;
    public string? FirstName
    {
        get => _firstName;
        set => SetField(ref _firstName, value);
    }
    
    public ObservableCollection<Faculty> Faculties { get; } = [];
    private Faculty? _selectedFaculty;
    public Faculty? SelectedFaculty
    {
        get => _selectedFaculty;
        set => SetField(ref _selectedFaculty, value);
    }
    
    public ObservableCollection<Subject> Subjects { get; } = [];

    #endregion
    
    
    #region Commands
    
    public ICommand CommandSearch { get; }
    public ICommand CommandClearSearch { get; }
    
    public ICommand CommandSave { get; }
    public ICommand CommandDelete { get; }
    public ICommand CommandClear { get; }
    
    #endregion

    public MainWindowViewModel()
    {
        _db = new DataBaseContext();
        _db.Teachers
            .Include(t => t.Faculty)
            .Include(t => t.Subjects);
        
        InitTeachers(_db.Teachers);
        InitFaculties(_db.Faculties);
        //InitSubjects(_db.Subjects);
    }

    #region Methods

    private void InitTeachers(IEnumerable<Teacher> teachers)
    {
        Teachers.Clear();

        foreach (var teacher in teachers)
        {
            Teachers.Add(teacher);
        }
    }

    private void InitFaculties(IEnumerable<Faculty> faculties)
    {
        Faculties.Clear();

        foreach (var faculty in faculties)
        {
            Faculties.Add(faculty);
        }
    }
    
    private void InitSubjects(IEnumerable<Subject> subjects)
    {
        Subjects.Clear();

        foreach (var subject in subjects)
        {
            Subjects.Add(subject);
        }
    }

    #endregion
}