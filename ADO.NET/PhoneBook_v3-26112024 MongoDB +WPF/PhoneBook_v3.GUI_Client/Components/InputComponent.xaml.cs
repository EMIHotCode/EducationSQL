using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace PhoneBook_v3.GUI_Client.Components;

public partial class InputComponent : UserControl
{
    public static readonly DependencyProperty LabelContentProperty;
    public static readonly DependencyProperty InputTextProperty;
    public static readonly DependencyProperty OnTextInputCommandProperty;

    static InputComponent()
    {
        LabelContentProperty = DependencyProperty.Register(
            name: nameof(LabelContent),
            propertyType: typeof(string),
            ownerType: typeof(InputComponent));
        InputTextProperty = DependencyProperty.Register(
            name: nameof(InputText),
            propertyType: typeof(string),
            ownerType: typeof(InputComponent));
        OnTextInputCommandProperty = DependencyProperty.Register(
            name: nameof(OnTextInputCommand),
            propertyType: typeof(ICommand),
            ownerType: typeof(InputComponent));
    }

    public string LabelContent
    {
        get => (string)GetValue(LabelContentProperty);
        set => SetValue(LabelContentProperty, value);
    }
    public string InputText
    {
        get => (string)GetValue(InputTextProperty);
        set => SetValue(InputTextProperty, value);
    }

    public ICommand? OnTextInputCommand
    {
        get => (ICommand)GetValue(OnTextInputCommandProperty);
        set => SetValue(OnTextInputCommandProperty, value);
    }
    
    public InputComponent()
    {
        InitializeComponent();
    }

    private void OnTextInput(object sender, TextChangedEventArgs e)
    {
        OnTextInputCommand?.Execute(null);
    }
}