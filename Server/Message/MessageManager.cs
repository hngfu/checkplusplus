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
            _factories.Add((ushort)MessageID.CGetToDoList, MakeMessage<C_GetToDos>);
            _factories.Add((ushort)MessageID.CAddToDo, MakeMessage<C_AddToDo>);
            _factories.Add((ushort)MessageID.CEditToDo, MakeMessage<C_EditToDo>);
            _factories.Add((ushort)MessageID.CDeleteToDo, MakeMessage<C_DeleteToDo>);
        }

        private void RegisterHandlers()
        {
            _handlers.Add((ushort)MessageID.CGetToDoList, MessageHandler.C_GetToDoListHandler);
            _handlers.Add((ushort)MessageID.CAddToDo, MessageHandler.C_AddToDoHandler);
            _handlers.Add((ushort)MessageID.CEditToDo, MessageHandler.C_EditToDoHandler);
            _handlers.Add((ushort)MessageID.CDeleteToDo, MessageHandler.C_DeleteToDoHandler);
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
