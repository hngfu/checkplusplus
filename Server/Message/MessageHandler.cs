using Google.Protobuf;
using System;
using System.Collections.Generic;
using System.Text;

namespace Server.Message
{
    class MessageHandler
    {
        public static void GetToDoListHandler(ClientSession session, IMessage message)
        {
            GetToDoList getToDoList = message as GetToDoList;
            
        }

        public static void AddToDoHandler(ClientSession session, IMessage message)
        {
            AddToDo addToDo = message as AddToDo;
        }

        public static void EditToDoHandler(ClientSession session, IMessage message)
        {
            EditToDo editToDo = message as EditToDo;
        }

        public static void DeleteToDoHandler(ClientSession session, IMessage message)
        {
            DeleteToDo deleteToDo = message as DeleteToDo;
        }
    }
}
