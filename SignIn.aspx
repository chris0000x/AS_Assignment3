<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SignIn.aspx.cs" Inherits="AS_Assignment3.SignIn" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href="fonts/material-icon/css/material-design-iconic-font.min.css">

    <link rel="stylesheet" href="Content/SignUpLogin.css" type="text/css" /> 

    <script src="https://www.google.com/recaptcha/api.js?render=6Lcai3AeAAAAABJSYoHs2iexp3va6G36-0m7Hq_h"></script>

    <section class="sign-in">
        <asp:HiddenField ID="USERID" runat="server"/>
        <div class="container">
            <div class="signin-content">
                <div class="signin-image">
                    <figure><img src="images/signin-image.jpg" alt="sing up image"></figure>
                    <a href="#" class="signup-image-link">Create an account</a>
                </div>

                <div class="signin-form">
                    <h2 class="form-title">Sign In</h2>
                        <div class="form-group">
                            <%--<label for="your_name"><i class="zmdi zmdi-account material-icons-name"></i></label>
                            <input type="text" name="your_name" id="your_name" placeholder="Your Name"/>--%>
                            <asp:Label runat="server" AssociatedControlId="email"><i class="zmdi zmdi-email"></i></asp:Label>
                            <asp:TextBox ID="email" runat="server" placeholder="Your Email" TextMode="Email"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <%--<label for="your_pass"><i class="zmdi zmdi-lock"></i></label>
                            <input type="password" name="your_pass" id="your_pass" placeholder="Password"/>--%>
                            <asp:Label runat="server" AssociatedControlId="pass"><i class="zmdi zmdi-lock"></i></asp:Label>
                            <asp:TextBox ID="pass" runat="server" placeholder="Password" TextMode="Password"></asp:TextBox>                         
                        </div>
                        <div class="form-group">
                            <input type="checkbox" name="remember-me" id="remember-me" class="agree-term" />
                            <label for="remember-me" class="label-agree-term"><span><span></span></span>Remember me</label>
                        </div>
                        <div class="form-group form-button">
                            <%--<input type="submit" name="signin" id="signin" class="form-submit" value="Log in"/>--%>
                            <asp:Button ID="btn_signin" runat="server" Text="Log In" onclick="btn_Submit_Click" class="form-submit"/><br />
                            <asp:Label ID="err_success_msg" runat="server" Text=" " />
                        </div>
                        <input type="hidden" id="g-recaptcha-response" name="g-recaptcha-response"/>
                    <div class="social-login">
                        <span class="social-label">Or login with</span>
                        <ul class="socials">
                            <li><a href="#"><i class="display-flex-center zmdi zmdi-facebook"></i></a></li>
                            <li><a href="#"><i class="display-flex-center zmdi zmdi-twitter"></i></a></li>
                            <li><a href="#"><i class="display-flex-center zmdi zmdi-google"></i></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <script>
        grecaptcha.ready(function () {
            grecaptcha.execute('6Lcai3AeAAAAABJSYoHs2iexp3va6G36-0m7Hq_h', { action: 'Login' }).then(function (token) {
                document.getElementById("g-recaptcha-response").value = token;
            });
        });
    </script>

</asp:Content>
