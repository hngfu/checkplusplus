using Server.Message;
using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    sealed class ClientSession : Session
    {
        public uint ID { get; set; }
        public int ToDoListID { get; set; }
        public ToDoList ToDoList { get; set; }

        public override void OnRecv(ArraySegment<byte> data)
        {
            MessageManager.Instance.OnRecvPacket(this, data);
        }

        public override void OnDisconnect()
        {
            ToDoList.Leave(this);
            SessionManager.Instance.Remove(this);
        }
    }
}
