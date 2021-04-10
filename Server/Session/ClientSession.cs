using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    sealed class ClientSession : Session
    {
        public uint ID { get; set; }

        public override void OnRecv(byte[] data)
        {
            
        }
    }
}
