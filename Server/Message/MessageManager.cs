using System;
using System.Collections.Generic;
using System.Text;
using Google.Protobuf;
using Server.Message;

namespace Server.Packet
{
    class MessageManager
    {
        Dictionary<ushort, Func<ClientSession, byte[], IMessage>> _factories = new Dictionary<ushort, Func<ClientSession, byte[], IMessage>>();
        Dictionary<ushort, Action<ClientSession, IMessage>> _handlers = new Dictionary<ushort, Action<ClientSession, IMessage>>();

        public MessageManager()
        {
            RegisterHandlers();
            RegisterFactories();
        }

        private void RegisterFactories()
        {
            _factories.Add((ushort)MessageID.GetToDoList, MakeMessage<GetToDoList>);
            _factories.Add((ushort)MessageID.AddToDo, MakeMessage<AddToDo>);
            _factories.Add((ushort)MessageID.EditToDo, MakeMessage<EditToDo>);
            _factories.Add((ushort)MessageID.DeleteToDo, MakeMessage<DeleteToDo>);
        }

        private void RegisterHandlers()
        {
            _handlers.Add((ushort)MessageID.GetToDoList, MessageHandler.GetToDoListHandler);
            _handlers.Add((ushort)MessageID.AddToDo, MessageHandler.AddToDoHandler);
            _handlers.Add((ushort)MessageID.EditToDo, MessageHandler.EditToDoHandler);
            _handlers.Add((ushort)MessageID.DeleteToDo, MessageHandler.DeleteToDoHandler);
        }

        public void OnRecvPacket(ClientSession session, byte[] packet)
        {
            ushort messageID = BitConverter.ToUInt16(packet, 0);    // MessageID header의 size는 '2'

            Func<ClientSession, byte[], IMessage> factory = null;
            Action<ClientSession, IMessage> handler = null;
            if (_factories.TryGetValue(messageID, out factory) && _handlers.TryGetValue(messageID, out handler))
            {
                IMessage message = factory.Invoke(session, new ArraySegment<byte>(packet, 2, packet.Length - 2).Array);
                handler.Invoke(session, message);
            }
        }

        Message MakeMessage<Message>(ClientSession session, byte[] packet) where Message : IMessage, new()
        {
            Message message = new Message();
            message.MergeFrom(packet);
            return message;
        }

        #region
        static MessageManager _packetManager = new MessageManager();
        public static MessageManager Instance { get { return _packetManager; } }
        #endregion
    }
}
