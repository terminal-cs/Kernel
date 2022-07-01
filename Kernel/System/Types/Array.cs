using Internal.Runtime.CompilerServices;
using System.Runtime.CompilerServices;

namespace System
{
    public abstract unsafe class Array
    {
        // This field should be the first field in Array as the runtime/compilers depend on it
        internal int _numComponents;

        public int Count
        {
            get
            {
                // NOTE: The compiler has assumptions about the implementation of this method.
                // Changing the implementation here (or even deleting this) will NOT have the desired impact
                return _numComponents;
            }
        }

        public const int MaxArrayLength = 0x7FEFFFFF;

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private ref int GetRawMultiDimArrayBounds()
        {
            return ref Unsafe.AddByteOffset(ref _numComponents, (nuint)sizeof(void*));
        }
    }

    class Array<T> : Array { }
}