using System;
using System.Collections.Generic;
using System.Text;
using Google.Protobuf;
using Server.Message;

namespace Server.Packet
{
    class MessageManager
    {
        Dictionary<ushort, Func<ClientSession, ArraySegment<byte>, IMessage>> _factories = new Dictionary<ushort, Func<ClientSession, ArraySegment<byte>, IMessage>>();
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

        public void OnRecvPacket(ClientSession session, ArraySegment<byte> packet)
        {
            ushort messageID = BitConverter.ToUInt16(packet.Array, packet.Offset);    // MessageID header의 size는 '2'

            Func<ClientSession, ArraySegment<byte>, IMessage> factory = null;
            Action<ClientSession, IMessage> handler = null;
            if (_factories.TryGetValue(messageID, out factory) && _handlers.TryGetValue(messageID, out handler))
            {
                IMessage message = factory.Invoke(session, packet);
                handler.Invoke(session, message);
            }
        }

        Message MakeMessage<Message>(ClientSession session, ArraySegment<byte> packet) where Message : IMessage, new()
        {
            Message message = new Message();
            message.MergeFrom(packet.Array, packet.Offset + 2, packet.Count - 2);
            return message;
        }

        #region
        static MessageManager _packetManager = new MessageManager();
        public static MessageManager Instance { get { return _packetManager; } }
        #endregion
    }
}
