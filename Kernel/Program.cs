using System.Runtime;

unsafe class Program
{
    [RuntimeExport("Main")]
    static void Main()
    {
        while (true)
        {
            for (int I = 0; I < 20 * 80; I++)
            {
                *((ulong*)0xb8000 + I) = 0;
            }
        }
    }
}