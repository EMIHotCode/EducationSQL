using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace University.ViewModels;

public abstract class ViewModelBase : INotifyPropertyChanged
{
    public event PropertyChangedEventHandler? PropertyChanged;

    protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
    // Метод setfield — это просто метод для установки свойства и запуска события изменения свойства.
    protected bool SetField<T>(ref T field, T value, [CallerMemberName] string? propertyName = null) // SetField можно поменять на SetProperty
    {
        if (EqualityComparer<T>.Default.Equals(field, value)) return false;
        field = value;
        
        OnPropertyChanged(propertyName);
        
        return true;
    }
}