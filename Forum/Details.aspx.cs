using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

namespace Forum
{
    public partial class Details : System.Web.UI.Page
    {
        HttpCookie cookie;
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnStringDb1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get Cookie
            cookie = Context.Request.Cookies["ForumXYHelper"];            

            string postId = Request.QueryString["PostId"];

            if (!string.IsNullOrEmpty(postId))
            {
                LoadContent(postId);
                hdn_post.Value = postId;
            }
            else
            {
                LoadBlankPage();
            }            
        }

        public void LoadContent(string postId)
        {
            //Get main content
            string queryGetMainContent = @"
                SELECT P.Posts_Owner, P.Posts_Title, P.Posts_Description, P.Creation_Date, U.Users_Name, PC.Posts_Category_Name, PC.Enable_Reply
                FROM POSTS P
                INNER JOIN USERS U ON P.Posts_Owner = U.Users_Id
                INNER JOIN POSTS_CATEGORY PC ON P.Posts_Category_Id = PC.Posts_Category_Id
                WHERE P.Posts_Id = @Id AND P.Posts_Status = 1 AND PC.Posts_Category_Status = 1
            ";

            using(SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand commandMainContent = new SqlCommand(queryGetMainContent, connection);
                commandMainContent.Parameters.AddWithValue("@Id", postId);

                connection.Open();

                SqlDataReader readerMainContent = commandMainContent.ExecuteReader();
                readerMainContent.Read();

                if (readerMainContent.HasRows)
                {
                    if (cookie == null || readerMainContent["Enable_Reply"].ToString() == "0")
                    {
                        btn_reply_down.Visible = false;
                        div_reply.Visible = false;
                    }

                    string htmlMain = "";
                    htmlMain += "<div>";
                    htmlMain += "   <label style=\"font-size: 18px; font-weight: bold; text-decoration: underline;\">" + readerMainContent["Posts_Title"] + "</label>";

                    if (cookie != null && cookie.Values["ID"] == readerMainContent["Posts_Owner"].ToString())
                    {
                        htmlMain += "   <input type=\"button\" id=\"btn_edit_main\" onclick=\"editPost('div_main_content', 1, " + postId + ")\" value=\"Edit\" style=\"float: right;\">";
                    }

                    htmlMain += "</div>";
                    htmlMain += "<div><label>" + readerMainContent["Users_Name"] + " - " + readerMainContent["Creation_Date"].ToString() + "</label></div>";
                    htmlMain += "<br />";
                    htmlMain += "<div id=\"div_main_content\" style=\"padding-left: 20px;\">" + readerMainContent["Posts_Description"] + "</div>";
                    htmlMain += "<hr>";

                    div_content.InnerHtml = htmlMain;
                    LoadReply(postId);
                    readerMainContent.Close();
                }
                else
                {
                    LoadBlankPage();
                    btn_reply_down.Visible = false;
                    div_reply.Visible = false;
                }
            }            
        }

        public void LoadReply(string postId)
        {
            string queryReply = @"
                SELECT PCO.Posts_Comments_Id, PCO.Posts_Description, PCO.Creation_Date, U.Users_Name, PCO.Posts_Comments_User
                FROM POSTS_COMMENTS PCO
                INNER JOIN USERS U ON PCO.Posts_Comments_User = U.Users_Id
                WHERE PCO.Posts_Id = @Id AND PCO.Posts_Comments_Status = 1
            ";

            using(SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand commandReply = new SqlCommand(queryReply, connection);
                commandReply.Parameters.AddWithValue("@Id", postId);
                connection.Open();

                SqlDataReader readerReply = commandReply.ExecuteReader();

                while (readerReply.Read())
                {
                    string htmlReply = "";
                    htmlReply += "<div>";
                    htmlReply += "  <label> " + readerReply["Users_Name"] + " - " + readerReply["Creation_Date"].ToString() + "</label>";

                    if (cookie != null && cookie.Values["ID"] == readerReply["Posts_Comments_User"].ToString())
                    {
                        htmlReply += "   <input type=\"button\" id=\"btn_edit_main\" onclick=\"editPost('div_reply_content_" + readerReply["Posts_Comments_Id"] + "', 2, " + readerReply["Posts_Comments_Id"] + ")\" value=\"Edit\" style=\"float: right;\">";
                    }

                    htmlReply += "</div>";                    
                    htmlReply += "<br />";
                    htmlReply += "<div id=\"div_reply_content_" + readerReply["Posts_Comments_Id"] + "\" style=\"padding-left: 20px;\">" + readerReply["Posts_Description"] + "</div>";
                    htmlReply += "<hr>";

                    div_content.InnerHtml = div_content.InnerHtml + htmlReply;
                }
                readerReply.Close();
            }
        }

        public void LoadBlankPage()
        {
            string html = "<div style=\"font-size:20px; font-weight:bold; font-color: red; text-align: center;\"><label>Oops.. Post not found!</label></div>";
            div_content.InnerHtml = html;
        }

        [WebMethod]
        public static string EditPost(string text, string id, string type)
        {
            var Page = new Details();

            string message = "Edited!";
            HttpCookie newCookie = Page.Context.Request.Cookies["ForumXYHelper"];

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnStringDb1"].ConnectionString;
            string queryEditPost = "";

            if(type == "1")
            {
                queryEditPost = @"
                    UPDATE POSTS
                    SET Posts_Description = @Description
                    WHERE Posts_Owner = @Owner AND Posts_Id = @Id
                ";
            }
            else
            {
                queryEditPost = @"
                    UPDATE POSTS_COMMENTS
                    SET Posts_Description = @Description
                    WHERE Posts_Comments_User = @Owner AND Posts_Comments_Id = @Id
                ";
            }

            if(newCookie != null)
            {
                using(SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(queryEditPost, connection);
                    command.Parameters.AddWithValue("@Description", text);
                    command.Parameters.AddWithValue("@Owner", newCookie.Values["ID"]);
                    command.Parameters.AddWithValue("@Id", id);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }

            return message;
        }

        [WebMethod]
        public static string SendReply(string text, string id)
        {
            var Page = new Details();

            string message = "Posted!";
            HttpCookie newCookie = Page.Context.Request.Cookies["ForumXYHelper"];

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnStringDb1"].ConnectionString;
            string queryEditPost = @"
                IF((SELECT Enable_Reply FROM POSTS_CATEGORY WHERE Posts_Category_Id = (SELECT Posts_Category_Id FROM POSTS WHERE Posts_Id = @Id)) = 1)
                BEGIN
	                INSERT INTO POSTS_COMMENTS(Posts_Description, Posts_Comments_User, Posts_Id)
	                VALUES (@Description, @User, @Id)
                END
            ";

            if (newCookie != null)
            {
                using(SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(queryEditPost, connection);
                    command.Parameters.AddWithValue("@Description", text);
                    command.Parameters.AddWithValue("@User", newCookie.Values["ID"]);
                    command.Parameters.AddWithValue("@Id", id);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }

            return message;
        }
    }
}