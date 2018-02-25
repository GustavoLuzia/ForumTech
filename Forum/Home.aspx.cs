using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Forum
{
    public partial class _Default : Page
    {
        HttpCookie cookie;
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnStringDb1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get Cookie
            cookie = Context.Request.Cookies["ForumXYHelper"];

            if (cookie == null)
            {
                btn_newPost.Visible = false;
                div_newPost.Visible = false;                
            }
            else
            {
                LoadCategories();
            }

            CreateContent();
        }

        public void CreateContent()
        {
            string html = "";            

            string queryPosts = @"
                SELECT P.Posts_Title, PC.Posts_Category_Name, U.Users_Name, P.Creation_Date, P.Posts_Id
                FROM POSTS P
                INNER JOIN POSTS_CATEGORY PC ON P.Posts_Category_Id = PC.Posts_Category_Id
                INNER JOIN USERS U ON P.Posts_Owner = U.Users_Id
                WHERE Posts_Status = 1 AND PC.Posts_Category_Status = 1
            ";            

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(queryPosts, connection);

                connection.Open();
                SqlDataReader reader = command.ExecuteReader();

                while(reader.Read())
                {
                    html += "<tr style=\"height: 30px;border-bottom: 1px solid #dbdbdb;background-color: white;\">";
                    html += "   <td style=\"padding-left: 20px; font-weight: bold;\" class=\"hoverLabel\"><label style=\"cursor: pointer;\" onclick=\"loadPost(" + reader["Posts_Id"]+ ")\">" + reader["Posts_Title"] + "</label></td>";
                    html += "   <td style=\"padding-left: 20px;\"><label>" + reader["Posts_Category_Name"] + "</label></td>";
                    html += "   <td style=\"padding-left: 20px;\"><label>" + reader["Users_Name"] + "</label></td>";
                    html += "   <td style=\"text-align: center;\"><label>" + reader["Creation_Date"] + "</label></td>";                    
                    html += "</tr>";
                }
                reader.Close();
            }

            tbody_content.InnerHtml = html;
        }

        public void LoadCategories()
        {
            string queryCategories = @"
                SELECT Posts_Category_Id, Posts_Category_Name FROM POSTS_CATEGORY WHERE Posts_Category_Status = 1 AND Enable_Selection = 1
            ";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(queryCategories, connection);
                connection.Open();

                SqlDataReader readerCategories = command.ExecuteReader();

                while (readerCategories.Read())
                {
                    ListItem category = new ListItem();

                    category.Text = readerCategories["Posts_Category_Name"].ToString();
                    category.Value = readerCategories["Posts_Category_Id"].ToString();

                    ddl_category.Items.Add(category);
                    ddl_category.DataBind();
                }
                readerCategories.Close();
            }
        }

        [WebMethod]
        public static string NewPost(string title, string category, string text)
        {
            var Page = new _Default();

            string message = "Posted!";
            HttpCookie newCookie = Page.Context.Request.Cookies["ForumXYHelper"];

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnStringDb1"].ConnectionString;
            string queryNewPost = @"
                INSERT INTO POSTS(Posts_Owner, Posts_Title, Posts_Description, Posts_Category_Id)
                VALUES(@Owner, @Title, @Description, @Category)
            ";

            if(newCookie != null)
            {
                using(SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand commandNewPost = new SqlCommand(queryNewPost, connection);
                    commandNewPost.Parameters.AddWithValue("@Owner", newCookie.Values["ID"]);
                    commandNewPost.Parameters.AddWithValue("@Title", title);
                    commandNewPost.Parameters.AddWithValue("@Description", text);
                    commandNewPost.Parameters.AddWithValue("@Category", category);

                    connection.Open();
                    commandNewPost.ExecuteNonQuery();
                }
            }

            return message;
        }
    }
}