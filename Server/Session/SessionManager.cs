using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    class SessionManager
    {
        Dictionary<uint, ClientSession> _sessions = new Dictionary<uint, ClientSession>();

        uint _sessionID = 5000;     // 0~4999는 pooling 예약
        Queue<uint> _idPool = new Queue<uint>();

        public ClientSession Generate()
        {
            lock (_lock)
            {
                uint id;
                if (_idPool.Count > 0)
                    id = _idPool.Dequeue();
                else
                    id = _sessionID++;

                ClientSession session = new ClientSession
                {
                    ID = id
                };

                _sessions.Add(id, session);

                return session;
            }
        }

        public void Remove(ClientSession session)
        {
            lock (_lock)
            {
                uint id = session.ID;
                _sessions.Remove(id);
                _idPool.Enqueue(id);
            }
        }

        #region singleton, lock, 초기화시 idPool 채움
        static SessionManager _sessionManager = new SessionManager();
        public static SessionManager Instance { get { return _sessionManager; } }

        object _lock = new object();

        private SessionManager()
        {
            lock (_lock)
            {
                for (uint i = 0; i < 5000; i++)
                {
                    _idPool.Enqueue(i);
                }
            }
        }
        #endregion
    }
}
