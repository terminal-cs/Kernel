namespace System
{
    public unsafe static class Console
    {
        public static ConsoleColor BackgroundColor { get; set; } = ConsoleColor.Black;
        public static ConsoleColor ForegroundColor { get; set; } = ConsoleColor.White;
        public static ulong* Buffer { get; set; } = (ulong*)0xB8000;
        public static int Width { get; set; }
        public static int Height { get; set; }
        public static int X { get; set; }
        public static int Y { get; set; }

        public static ulong GetValue(char Char)
        {
            return (ushort)(Char | (ushort)((byte)ForegroundColor | (byte)BackgroundColor << 4) << 8);
        }

        public static void Clear()
        {
            ulong Cache = GetValue(' ');
            for (int I = 0; I < Width * Height; I++)
            {
                Buffer[I] = Cache;
            }
        }

        public static void WriteLine(string String)
        {
            for (int I = 0; I < String.Length; I++)
            {
                Write(String[I]);
            }
            Write('\n');
        }
        public static void WriteLine()
        {
            Write('\n');
        }
        public static void Write(string String)
        {
            for (int I = 0; I < String.Length; I++)
            {
                Write(String[I]);
            }
        }
        public static void Write(char Char)
        {
            if (Char == '\n')
            {
                Y++;
                return;
            }
            if (Char == '\t')
            {
                X += 4;
            }
            if (X + 1 == Width)
            {
                X -= Width;
                Y++;
            }
            if (Y + 1 > Height)
            {
                for (int Y = 1; Y < Height; Y++)
                {
                    for (int X = 0; X < Width; X++)
                    {
                        Buffer[((Y - 1) * Width) + X] = Buffer[(Y * Width) + X];
                    }
                }
            }
            Buffer[(Width * Y++) + X++] = GetValue(Char);
        }
    }
}