namespace System
{
    public unsafe sealed class String
    {
        public char this[int Index]
        {
            get
            {
                return StringData[Index];
            }
            set
            {
                StringData[Index] = value;
            }
        }

        private readonly char* StringData;
        public int Length
        {
            get
            {
                int Length = 0;
                while (StringData[Length] != 0)
                {
                    Length++;
                }
                return Length;
            }
        }
    }
}