using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace Server
{
    class ToDoRepository
    {
        MySqlConnection _connection;

        public bool RegisterUser(string uid)
        {
            string command = $@"
                START TRANSACTION;
	                INSERT INTO Users(ukey)
	                VALUES ('{uid}');
	                SET @uid=LAST_INSERT_ID();
	                INSERT INTO ToDoLists VALUE (DEFAULT);
	                SET @todoListID=LAST_INSERT_ID();
	                INSERT INTO Users_ToDoLists (Users_id, ToDoLists_id)
	                VALUES (@uid, @todoListID);
                COMMIT;
            ";
            int affectedRowsNumber = 3;
            if (ExecuteCommand(command) == affectedRowsNumber)
                return true;
            return false;
        }

        public int AddToDo(int toDoListID, string content)
        {
            string command = $@"
            INSERT INTO ToDos(ToDoLists_id, content)
            VALUES ({toDoListID}, '{content}');  
            SELECT LAST_INSERT_ID() as id;
            ";
            DataSet dataSet = ExecuteQuery(command);
            UInt64 id = (UInt64)dataSet.Tables[0].Rows[0]["id"];
            return Convert.ToInt32(id);
        }

        public bool UpdateToDo(int id, string content)
        {
            string command = $@"
            UPDATE ToDos
            SET content = '{content}'
            WHERE id = {id};         
            ";
            int affectedRowsNumber = 1;
            if (ExecuteCommand(command) == affectedRowsNumber)
                return true;
            return false;
        }

        public bool DeleteToDo(int id)
        {
            string command = $@"
            DELETE
            FROM ToDos
            WHERE id = {id};  
            ";
            int affectedRowsNumber = 1;
            if (ExecuteCommand(command) == affectedRowsNumber)
                return true;
            return false;
        }

        public List<ToDo> GetToDos(int toDoListID)
        {
            List<ToDo> todos = new List<ToDo>();
            string query = $@"
            SELECT id, content
            FROM ToDos
            WHERE ToDoLists_id = {toDoListID}
            ";
            DataSet dataSet = ExecuteQuery(query);
            foreach (DataRow row in dataSet.Tables[0].Rows)
            {
                todos.Add(new ToDo
                {
                    Id = (int)row["id"],
                    Content = (string)row["content"],
                });
            }
            return todos;
        }

        public int GetToDoListID(string uid)
        {
            string query = $@"
                SELECT ToDoLists_id
                FROM Users_ToDoLists
                WHERE Users_id = (SELECT id
                FROM Users
                WHERE ukey = '{uid}'
                LIMIT 1);
            ";
            DataSet dataSet = ExecuteQuery(query);
            return (int)dataSet.Tables[0].Rows[0]["ToDoLists_id"];
        }

        public bool Exists(string uid)
        {
            string query = $@"
            SELECT EXISTS (
	            SELECT * 
                FROM Users 
                WHERE ukey = '{uid}' 
            ) as isExists;
            ";
            DataSet dataSet = ExecuteQuery(query);
            Int64 exists = 1;
            return (Int64)dataSet.Tables[0].Rows[0]["isExists"] == exists;
        }

        int ExecuteCommand(string command)
        {
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = _connection;
            cmd.CommandText = command;
            return cmd.ExecuteNonQuery();
        }

        DataSet ExecuteQuery(string query)
        {
            DataSet dataSet = new DataSet();
            using (MySqlConnection connection = new MySqlConnection(Private.CONNECTION_STRING))
            {
                MySqlDataAdapter adapter = new MySqlDataAdapter(query, connection);
                adapter.Fill(dataSet);
            }
            return dataSet;
        }

        ToDoRepository()
        {
            _connection = new MySqlConnection(Private.CONNECTION_STRING);
            _connection.Open();
        }

        ~ToDoRepository()
        {
            _connection.Close();
        }

        #region
        static ToDoRepository _instance = new ToDoRepository();
        public static ToDoRepository Instance { get { return _instance; } }
        #endregion
    }
}
