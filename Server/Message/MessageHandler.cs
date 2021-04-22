﻿using Google.Protobuf;
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
            Console.WriteLine("C_GetToDoListHandler");
        }

        public static void C_AddToDoHandler(ClientSession session, IMessage message)
        {
            C_AddToDo addToDo = message as C_AddToDo;
            Console.WriteLine("C_AddToDoHandler");
        }

        public static void C_EditToDoHandler(ClientSession session, IMessage message)
        {
            C_EditToDo editToDo = message as C_EditToDo;
            Console.WriteLine("C_EditToDoHandler");
        }

        public static void C_DeleteToDoHandler(ClientSession session, IMessage message)
        {
            C_DeleteToDo deleteToDo = message as C_DeleteToDo;
            Console.WriteLine("C_DeleteToDoHandler");
        }
    }
}
