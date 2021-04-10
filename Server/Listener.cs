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

        public Listener(IPEndPoint endPoint)
        {
            _socket = new Socket(endPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);

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

            }
            else
                Console.WriteLine($"OnAcceptCompleted Error: {e}");

            RegisterAccept(e);
        }
    }
}
