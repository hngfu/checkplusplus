using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace Server
{
    class Listener
    {
        Socket _socket;
        Func<ClientSession> _sessionFactory;

        public Listener(IPEndPoint endPoint, Func<ClientSession> sessionFactory)
        {
            _socket = new Socket(endPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            _sessionFactory = sessionFactory;

            _socket.Bind(endPoint);
            _socket.Listen(100);

            for (int i = 0; i < 8; i++)
            {
                SocketAsyncEventArgs args = new SocketAsyncEventArgs();
                args.Completed += OnAcceptCompleted;
                RegisterAccept(args);
            }
        }

        void RegisterAccept(SocketAsyncEventArgs args)
        {
            bool isPending = _socket.AcceptAsync(args);
            if (isPending == false)
                OnAcceptCompleted(null, args);
        }

        void OnAcceptCompleted(object sender, SocketAsyncEventArgs e)
        {
            if (e.SocketError == SocketError.Success)
            {
                Session session = _sessionFactory.Invoke();
                session.Start(e.AcceptSocket);
            }
            else
                Console.WriteLine($"OnAcceptCompleted Error: {e}");

            RegisterAccept(e);
        }
    }
}
