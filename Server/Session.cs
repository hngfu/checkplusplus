using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace Server
{
    abstract class Session
    {
        Socket _socket;

        public abstract void OnConnected();
        public abstract void OnRecv(byte[] data);
        public abstract void OnSend();
        public abstract void OnDisconnected();

        public Session(Socket socket)
        {
            _socket = socket;
        }

        public void Disconnect()
        {
            if (_socket.Connected == false)
                return;

            try
            {
                _socket.Shutdown(SocketShutdown.Both);
                _socket.Close();
                OnDisconnected();
            }
            catch (Exception e)
            {
                Console.WriteLine($"Disconnect Failed: {e}");
            }
        }

        public void Send(byte[] data)
        {
            if (_socket.Connected == false)
                return;

            try
            {
                SocketAsyncEventArgs sendArgs = new SocketAsyncEventArgs();
                sendArgs.SetBuffer(data, 0, data.Length);
                bool isPending = _socket.SendAsync(sendArgs);
                if (isPending == false)
                    OnSendCompleted(null, sendArgs);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Send Failed: {e}");
            }
        }

        void OnSendCompleted(object sender, SocketAsyncEventArgs e)
        {
            if (e.SocketError == SocketError.Success && e.BytesTransferred > 0)
            {
                OnSend();
            }
            else
                Disconnect();
        }
    }
}
