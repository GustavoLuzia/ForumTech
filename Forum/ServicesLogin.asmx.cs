using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

namespace Forum
{
    /// <summary>
    /// Descrição resumida de ServicesLogin
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // Para permitir que esse serviço da web seja chamado a partir do script, usando ASP.NET AJAX, remova os comentários da linha a seguir. 
    [System.Web.Script.Services.ScriptService]
    public class ServicesLogin : System.Web.Services.WebService
    {

        [WebMethod]
        public string ExecLogin(string login, string password)
        {
            SqlDataReader dataUser;
            string messageReturn = "";
            string queryLogin = "SELECT USERS_ID, Users_Name FROM USERS WHERE Users_Login = @Login AND Users_Password = @Password AND Users_Status = 1";
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnStringDb1"].ConnectionString;


            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(queryLogin, connection);
                command.Parameters.AddWithValue("@Login", login);
                command.Parameters.AddWithValue("@Password", password);

                connection.Open();

                dataUser = command.ExecuteReader();
                dataUser.Read();

                if (dataUser.HasRows)
                {
                    //Create Cookie
                    HttpCookie cookie = Context.Request.Cookies["ForumXYHelper"];

                    if (cookie == null)
                    {
                        HttpCookie newCookie = new HttpCookie("ForumXYHelper");
                        newCookie.Values["ID"] = dataUser["USERS_ID"].ToString();
                        newCookie.Values["NAME"] = dataUser["Users_Name"].ToString();
                        newCookie.Expires = DateTime.Now.AddMinutes(30);
                        Context.Request.Cookies.Add(newCookie);
                        Context.Response.Cookies.Add(newCookie);                        
                    }

                    messageReturn = "Welcome " + dataUser["Users_Name"].ToString();
                }
            }
                        
            return messageReturn;
        }

        [WebMethod]
        public void Logout()
        {
            //Delete Cookie
            HttpCookie cookie = Context.Request.Cookies["ForumXYHelper"];
            if (cookie != null)
            {
                cookie.Expires = DateTime.Now.AddDays(-1);
                Context.Request.Cookies.Add(cookie);
                Context.Response.Cookies.Add(cookie);
            }
        }

        [WebMethod]
        public string CreateUser (string name, string login, string password)
        {
            string messageReturn = "";
            string queryVerifyUserLogin = "SELECT * FROM USERS WHERE Users_Login = @Login";
            string queryInsertNewUser = "INSERT INTO USERS (Users_Name, Users_Type_Id, Users_Login, Users_Password) VALUES (@Name, 2, @Login, @Password) SELECT USERS_ID, Users_Name FROM USERS WHERE Users_Id = CAST(@@IDENTITY AS INT)";
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnStringDb1"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand commandUserExists = new SqlCommand(queryVerifyUserLogin, connection);
                commandUserExists.Parameters.AddWithValue("@Login", login);

                connection.Open();

                SqlDataReader readerUserExists = commandUserExists.ExecuteReader();
                readerUserExists.Read();

                if (readerUserExists.HasRows)
                {
                    messageReturn = "Error: User already exists!";
                }
                else
                {
                    connection.Close();
                    SqlCommand commandInsertUser = new SqlCommand(queryInsertNewUser, connection);
                    commandInsertUser.Parameters.AddWithValue("@Name", name);
                    commandInsertUser.Parameters.AddWithValue("@Login", login);
                    commandInsertUser.Parameters.AddWithValue("@Password", password);

                    connection.Open();

                    SqlDataReader readerInsertUser = commandInsertUser.ExecuteReader();
                    readerInsertUser.Read();

                    if (readerInsertUser.HasRows)
                    {
                        //Create Cookie
                        HttpCookie cookie = Context.Request.Cookies["ForumXYHelper"];

                        if (cookie == null)
                        {
                            HttpCookie newCookie = new HttpCookie("ForumXYHelper");
                            newCookie.Values["ID"] = readerInsertUser["USERS_ID"].ToString();
                            newCookie.Values["NAME"] = readerInsertUser["Users_Name"].ToString();
                            newCookie.Expires = DateTime.Now.AddMinutes(30);
                            Context.Request.Cookies.Add(newCookie);
                            Context.Response.Cookies.Add(newCookie);
                        }

                        messageReturn = "Welcome " + readerInsertUser["Users_Name"].ToString();
                    }
                    else
                    {
                        messageReturn = "Error: Contact the Administrator!";
                    }
                }
            }

            return messageReturn;
        }
    }
}
