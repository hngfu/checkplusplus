using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
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
            if (Execute(command) == affectedRowsNumber)
                return true;
            return false;
        }

        public bool InsertToDo(int toDoListID, string content)
        {
            string command = $@"
            INSERT INTO ToDos(ToDoLists_id, content)
            VALUES ({toDoListID}, '{content}');           
            ";
            int affectedRowsNumber = 1;
            if (Execute(command) == affectedRowsNumber)
                return true;
            return false;
        }

        public bool UpdateToDo(int id, string content)
        {
            string command = $@"
            UPDATE ToDos
            SET content = '{content}'
            WHERE id = {id};         
            ";
            int affectedRowsNumber = 1;
            if (Execute(command) == affectedRowsNumber)
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
            if (Execute(command) == affectedRowsNumber)
                return true;
            return false;
        }

        public void GetToDos(int userID)
        {
            string query = $@"
            SELECT id, content
            FROM ToDos
            WHERE ToDoLists_id = (SELECT ToDoLists_id
            FROM Users_ToDoLists
            WHERE Users_id = {userID} 
            LIMIT 1); 
            ";
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = _connection;
            cmd.CommandText = query;
            MySqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Console.WriteLine($"{reader["id"]} {reader["content"]}");
            }
        }

        int Execute(string command)
        {
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = _connection;
            cmd.CommandText = command;
            return cmd.ExecuteNonQuery();
        }

        ToDoRepository()
        {
            string connectionString = Private.CONNECTION_STRING;
            _connection = new MySqlConnection(connectionString);
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
