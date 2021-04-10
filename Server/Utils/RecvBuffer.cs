using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    class RecvBuffer
    {
        ArraySegment<byte> _buffer;
        int _readPos = 0;
        int _writePos = 0;

        public RecvBuffer(int bufferSize)
        {
            _buffer = new ArraySegment<byte>(new byte[bufferSize], 0, bufferSize);
        }

        int DataSize { get { return _writePos - _readPos; } }
        int FreeSize { get { return _buffer.Count - _writePos; } }

        public ArraySegment<byte> ReadSegment
        {
            get { return new ArraySegment<byte>(_buffer.Array, _readPos, DataSize); }
        }

        public ArraySegment<byte> WriteSegment
        {
            get { return new ArraySegment<byte>(_buffer.Array, _writePos, FreeSize); }
        }

        public void Clean()
        {
            if (DataSize == 0)
                _readPos = _writePos = 0;
            else
            {
                Array.Copy(_buffer.Array, _readPos, _buffer.Array, 0, DataSize);
                _readPos = 0;
                _writePos = DataSize;
            }
        }

        public void OnRead(int byteSize)
        {
            _readPos += byteSize;
        }

        public void OnWrite(int byteSize)
        {
            _writePos += byteSize;
        }
    }
}
