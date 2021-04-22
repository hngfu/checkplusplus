using Google.Protobuf;
using System;
using System.Collections.Generic;
using System.Text;

namespace Server.Message
{
    class MessageHandler
    {
        public static void C_GetToDoListHandler(ClientSession session, IMessage message)
        {
            C_GetToDos getToDoList = message as C_GetToDos;
            string uid = getToDoList.Uid;
            if (ToDoRepository.Instance.Exists(uid) == false)
            {
                ToDoRepository.Instance.RegisterUser(uid);
            }

            int toDoListID = ToDoRepository.Instance.GetToDoListID(uid);
            ToDoList todoList = ToDoListManager.Instance.GetToDoList(toDoListID);
            session.ToDoListID = toDoListID;
            session.ToDoList = todoList;
            todoList.Enter(session);

            List<ToDo> todos = ToDoRepository.Instance.GetToDos(toDoListID);
            if (todos.Count == 0) return;
            S_ToDos s_ToDos = new S_ToDos { Todo = { todos } };
            session.Send(makePacket(MessageID.SToDos, s_ToDos));
        }

        public static void C_AddToDoHandler(ClientSession session, IMessage message)
        {
            C_AddToDo addToDo = message as C_AddToDo;
            int id = ToDoRepository.Instance.AddToDo(session.ToDoListID, addToDo.Content);
            S_AddedToDo s_AddedToDo = new S_AddedToDo { Id = id, Content = addToDo.Content };
            session.ToDoList.BroadCast(makePacket(MessageID.SAddedToDo, s_AddedToDo));
        }

        public static void C_EditToDoHandler(ClientSession session, IMessage message)
        {
            C_EditToDo editToDo = message as C_EditToDo;
            bool isSuccess = ToDoRepository.Instance.UpdateToDo(editToDo.Id, editToDo.Content);
            if (isSuccess)
            {
                S_EditedToDo s_EditedToDo = new S_EditedToDo { Id = editToDo.Id, Content = editToDo.Content };
                session.ToDoList.BroadCast(makePacket(MessageID.SEditedToDo, s_EditedToDo));
            }
        }

        public static void C_DeleteToDoHandler(ClientSession session, IMessage message)
        {
            C_DeleteToDo deleteToDo = message as C_DeleteToDo;
            bool isSuccess = ToDoRepository.Instance.DeleteToDo(deleteToDo.Id);
            if (isSuccess)
            {
                S_DeletedToDo s_DeletedToDo = new S_DeletedToDo { Id = deleteToDo.Id };
                session.ToDoList.BroadCast(makePacket(MessageID.SDeletedToDo, s_DeletedToDo));
            }
        }

        static byte[] makePacket(MessageID messageID, IMessage message)
        {
            int messageIDHeaderSize = 2;
            int messageSize = message.CalculateSize();
            byte[] packet = new byte[messageSize + messageIDHeaderSize];
            Array.Copy(BitConverter.GetBytes((ushort)messageID), 0, packet, 0, 2);
            Array.Copy(message.ToByteArray(), 0, packet, 2, messageSize);
            return packet;
        }
    }
}
