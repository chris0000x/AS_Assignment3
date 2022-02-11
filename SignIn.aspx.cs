using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AS_Assignment3
{
    public partial class SignIn : System.Web.UI.Page
    {
        string SITConnectStore = System.Configuration.ConfigurationManager.ConnectionStrings["SITConnectStore"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_Submit_Click(object sender, EventArgs e)
        {
            //Response.Write("<script>window.alert('before getDBHash.')</script>");         
            string userpass = pass.Text.ToString().Trim();
            string useremail = email.Text.ToString().Trim();

            SHA512Managed hashing = new SHA512Managed();
            string dbHash = getDBHash(useremail);
            string dbSalt = getDBSalt(useremail);
            string dbCounter = getDBCounter(useremail);
            string dbStatus = getDBStatus(useremail);

            if (dbStatus == "true")
            {
                try
                {
                    if (dbSalt != null && dbSalt.Length > 0 && dbHash != null && dbHash.Length > 0)
                    {
                        string pwdWithSalt = userpass + dbSalt;
                        byte[] hashWithSalt = hashing.ComputeHash(Encoding.UTF8.GetBytes(pwdWithSalt));
                        string userHash = Convert.ToBase64String(hashWithSalt);

                        if (userHash.Equals(dbHash) && int.Parse(dbCounter) <= 3)
                        {
                            using (SqlConnection con = new SqlConnection(SITConnectStore))
                            {
                                using (SqlCommand cmd = new SqlCommand("INSERT INTO [UserLog] VALUES(@Email,@LoginAttempt,@LoginCounter,@DateTime)"))
                                {
                                    using (SqlDataAdapter sda = new SqlDataAdapter())
                                    {
                                        cmd.CommandType = CommandType.Text;
                                        cmd.Parameters.AddWithValue("@Email", email.Text.Trim());
                                        cmd.Parameters.AddWithValue("@LoginAttempt", "successful");
                                        cmd.Parameters.AddWithValue("@LoginCounter", 0);
                                        cmd.Parameters.AddWithValue("@DateTime", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
                                        cmd.Connection = con;
                                        con.Open();
                                        cmd.ExecuteNonQuery();
                                        con.Close();
                                    }
                                }
                            }
                            Session["UserEmail"] = useremail;
                            string guid = Guid.NewGuid().ToString();
                            Session["AuthToken"] = guid;
                            Response.Cookies.Add(new HttpCookie("AuthToken", guid));
                            err_success_msg.Text = "Login Successful";
                            err_success_msg.ForeColor = Color.LightGreen;
                            Response.AddHeader("REFRESH", "2;URL=Default.aspx");
                        }
                        else
                        {
                            int newCounter;

                            if(dbCounter == null)
                            {
                                newCounter = 1;
                            }
                            else
                            {
                                newCounter = int.Parse(dbCounter) + 1;
                            }

                            using (SqlConnection con = new SqlConnection(SITConnectStore))
                            {
                                using (SqlCommand cmd = new SqlCommand("INSERT INTO [UserLog] VALUES(@Email,@LoginAttempt,@LoginCounter,@DateTime)"))
                                {
                                    using (SqlDataAdapter sda = new SqlDataAdapter())
                                    {
                                        cmd.CommandType = CommandType.Text;
                                        cmd.Parameters.AddWithValue("@Email", email.Text.Trim());
                                        cmd.Parameters.AddWithValue("@LoginAttempt", "failed");
                                        cmd.Parameters.AddWithValue("@LoginCounter", newCounter.ToString());
                                        cmd.Parameters.AddWithValue("@DateTime", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
                                        cmd.Connection = con;
                                        con.Open();
                                        cmd.ExecuteNonQuery();
                                        con.Close();
                                    }
                                }
                            }

                            if (newCounter == 3)
                            {
                                lockAccount(useremail);
                            }

                            err_success_msg.Text = "Email or Password is not valid. Please try again.";
                            err_success_msg.ForeColor = Color.Red;
                            Response.AddHeader("REFRESH", "2;URL=SignIn.aspx");
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.ToString());
                }

                finally { }
            }
            else
            {
                err_success_msg.Text = "Account is locked, Please contact admin.";
                err_success_msg.ForeColor = Color.Red;
                Response.AddHeader("REFRESH", "2;URL=SignIn.aspx");
            }
      
        }

        protected string getDBSalt(string userid)
        {
            string s = null;

            SqlConnection connection = new SqlConnection(SITConnectStore);
            string sql = "SELECT PasswordSalt FROM [User] WHERE Email=@USERID";
            SqlCommand command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@USERID", userid);

            try
            {
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        if (reader["PasswordSalt"] != null)
                        {
                            if (reader["PasswordSalt"] != DBNull.Value)
                            {
                                s = reader["PasswordSalt"].ToString();
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }

            finally { connection.Close(); }
            return s;
        }

        protected string getDBHash(string userid)
        {

            string h = null;

            SqlConnection connection = new SqlConnection(SITConnectStore);
            string sql = "SELECT PasswordHash FROM [User] WHERE Email=@USERID";
            SqlCommand command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@USERID", userid);

            try
            {
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {

                    while (reader.Read())
                    {
                        if (reader["PasswordHash"] != null)
                        {
                            if (reader["PasswordHash"] != DBNull.Value)
                            {
                                h = reader["PasswordHash"].ToString();
                            }
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }

            finally { connection.Close(); }
            return h;
        }

        protected string getDBCounter(string userid)
        {
            string s = null;

            SqlConnection connection = new SqlConnection(SITConnectStore);
            string sql = "SELECT TOP 1 LoginCounter FROM [UserLog] WHERE Email=@USERID ORDER BY AuditLogID DESC";
            SqlCommand command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@USERID", userid);

            try
            {
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        if (reader["LoginCounter"] != null)
                        {
                            if (reader["LoginCounter"] != DBNull.Value)
                            {
                                s = reader["LoginCounter"].ToString();
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }

            finally { connection.Close(); }
            return s;
        }

        protected string getDBStatus(string userid)
        {
            string s = null;

            SqlConnection connection = new SqlConnection(SITConnectStore);
            string sql = "SELECT AccountStatus FROM [User] WHERE Email=@USERID";
            SqlCommand command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@USERID", userid);

            try
            {
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        if (reader["AccountStatus"] != null)
                        {
                            if (reader["AccountStatus"] != DBNull.Value)
                            {
                                s = reader["AccountStatus"].ToString();
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }

            finally { connection.Close(); }
            return s;
        }

        protected void lockAccount(string userid)
        {
            SqlConnection connection = new SqlConnection(SITConnectStore);
            string sql = "SELECT AccountStatus FROM [User] WHERE Email=@USERID";
            SqlCommand command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@USERID", userid);

            try
            {
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {                        
                        using (SqlConnection con = new SqlConnection(SITConnectStore))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {                                
                                cmd.CommandText = "UPDATE [User] set AccountStatus='false' WHERE Email='"+userid+"'";
                                cmd.Connection = con;
                                con.Open();
                                cmd.ExecuteNonQuery();
                                con.Close();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }

            finally { connection.Close(); }
            return;
        }
    }
}