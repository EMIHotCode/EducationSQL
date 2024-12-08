using System.Runtime.InteropServices.JavaScript;

namespace BoilerRoomJournal.Model;

public class JournalPage
{
    public DateTime Date { get; set; }
    
    public List<employee> Employees { get; set; }
    // температура
    public int temp8am { get; set; }
    public int temp11am { get; set; }
    public int temp14pm { get; set; }
    public int temp17pm { get; set; }
    public int temp20pm { get; set; }
    public int temp23pm { get; set; }
    public int temp2am { get; set; }
    public int temp5am { get; set; }
    // давление газа 
    public float p_gas8am { get; set; }
    public float p_gas11am { get; set; }
    public float p_gas14pm { get; set; }
    public float p_gas17pm { get; set; }
    public float p_gas20pm { get; set; }
    public float p_gas23pm { get; set; }
    public float p_gas2am { get; set; }
    public float p_gas5am { get; set; }
    // давление воды
    public float p_water8am { get; set; }
    public float p_water11am { get; set; }
    public float p_water14pm { get; set; }
    public float p_water17pm { get; set; }
    public float p_water20pm { get; set; }
    public float p_water23pm { get; set; }
    public float p_water2am { get; set; }
    public float p_water5am { get; set; }
    // расход воды по часам
    public int consumption8am { get; set; }
    public int consumption11am { get; set; }
    public int consumption20pm { get; set; }
    public int consumption17pm { get; set; }
    public int consumption23pm { get; set; }
    public int consumption14pm { get; set; }
    public int consumption2am { get; set; }
    public int consumption5am { get; set; }
}