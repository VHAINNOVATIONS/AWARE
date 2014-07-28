<%@ Page Title="" Language="C#" MasterPageFile="AwareQIManager.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AwareQIManager.Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <asp:Panel ID="pnlUserDetails" runat="server" BackColor="#FFFF99" Width="100%">
            <div id="UserLoggedinMessage" style="float:right;>
                <asp:Label ID="lblLoggedOnUser" runat="server" Text="Label" BackColor="#FFFF99"></asp:Label>
            </div>
        </asp:Panel>
    </div>
    
        <asp:Panel ID="pnlReportdefs" runat="server" Width="100%" BackColor="#CCCCCC" BorderColor="#2D3A40">
            <asp:Panel ID="Panel1" runat="server" HorizontalAlign="Center">
                <asp:Label ID="Label1" runat="server" Text="Available Reports: "></asp:Label>
                <asp:DropDownList ID="ddlistReports" runat="server" AutoPostBack="True" 
                    onselectedindexchanged="ddlistReports_SelectedIndexChanged">                    
                </asp:DropDownList>                                
            </asp:Panel>            
        </asp:Panel>        
    
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    <!-- BEGIN report parameter section -->
    <asp:Panel ID="pnlRptParameters" runat="server" Width="100%" BackColor="#CCCCCC">
        <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender2" runat="server"
            TargetControlID="ContentPanel" 
            ExpandControlID="TitlePanel" 
            CollapseControlID="TitlePanel" 
            Collapsed="false" 
            TextLabelID="Label1" 
            ExpandedText="" 
            CollapsedText="" 
            ImageControlID="Image1" 
            CollapsedImage="images/expander.bmp" 
            ExpandedImage="images/collapsed.bmp" 
            SuppressPostBack="False">
        </cc1:CollapsiblePanelExtender>
        <asp:Panel ID="TitlePanel" runat="server" CssClass="collapsePanelHeader">
                <asp:Image ID="Image1" runat="server" ImageUrl="images/expander.bmp" />
                    &nbsp;&nbsp;
                <asp:Label ID="Label2" runat="server" Text="Label">Report Parameters....</asp:Label>
        </asp:Panel>

        <asp:Panel ID="ContentPanel" runat="server" CssClass="collapsePanel"> 
         
         <div id="FacSrv" runat="server">
                <asp:Table ID="tblFacSrv" runat="server">
                    <asp:TableRow>
                        <asp:TableCell>Facility:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlFacilities_5" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell>Service:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlServices_5" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>                        
                    </asp:TableRow>
                </asp:Table>
            </div>

            <div id="FacSrvCl" runat="server">
                <asp:Table ID="Table1" runat="server">
                    <asp:TableRow>
                        <asp:TableCell>Facility:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlFacilities_4" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell>Service:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlServices_4" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell>Clinic:</asp:TableCell> 
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlClinics_4" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlClinics_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </div>

            <div id="Fac" runat="server">
            <asp:Table ID="tblFacility" runat="server">
                    <asp:TableRow>
                        <asp:TableCell>Facility:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlFaclilities_3" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>
                    </asp:Table>
            </div>

            <div id="FacProv" runat="server">
            <asp:Table ID="tblFacProv" runat="server">
                    <asp:TableRow>
                        <asp:TableCell>Facility:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlFacilities_2" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell>Ordering Provider:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlProviders_2" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlProviders_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </div>

            <div ID="FacSrvPrv" runat="server">            
                <asp:Table ID="tblFacSrvPrvStEndDates" runat="server">
                    <asp:TableRow>
                        <asp:TableCell>Facility:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlFacilities_1" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell>Service:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlServices_1" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell>Ordering Provider:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlProviders_1" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlProviders_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </div>
            
            <div ID="FacSrvClnPrvAlt" runat="server">     
                <asp:Table ID="tblFacSrvClnPrvAltStEnDates" runat="server">
                    <asp:TableRow>
                        <asp:TableCell>Facility:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlFacilities" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell>Service:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlServices" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                            </asp:TableCell>
                        <asp:TableCell>Clinic:</asp:TableCell> 
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlClinics" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlClinics_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                    </asp:TableRow>

                    <asp:TableRow>
                        <asp:TableCell>Ordering Provider:</asp:TableCell>
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlProviders" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlProviders_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell ID="AlertTypeLabel">Alert Type:</asp:TableCell> 
                        <asp:TableCell>
                            <asp:DropDownList ID="ddlAlertTypes" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlAlertTypes_SelectedIndexChanged"></asp:DropDownList>
                        </asp:TableCell>
                        <asp:TableCell></asp:TableCell><asp:TableCell></asp:TableCell>
                    </asp:TableRow>  
                </asp:Table>
            </div>
            
            <!-- The calendars for the reports -->
            <div id="CalStartEndDates" runat="server">                                    
                <asp:table id="tblCalStartEndDates" runat="server">
                    <asp:TableRow>
                        <asp:TableCell VerticalAlign="Top">Alert Start Date:</asp:TableCell> 
                        <asp:TableCell>
                            <asp:Calendar ID="calAlertStartDate" runat="server" BackColor="White" 
                                onselectionchanged="calAlertStartDate_SelectionChanged" TodayDayStyle-BackColor="CornflowerBlue" TodayDayStyle-ForeColor="White"></asp:Calendar>
                        </asp:TableCell>
                        <asp:TableCell VerticalAlign="Top">Alert End Date:</asp:TableCell> 
                        <asp:TableCell>
                            <asp:Calendar ID="calAlertEndDate" runat="server" BackColor="White" 
                                onselectionchanged="calAlertEndDate_SelectionChanged" TodayDayStyle-BackColor="CornflowerBlue" TodayDayStyle-ForeColor="White"></asp:Calendar>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </div>

            

            <div style="text-align:center">
                <br />
                <asp:Button ID="btnViewReport" runat="server" Text="View Report" 
                    onclick="btnViewReport_Click" />
                <br />
            </div>

        </asp:Panel>    
    </asp:Panel>     
    <!-- END - report parameter section -->
    <asp:Panel ID="Panel2" runat="server">
    
        
        <rsweb:ReportViewer ID="rptViewerMain" runat="server" Width="100%" 
            Height="100%">
        </rsweb:ReportViewer>
    
    </asp:Panel>
</asp:Content>
