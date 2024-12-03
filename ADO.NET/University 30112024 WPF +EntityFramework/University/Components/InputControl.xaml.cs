using System.Windows;
using System.Windows.Controls;

namespace University.Components;

public partial class InputControl : UserControl
{
    public static readonly DependencyProperty LabelProperty;
    public static readonly DependencyProperty InputTextProperty;

    static InputControl()
    {
        LabelProperty = DependencyProperty.Register(nameof(Label), typeof(string), typeof(InputControl));
        InputTextProperty = DependencyProperty.Register(nameof(InputText), typeof(string), typeof(InputControl));
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
    
    public InputControl()
    {
        InitializeComponent();
        //this.DataContext = this;
    }
}