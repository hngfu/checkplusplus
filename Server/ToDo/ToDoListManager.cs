using System;
using System.Collections.Generic;
using System.Text;

namespace Server
{
    class ToDoListManager
    {
        Dictionary<int, ToDoList> _todoLists = new Dictionary<int, ToDoList>();

        public ToDoList GetToDoList(int id)
        {
            lock (_lock)
            {
                ToDoList todoList;
                if (_todoLists.TryGetValue(id, out todoList) == false)
                {
                    todoList = new ToDoList(id);
                    _todoLists.Add(id, todoList);
                }
                return todoList;
            }
        }

        public void Remove(int id)
        {
            lock (_lock)
            {
                _todoLists.Remove(id);
            }
        }

        #region sigleton, lock
        public static ToDoListManager Instance { get { return _instance; } }
        static ToDoListManager _instance = new ToDoListManager();

        object _lock = new object();
        #endregion
    }
}
