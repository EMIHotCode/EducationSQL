using System.Windows;
using System.Windows.Controls;

namespace University.Components;

public partial class InputControl : UserControl
{
    public static readonly DependencyProperty LabelProperty; // статические поля класса
    public static readonly DependencyProperty InputTextProperty;

    static InputControl() // статический конструктор 
    {
        LabelProperty = DependencyProperty.Register(nameof(Label), typeof(string), typeof(InputControl));
        InputTextProperty = DependencyProperty.Register(nameof(InputText), typeof(string), typeof(InputControl));
    }
    
    public string Label  // значения в xaml коде к которым проиводится binding
    {
        get => (string)GetValue(LabelProperty);
        set => SetValue(LabelProperty, value);
    }

    public string InputText
    {
        get => (string)GetValue(InputTextProperty); 
        set => SetValue(InputTextProperty, value);
    }
    
    public InputControl()
    {
        InitializeComponent();
        //this.DataContext = this;
    }
}