<%@ Page Title="" Language="C#" MasterPageFile="~/AwareQIManager.Master" AutoEventWireup="true" CodeBehind="testPage.aspx.cs" Inherits="AwareQIManager.testPage" %>




<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    You have successfuly logged on!<asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    
    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" 
        TargetControlID="ContentPanel" 
        ExpandControlID="TitlePanel" 
        CollapseControlID="TitlePanel" 
        Collapsed="true" 
        TextLabelID="Label1" 
        ExpandedText="(Hide Details)" 
        CollapsedText="(Show Details)" 
        ImageControlID="Image1" 
        CollapsedImage="images/expander.bmp" 
        ExpandedImage="images/collapsed.bmp" 
        SuppressPostBack="true">
    </cc1:CollapsiblePanelExtender>
    <asp:Panel ID="TitlePanel" runat="server" CssClass="collapsePanelHeader">
        <asp:Image ID="Image1" runat="server" ImageUrl="images/expander.bmp" />
        This should not change based on the view state&nbsp;&nbsp;
        <asp:Label ID="Label1" runat="server" Text="Label">(show Details....)</asp:Label>

    </asp:Panel>

    <asp:Panel ID="ContentPanel" runat="server" CssClass="collapsePanel">
        <h1>This is my header inside my content panel</h1>
        <asp:Button ID="Button1" runat="server" Text="Button" />

    </asp:Panel>

</asp:Content>
