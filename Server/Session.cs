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

        public abstract void OnRecv(byte[] data);

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
                sendArgs.SetBuffer(data, 0, data.Length);
                _socket.SendAsync(sendArgs);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Send failed: {e}");
            }
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
                Console.WriteLine($"RegisterRecv failed: {e}");
            }
        }

        void OnRecvCompleted(object sender, SocketAsyncEventArgs e)
        {
            if (e.SocketError == SocketError.Success && e.BytesTransferred > 0)
            {
                OnRecv(_recvBuffer.ReadSegment.Array);

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
            }
            catch (Exception e)
            {
                Console.WriteLine($"Disconnect failed: {e}");
            }
        }
    }
}
