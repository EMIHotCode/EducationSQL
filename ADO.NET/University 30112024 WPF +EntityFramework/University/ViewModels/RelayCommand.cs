using System.Windows.Input;

namespace University.ViewModels;

public class RelayCommand : ICommand
{
    private readonly Action<object?> _execute;
    private readonly Predicate<object?> _canExecute;
    //private readonly Func<object?, bool> _canExecute; аналогично Predicate

    public RelayCommand(Action<object?> execute, Predicate<object?>? canExecute = null)
    {
        _execute = execute;
        _canExecute = canExecute ?? (_ => true);
    }

    public bool CanExecute(object? parameter) => _canExecute.Invoke(parameter);

    public void Execute(object? parameter) => _execute.Invoke(parameter);

    public event EventHandler? CanExecuteChanged
    {
        add => CommandManager.RequerySuggested += value;
        remove => CommandManager.RequerySuggested -= value;
    }
}