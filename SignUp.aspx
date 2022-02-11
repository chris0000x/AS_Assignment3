<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="AS_Assignment3.SignUp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <link rel="stylesheet" href="fonts/material-icon/css/material-design-iconic-font.min.css">

    <link rel="stylesheet" href="Content/SignUpLogin.css" type="text/css" /> 

    <style>
        #MainContent_dob{
            padding-left: 0;
        }

        .form-group{
            margin-bottom: 0;
        }

        .form-box{
            margin-bottom: 25px;}
            .form-box:last-child {
            margin-bottom: 0px; }

        .signup-form{
            margin-right: 0;
            float: right;
        }

        input{
            max-width: 100%;
        }

        input#MainContent_photo{
            border-bottom: none;
        }
    </style>

    <script type="text/javascript">
        function nameValidate() {
            var fn = document.getElementById('<%=firstname.ClientID %>').value;
            var ln = document.getElementById('<%=lastname.ClientID %>').value;

            if (fn.length > 50) {
                document.getElementById("emlb_fn").innerHTML = "Password Length Must be at Lesser than 50 Characters";
                document.getElementById("emlb_fn").style.color = "Red";
                return ("too_long");
            }

            if (ln.length > 50) {
                document.getElementById("emlb_ln").innerHTML = "Password Length Must be at Lesser than 50 Characters";
                document.getElementById("emlb_ln").style.color = "Red";
                return ("too_long");
            }

            document.getElementById("emlb_fn").innerHTML = " "
            document.getElementById("emlb_ln").innerHTML = " "
        }

        function emailValidate() {
            var str = document.getElementById('<%=email.ClientID %>').value;

            if (str.search(/[0-9]+[a-zA-Z]@mymail\.nyp\.edu\.sg/) == -1) {
                document.getElementById("emlb_email").innerHTML = "Invalid Email";
                document.getElementById("emlb_email").style.color = "Red";
                return ("invalid_email");
            }

            document.getElementById("emlb_email").innerHTML = " "
        }

        function passwordValidate() {
            var str = document.getElementById('<%=pass.ClientID %>').value;
            if (str.length < 12) {
                document.getElementById("emlb_pass").innerHTML = "Password Length Must be at Least 12 Characters";
                document.getElementById("emlb_pass").style.color = "Red";
                return ("too_short");
            }
            // Check at least one Uppercase, lowercase and special characters
            else if (str.search(/[0-9]/) == -1) {
                document.getElementById("emlb_pass").innerHTML = "Password requires at least 1 number";
                document.getElementById("emlb_pass").style.color = "Red";
                return ("no_number");
            }

            else if (str.search(/[a-z]/) == -1) {
                document.getElementById("emlb_pass").innerHTML = "Password requires at least 1 lowercase";
                document.getElementById("emlb_pass").style.color = "Red";
                return ("no_lowercase");
            }

            else if (str.search(/[A-Z]/) == -1) {
                document.getElementById("emlb_pass").innerHTML = "Password requires at least 1 uppercase";
                document.getElementById("emlb_pass").style.color = "Red";
                return ("no_uppercase");
            }

            else if (str.search(/[^A-Za-z0-9]/) == -1) {
                document.getElementById("emlb_pass").innerHTML = "Password requires at least 1 special character";
                document.getElementById("emlb_pass").style.color = "Red";
                return ("no_specialchar");
            }

            document.getElementById("emlb_pass").innerHTML = " "

            //document.getElementById("emlb_pass").innerHTML = "Strong Password!"
            //document.getElementById("emlb_pass").style.color = "Green";
        }

        function repasswordValidate() {
            var str = document.getElementById('<%=repass.ClientID %>').value;
            var pass = document.getElementById('<%=pass.ClientID %>').value;

            //Check if password is the same
            if (str != pass) {
                document.getElementById("emlb_repass").innerHTML = "Password Mismatch";
                document.getElementById("emlb_repass").style.color = "Red";
                return ("pass_mismatch");
            }

            document.getElementById("emlb_repass").innerHTML = " "
        }

        function ccnoValidate() {
            var str = document.getElementById('<%=ccno.ClientID %>').value;

            if (str.search(/^[0-9]{4,4}\s{1,1}[0-9]{4,4}\s{1,1}[0-9]{4,4}\s{1,1}[0-9]{4,4}$/) == -1) {
                document.getElementById("emlb_ccno").innerHTML = "Invalid Credit Card Number";
                document.getElementById("emlb_ccno").style.color = "Red";
                return ("invalid_ccno");
            }

            else if (str.search(/[^A-Za-z]/) == -1) {
                document.getElementById("emlb_pass").innerHTML = "Credit Card Number should not contain character";
                document.getElementById("emlb_pass").style.color = "Red";
                return ("no_char");
            }

            document.getElementById("emlb_ccno").innerHTML = " "
        }

        function addspace() {
            <%--document.getElementById('<%=ccno.ClientID %>').value = document.getElementById('<%=ccno.ClientID %>').value.replace(/[^\dA-Z]/g, '').replace(/(.{4})/g, '$1 ').trim();--%>
            var str = document.getElementById('<%=ccno.ClientID %>').value;

            str = str.replace(/[^\dA-Z]/g, '').replace(/(.{4})/g, '$1 ').trim();
        }

    </script>

    <section class="signup">
        <div class="container-form">
            <div class="signup-content">
                <div class="signup-form">
                    <h2 class="form-title">Sign up</h2>
                    
                    <h5>First Name &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="fnv" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="firstname"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">
                            <%--<label for="firstname"><i class="zmdi zmdi-account material-icons-name"></i></label>
                            <input type="text" name="name" id="firstname" placeholder="First Name" required/>--%>
                            <asp:Label runat="server" AssociatedControlId="firstname"><i class="zmdi zmdi-account material-icons-name"></i></asp:Label>
                            <asp:TextBox ID="firstname" runat="server" placeholder="First Name" onkeyup="javascript:nameValidate()"></asp:TextBox>                        
                        </div>  
                        <h6 id="emlb_fn" />
                    </div>
                    
                    <h5>Last Name &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="lnv" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="lastname"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">
                            <%--<label for="lastname"><i class="zmdi zmdi-account material-icons-name"></i></label>
                            <input type="text" name="name" id="lastname" placeholder="Last Name"/>--%>
                            <asp:Label runat="server" AssociatedControlId="lastname"><i class="zmdi zmdi-account material-icons-name"></i></asp:Label>
                            <asp:TextBox ID="lastname" runat="server" placeholder="Last Name" onkeyup="javascript:nameValidate()"></asp:TextBox> 
                        </div>
                        <h6 id="emlb_ln" />
                    </div>
                    
                    <h5>Date of Birth &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="dobv" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="dob"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">  
                            <%--<input style="padding-left: 0;" type="date" name="dob" id="dob"/> --%>
                            <asp:TextBox ID="dob" runat="server" TextMode="Date"></asp:TextBox>
                        </div>
                        <h6 id="emlb_dob" />
                    </div>   
                    
                    <h5>Email &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="ev" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="email"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">
                            <%--<label for="email"><i class="zmdi zmdi-email"></i></label>
                            <input type="email" name="email" id="email" placeholder="Your Email"/>--%>
                            <asp:Label runat="server" AssociatedControlId="email"><i class="zmdi zmdi-email"></i></asp:Label>
                            <asp:TextBox ID="email" runat="server" placeholder="Your Email" TextMode="Email" onkeyup="javascript:emailValidate()"></asp:TextBox>
                        </div>
                        <h6 id="emlb_email" />
                    </div>   
                    
                    <h5>Password &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="passv" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="pass"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">
                            <%--<label for="pass"><i class="zmdi zmdi-lock"></i></label>
                            <input type="password" name="pass" id="pass" placeholder="Password"/>--%>
                            <asp:Label runat="server" AssociatedControlId="pass"><i class="zmdi zmdi-lock"></i></asp:Label>
                            <asp:TextBox ID="pass" runat="server" placeholder="Password" TextMode="Password" onkeyup="javascript:passwordValidate()"></asp:TextBox>
                        </div>
                        <h6 id="emlb_pass" />
                    </div>
                    
                    <h5>Re-type Password &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="repassv" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="repass"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">
                            <%--<label for="re-pass"><i class="zmdi zmdi-lock-outline"></i></label>
                            <input type="password" name="re_pass" id="re_pass" placeholder="Repeat your password"/>--%>
                            <asp:Label runat="server" AssociatedControlId="repass"><i class="zmdi zmdi-lock-outline"></i></asp:Label>
                            <asp:TextBox ID="repass" runat="server" placeholder="Re-type Password" TextMode="Password" onkeyup="javascript:repasswordValidate()"></asp:TextBox>
                        </div>
                        <h6 id="emlb_repass" />
                    </div>

                    <asp:Label id="Label1" Text=" " runat="server" />                   
                    <asp:Button Text="Check Password" runat="server" onclick="checkPasswordBox_Click" UseSubmitBehavior="false" CausesValidation="false"/> <asp:Label id="lb_pwdchecker" Text=" " runat="server" /><br>

                    <h5>Credit Card Number &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="ccnov" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="ccno"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">
                            <%--<label for="ccno"><i class="zmdi zmdi-card"></i></label>
                            <input type="text" name="ccno" id="creditcardno" placeholder="0000 0000 0000 0000"/>--%>
                            <asp:Label runat="server" AssociatedControlId="ccno"><i class="zmdi zmdi-lock-outline"></i></asp:Label>
                            <asp:TextBox ID="ccno" runat="server" placeholder="0000 0000 0000 0000" MaxLength="19" onkeyup="javascript:ccnoValidate()"></asp:TextBox>
                            <%--<asp:TextBox ID="ccno" runat="server" placeholder="0000 0000 0000 0000" MaxLength="16" onkeyup="javascript:ccnoValidate()"></asp:TextBox>--%>
                        </div>
                        <h6 id="emlb_ccno" />
                    </div>
                    
                    <h5>Photo &nbsp;&nbsp;&nbsp;&nbsp; <asp:RequiredFieldValidator ID="photov" runat="server" ErrorMessage="*Required" ForeColor="Red" ControlToValidate="photo"></asp:RequiredFieldValidator></h5>
                    <div class="form-box">
                        <div class="form-group">
                            <%--<label for="photo"><i class="zmdi zmdi-camera"></i></label>
                            <input type="file" name="photo" id="photo"/>--%>   
                            <asp:Label runat="server" AssociatedControlId="photo"><i class="zmdi zmdi-camera"></i></asp:Label>
                            <asp:FileUpload ID="photo" runat="server" />
                            <asp:HyperLink ID="photoHyper" runat="server">View Uploaded Image</asp:HyperLink>                          
                        </div> 
                        <asp:Label ID="emlb_photo" runat="server" AssociatedControlId="photo" />
                    </div>
                    
                    <div class="form-group form-button">
                        <%--<input type="submit" name="signup" id="signup" class="form-submit" value="Register" onclick="btn_Submit_Click"/>--%>
                        <asp:Button ID="btn_signup" runat="server" Text="Register" onclick="btn_Submit_Click" class="form-submit"/><br />
                        <asp:Label ID="success_msg" runat="server" Text=" " />
                    </div>
                </div>
                <div class="signup-image">
                    <figure><img src="Images/signup-image.jpg" alt="sign up image"></figure>
                    <a href="#" class="signup-image-link">I am already member</a>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
