using System.Runtime;

unsafe class Program
{
    [RuntimeExport("Main")]
    static void Main()
    {
        while (true)
        {
            System.Console.WriteLine("Hello, World!");
        }
    }
}