<%@ Page Title="" Language="C#" MasterPageFile="~/AwareQIManager.Master" AutoEventWireup="true" CodeBehind="AwareError.aspx.cs" Inherits="AwareQIManager.AwareError" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="Panel1" runat="server" BackColor="Yellow" Width="80%" HorizontalAlign="Center">
        <asp:Label ID="Label1" runat="server" Text="Aware QI Manager has experienced an error.  Details of the error are  below:" Font-Bold="true" Font-Size="Large"></asp:Label>
        <asp:Panel ID="PnlError" runat="server" Width="80%" BackColor="White" HorizontalAlign="Center">
            <asp:Table runat="server" BorderStyle="Groove" Width="100%"  HorizontalAlign="Center">
                <asp:TableRow runat="server">
                    <asp:TableCell runat="server">Error Message:</asp:TableCell>
                    <asp:TableCell runat= "server" ID="ErrorMsg"></asp:TableCell>
                </asp:TableRow>
                <asp:TableRow runat="server">
                    <asp:TableCell runat="server">Inner Exception:</asp:TableCell>
                    <asp:TableCell runat= "server" ID="InnerException"></asp:TableCell>
                </asp:TableRow>
            </asp:Table>            
        </asp:Panel>
    </asp:Panel>
</asp:Content>
