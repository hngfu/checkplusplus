using System;
using System.Net;
using System.Net.Sockets;

namespace Server
{
    class Program
    {
        static Listener _listener;

        static void Main(string[] args)
        {
            string hostName = Dns.GetHostName();
            IPHostEntry hostEntry = Dns.GetHostEntry(hostName);
            IPAddress ipAddress = hostEntry.AddressList[0];
            IPEndPoint endPoint = new IPEndPoint(ipAddress, Private.PORT);

            _listener = new Listener(endPoint, () => SessionManager.Instance.Generate());

            Console.WriteLine("Running...");
            while (true)
            {

            }
        }
    }
}