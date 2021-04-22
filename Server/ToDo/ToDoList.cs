using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    class ToDoList
    {
        List<ClientSession> _sessions = new List<ClientSession>();
        int _id;

        object _lock = new object();

        public ToDoList(int id)
        {
            _id = id;
        }

        public void BroadCast(byte[] packet)
        {
            lock (_lock)
            {
                foreach (ClientSession session in _sessions)
                    session.Send(packet);
            }
        }

        public void Enter(ClientSession session)
        {
            lock (_lock)
            {
                _sessions.Add(session);
            }
        }

        public void Leave(ClientSession session)
        {
            lock (_lock)
            {
                _sessions.Remove(session);
                if (_sessions.Count == 0)
                {
                    ToDoListManager.Instance.Remove(_id);
                }
            }
        }
    }
}
