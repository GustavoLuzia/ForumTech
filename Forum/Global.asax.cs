using System;
using System.Web;

namespace Forum
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            if (Request.Url.LocalPath == "/")
            {
                Response.Redirect(Request.Url + "Home.aspx"); 
            }
        }
    }    
}