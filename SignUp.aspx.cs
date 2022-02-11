using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AS_Assignment3
{
    public partial class SignUp : System.Web.UI.Page
    {
        string SITConnectStore = System.Configuration.ConfigurationManager.ConnectionStrings["SITConnectStore"].ConnectionString;
        static string finalHash;
        static string salt;
        byte[] Key;
        byte[] IV;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                photoHyper.Visible = false;
            }
        }

        protected int checkPassword(string password)
        {
            int score = 0;

            if (password.Length < 8)
            {
                return 1;
            }
            else
            {
                score = 1;
            }

            if (Regex.IsMatch(password, "[a-z]"))
            {
                score++;
            }

            if (Regex.IsMatch(password, "[A-Z]"))
            {
                score++;
            }

            if (Regex.IsMatch(password, "[0-9]"))
            {
                score++;
            }

            if (Regex.IsMatch(password, "[$&+,:;=?@#|'<>.^*()%!-]"))
            {
                score++;
            }

            return score;
        }

        protected void checkPasswordBox_Click(object sender, EventArgs e)
        {
            int scores = checkPassword(pass.Text);
            string status = "";

            switch (scores)
            {
                case 1:
                    status = "Very Weak";
                    break;
                case 2:
                    status = "Weak";
                    break;
                case 3:
                    status = "Medium";
                    break;
                case 4:
                    status = "Strong";
                    break;
                case 5:
                    status = "Excellent";
                    break;
                default:
                    break;
            }

            lb_pwdchecker.Text = "Status : " + status;
            if (scores < 4)
            {
                lb_pwdchecker.ForeColor = Color.Red;
                return;
            }
            lb_pwdchecker.ForeColor = Color.Green;
            return;
        }

        protected void btn_Submit_Click(object sender, EventArgs e)
        {
            string pwd = pass.Text.ToString().Trim();

            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            byte[] saltByte = new byte[8];
            
            //Fills array of bytes with a cryptographically strong sequence of random values.
            rng.GetBytes(saltByte);salt = Convert.ToBase64String(saltByte); 

            SHA512Managed hashing = new SHA512Managed();

            string pwdWithSalt = pwd + salt;
            byte[] plainHash = hashing.ComputeHash(Encoding.UTF8.GetBytes(pwd));
            byte[] hashWithSalt = hashing.ComputeHash(Encoding.UTF8.GetBytes(pwdWithSalt));
            
            finalHash = Convert.ToBase64String(hashWithSalt);

            RijndaelManaged cipher = new RijndaelManaged();
            cipher.GenerateKey();
            Key = cipher.Key;
            IV = cipher.IV;

            HttpPostedFile postedFile = photo.PostedFile;
            string fileName = Path.GetFileName(postedFile.FileName);
            string fileExtension = Path.GetExtension(fileName);
           
            if (fileExtension.ToLower() == ".jpg" || fileExtension.ToLower() == ".bmp"
                || fileExtension.ToLower() == ".png" || fileExtension.ToLower() == ".gif")
            {
                Stream stream = postedFile.InputStream;
                BinaryReader binaryReader = new BinaryReader(stream);
                byte[] bytes = binaryReader.ReadBytes((int)stream.Length);

            }
            else
            {
                emlb_photo.Visible = true;
                emlb_photo.Text = "ONLY IMAGES (.JPG, .PNG, .GIF AND .BMP) CAN BE UPLOADED";
                emlb_photo.ForeColor = Color.Red;
                photoHyper.Visible = false;
            }

            createAccount();

            success_msg.Text = "Account Successfully Created!";
            success_msg.ForeColor = Color.LightGreen;
            Response.AddHeader("REFRESH", "5;URL=SignIn.aspx");
        }

        protected void createAccount()
        {
            HttpPostedFile postedFile = photo.PostedFile;
           
            try
            {
                using (SqlConnection con = new SqlConnection(SITConnectStore))
                {
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO [User] VALUES(@FirstName,@LastName,@DoB,@Email,@PasswordHash,@PasswordSalt,@IV,@Key,@CreditCardNo,@Photo,@AccountStatus,@AccountType)"))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter())
                        {
                            cmd.CommandType = CommandType.Text;
                            cmd.Parameters.AddWithValue("@FirstName", firstname.Text.Trim());
                            cmd.Parameters.AddWithValue("@LastName", lastname.Text.Trim());
                            cmd.Parameters.AddWithValue("@DoB", dob.Text.Trim());
                            cmd.Parameters.AddWithValue("@Email", email.Text.Trim());
                            cmd.Parameters.AddWithValue("@PasswordHash", finalHash);
                            cmd.Parameters.AddWithValue("@PasswordSalt", salt);
                            cmd.Parameters.AddWithValue("@IV", Convert.ToBase64String(IV));
                            cmd.Parameters.AddWithValue("@Key", Convert.ToBase64String(IV));
                            cmd.Parameters.AddWithValue("@CreditCardNo", Convert.ToBase64String(encryptData(ccno.Text.Trim())));
                            cmd.Parameters.AddWithValue("@Photo", Path.GetFileName(postedFile.FileName));
                            cmd.Parameters.AddWithValue("@AccountStatus", "true");
                            cmd.Parameters.AddWithValue("@AccountType", "student");
                            cmd.Connection = con; 
                            con.Open(); 
                            cmd.ExecuteNonQuery(); 
                            con.Close();
                            
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        protected byte[] encryptData(string data)
        {
            byte[] cipherText = null;
            try
            {
                RijndaelManaged cipher = new RijndaelManaged();
                cipher.IV = IV;
                cipher.Key = Key;
                ICryptoTransform encryptTransform = cipher.CreateEncryptor();
                //ICryptoTransform decryptTransform = cipher.CreateDecryptor();
                byte[] plainText = Encoding.UTF8.GetBytes(data);
                cipherText = encryptTransform.TransformFinalBlock(plainText, 0, plainText.Length);

            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }

            finally { }
            return cipherText;
        }
    }
}