using Server.Packet;
using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    sealed class ClientSession : Session
    {
        public uint ID { get; set; }

        public override void OnRecv(ArraySegment<byte> data)
        {
            MessageManager.Instance.OnRecvPacket(this, data);
        }
    }
}
