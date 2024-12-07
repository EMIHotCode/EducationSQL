using System.Windows;
using System.Windows.Controls;

namespace University.Components;

public partial class InputControl : UserControl
{
    public static readonly DependencyProperty LabelProperty;
    public static readonly DependencyProperty InputTextProperty;
    public static readonly DependencyProperty IsReadOnlyProperty; // чтобы id с правой стороны программы во view нельзя было менять 

    static InputControl()
    {
        LabelProperty = DependencyProperty.Register(nameof(Label), typeof(string), typeof(InputControl));
        InputTextProperty = DependencyProperty.Register(nameof(InputText), typeof(string), typeof(InputControl));
        IsReadOnlyProperty = DependencyProperty.Register(nameof(IsReadOnly), typeof(bool), typeof(InputControl)); // регестрируем это свойсво чтобы id с правой стороны программы во view нельзя было менять 
    }
    
    public string Label
    {
        get => (string)GetValue(LabelProperty);
        set => SetValue(LabelProperty, value);
    }

    public string InputText
    {
        get => (string)GetValue(InputTextProperty); 
        set => SetValue(InputTextProperty, value);
    }

    public bool IsReadOnly // создаем свойство для IsReadOnlyProperty 
    {
        get => (bool)GetValue(IsReadOnlyProperty);
        set => SetValue(IsReadOnlyProperty, value);
    }
    
    public InputControl()
    {
        InitializeComponent();
        //this.DataContext = this;
    }
}