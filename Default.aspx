<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AS_Assignment3._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h3><asp:Label ID="welcome" runat="server" /></h3>
    </div>

    <asp:Button ID="btn_Logout" runat="server" Text="Logout" onclick="btn_Logout_Click" class="form-submit"/>

</asp:Content>
