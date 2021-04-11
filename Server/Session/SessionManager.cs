using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    class SessionManager
    {
        Dictionary<uint, ClientSession> _sessions = new Dictionary<uint, ClientSession>();

        uint _sessionID = 0;

        public ClientSession Generate()
        {
            lock (_lock)
            {
                uint id = ++_sessionID;

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
                _sessions.Remove(session.ID);
            }
        }

        #region singleton, lock
        static SessionManager _sessionManager = new SessionManager();
        public static SessionManager Instance { get { return _sessionManager; } }

        object _lock = new object();
        #endregion
    }
}
