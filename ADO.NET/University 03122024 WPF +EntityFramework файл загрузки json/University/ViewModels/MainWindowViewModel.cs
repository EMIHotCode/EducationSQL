using System.Collections.ObjectModel;
using System.Windows.Input;
using Microsoft.EntityFrameworkCore;
using University.Models;

namespace University.ViewModels;

public class MainWindowViewModel : ViewModelBase
{
    private readonly DataBaseContext _db;
    
    #region ObservableProperties

    private string? _searchText;
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
            InitSubjects(value?.Subjects);
        }
    }

    private string? _id;
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
        var connectionString = App.Current.Resources["ConnectionString"] as string; // as string - вернет null в случае чего который нужно будет обрабатывать, ToString() - выкинет исключение если null которое нужно обрабатывать
        _db = new DataBaseContext(connectionString);
        _db.Teachers
            .Include(t => t.Faculty)  // подгружаем данные по факультетам из класса teacher
            .Include(t => t.Subjects)  // подгружаем данные по предметам из класса teacher
            .ToList();
        
        InitTeachers(_db.Teachers);
        InitFaculties(_db.Faculties);

        CommandSave = new RelayCommand(ExecSave, CanExecSave);
        CommandClear = new RelayCommand(ExecClear, CanExecClear);
        CommandDelete = new RelayCommand(ExecDelete, CanExecDelete);
        
        CommandSearch = new RelayCommand(ExecSearch, CanExecSearch);
        CommandClearSearch = new RelayCommand(ExecClearSearch, CanExecClearSearch);
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
    
    private void InitSubjects(IEnumerable<Subject>? subjects)
    {
        if (subjects is null)
        {
            Subjects.Clear();
            
            return;
        }
        
        Subjects.Clear();

        foreach (var subject in subjects)
        {
            Subjects.Add(subject);
        }
    }

    private void ExecSave(object? parameter = null)
    {
        if (SelectedTeacher is null)  // наблюдаемое свойство если SelectedTeacher выбран то изменяем его в базе , если не выбран значит заводим нового пользователя
        {
            _db.Teachers.Add(new Teacher()
            {
                Id = Guid.NewGuid(),  // новый guid для нового пользователя
                LastName = LastName!,
                FirstName = FirstName!,
                Faculty = SelectedFaculty!,
                Subjects = Subjects.ToList()
            });
        }
        else
        {
            //если существует SelectedTeacher выбран то изменяем его в базе
            var teacher = _db.Teachers.Single(t => t.Id == SelectedTeacher.Id); // в teacher придет ссылка на найденого по id пользователя 
            teacher.LastName = LastName!;  // поэтому только меняем ФИО и не трогаем id 
            teacher.FirstName = FirstName!;
            teacher.Faculty = SelectedFaculty!;
            teacher.Subjects = Subjects.ToList();
        }
        
        _db.SaveChanges();  // обязательно сохранение
        
        ExecClear();
        InitTeachers(_db.Teachers);
    }

    private bool CanExecSave(object? parameter = null) // проверка что поля LastName, FirstName, Faculty не пустые 
    {
        return !string.IsNullOrEmpty(LastName) && !string.IsNullOrEmpty(FirstName) && SelectedFaculty is not null;
    }

    private void ExecClear(object? parameter = null) // обнуляет поля
    {
        SelectedTeacher = null;

        Id = null;
        LastName = null;
        FirstName = null;
        SelectedFaculty = null;
        Subjects.Clear();
    }
    
    private bool CanExecClear(object? parameter = null) // если хотя бы одно из полей не пустое 
    {
        return !string.IsNullOrEmpty(LastName) || !string.IsNullOrEmpty(FirstName) || SelectedFaculty is not null;
    }
    
    private void ExecDelete(object? parameter = null)
    {
        var teacher = _db.Teachers.Single(t => t.Id == SelectedTeacher!.Id);
        _db.Teachers.Remove(teacher);
        _db.SaveChanges();
        
        ExecClear();
        InitTeachers(_db.Teachers);
    }
    
    private bool CanExecDelete(object? parameter = null) // срабатывает только когда SelectedTeacher is not null
    {
        return SelectedTeacher is not null;
    }
    
    private void ExecSearch(object? parameter = null)
    {
        var result = _db.Teachers
            .Where(t => t.LastName.ToLower().Contains(SearchText!.ToLower()) ||
                        t.FirstName.ToLower().Contains(SearchText!.ToLower()));
        InitTeachers(result);
    }
    
    private bool CanExecSearch(object? parameter = null)
    {
        return !string.IsNullOrEmpty(SearchText);
    }
    
    private void ExecClearSearch(object? parameter = null)
    {
        SearchText = null;
    }
    
    private bool CanExecClearSearch(object? parameter = null)
    {
        return !string.IsNullOrEmpty(SearchText);
    }

    #endregion
}