<%@ Page Title="" Language="C#" MasterPageFile="~/AwareQIManager.Master" AutoEventWireup="true" CodeBehind="Logon.aspx.cs" Inherits="AwareQIManager.Logon" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <br />
        <asp:Panel ID="Panel1" runat="server" BorderColor="Blue" BorderStyle="Inset" Style="margin: 0 auto; width: 350px;">
            <h2 id="LogonCredHdr" style="text-align:center">Please enter your credentials:</h2> 
            <center>
            <table border="1" cellpadding="4">
            <tr>
                <td align="right"><asp:Label ID="LabelAccessCode" runat="server" Text="Access Code / Username: " AssociatedControlID="tboxUserName" Width="250"></asp:Label>
                </td>
                <td align="left"><asp:TextBox ID="tboxUserName" runat="server" width="150px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right"><asp:Label ID="LabelVerifyCode" runat="server" Text="Verify Code / Password: " AssociatedControlID="tboxPassword"></asp:Label>
                </td>
                <td align="left"><asp:TextBox ID="tboxPassword" runat="server" TextMode="Password" width="150px"></asp:TextBox>
                </td>
            </tr>

            </table>   
            </center>        
            <div align="center">
                 <asp:CheckBox ID="ChkBxRevealText" runat="server" 
                    Text="Show Access Code / User Name characters" AutoPostBack="True" oncheckedchanged="ChkBxRevealText_CheckedChanged" />
                <br /> <br />
                <asp:Button ID="btnLogin" runat="server" Text="Login" onclick="btnLogin_Click" />
            </div>   
            &nbsp;     
        </asp:Panel>
        </div>
    <div style="text-align:center">
        <asp:Label ID="lblLogonStatus" runat="server" Text="Not currently logged on."></asp:Label>
        <br /><br /><asp:Label ID="LabelBuildVersion" runat="server" Text="Build Version: "></asp:Label>
    </div>
</asp:Content>


