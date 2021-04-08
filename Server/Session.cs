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
        RecvBuffer _recvBuffer = new RecvBuffer(65535);

        public abstract void OnConnected();
        public abstract void OnRecv(byte[] data);
        public abstract void OnSend();
        public abstract void OnDisconnected();

        public Session(Socket socket)
        {
            _socket = socket;

            RegisterRecv();
        }

        public void Send(byte[] data)
        {
            if (_socket.Connected == false)
                return;

            try
            {
                SocketAsyncEventArgs sendArgs = new SocketAsyncEventArgs();
                sendArgs.Completed += OnSendCompleted;
                sendArgs.SetBuffer(data, 0, data.Length);
                bool isPending = _socket.SendAsync(sendArgs);
                if (isPending == false)
                    OnSendCompleted(null, sendArgs);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Send failed: {e}");
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

        void RegisterRecv()
        {
            if (_socket.Connected == false)
                return;

            _recvBuffer.Clean();

            try
            {
                SocketAsyncEventArgs recvArgs = new SocketAsyncEventArgs();
                recvArgs.Completed += OnRecvCompleted;
                recvArgs.SetBuffer(_recvBuffer.WriteSegment);
                bool isPending = _socket.ReceiveAsync(recvArgs);
                if (isPending == false)
                    OnRecvCompleted(null, recvArgs);
            }
            catch (Exception e)
            {
                Console.WriteLine($"registerRecv failed: {e}");
            }
        }

        void OnRecvCompleted(object sender, SocketAsyncEventArgs e)
        {
            if (e.SocketError == SocketError.Success && e.BytesTransferred > 0)
            {
                if (_recvBuffer.OnWrite(e.BytesTransferred) == false)
                {
                    Disconnect();
                    return;
                }

                OnRecv(_recvBuffer.ReadSegment.Array);

                if (_recvBuffer.OnRead(e.BytesTransferred) == false)
                {
                    Disconnect();
                    return;
                }

                RegisterRecv();
            }
            else
                Disconnect();
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
                Console.WriteLine($"Disconnect failed: {e}");
            }
        }
    }
}
