<%@ Page Title="" Language="C#" MasterPageFile="AwareQIManager.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AwareQIManager.Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="UserDetails">
        <asp:Panel ID="pnlUserDetails" runat="server" BackColor="#FFFF99" Width="100%">
           <div id="UserLoggedinMessage" style="float:right;">                           
            <asp:Table ID="TblLogout" runat="server" Width="100%">
                <asp:TableRow runat="server">
                    <asp:TableCell HorizontalAlign="Left">
                        <asp:LinkButton ID="LkBtnAdminTools" runat="server" OnClick="LnkBtnAdminTools_Click">Tools</asp:LinkButton>                        
                    </asp:TableCell>                    
                    <asp:TableCell HorizontalAlign="Right">
                        <asp:Label ID="lblLoggedOnUser" runat="server" Text="Label" BackColor="#FFFF99"></asp:Label>&nbsp;
                        <asp:LinkButton ID="LnkBtnLogout" runat="server" Width="60px" onclick="LnkBtnLogout_Click">Logout</asp:LinkButton>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
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
                        <asp:TableCell Width="120"  HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelFacility5" runat="server" Text="Facility:" AssociatedControlID="ddlFacilities_5"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300">
                            <asp:DropDownList ID="ddlFacilities_5" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFacility5" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlFacilities_5"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelService5" runat="server" Text="Service:" AssociatedControlID="ddlServices_5"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" HorizontalAlign="Left">
                            <asp:DropDownList ID="ddlServices_5" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorService5" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlServices_5"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>                        
                    </asp:TableRow>
                </asp:Table>
            </div>

            <div id="FacSrvCl" runat="server">
                <asp:Table ID="Table1" runat="server">
                    <asp:TableRow>
                        <asp:TableCell Width="120"  HorizontalAlign="Right" VerticalAlign="Top"><asp:Label ID="LabelFacility4" runat="server" Text="Facility:" AssociatedControlID="ddlFacilities_4"></asp:Label></asp:TableCell>
                        <asp:TableCell Width="300">
                            <asp:DropDownList ID="ddlFacilities_4" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlFacilities_4"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelService4" runat="server" Text="Service:" AssociatedControlID="ddlServices_4"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" HorizontalAlign="Left">
                            <asp:DropDownList ID="ddlServices_4" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorService4" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlServices_4"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="80" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelClinic4" runat="server" Text="Clinic:" AssociatedControlID="ddlClinics_4"></asp:Label>
                        </asp:TableCell> 
                        <asp:TableCell Width="300" HorizontalAlign="Left">
                            <asp:DropDownList ID="ddlClinics_4" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlClinics_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorClinic4" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlClinics_4"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </div>

            <div id="Fac" runat="server">
            <asp:Table ID="tblFacility" runat="server">
                    <asp:TableRow>
                        <asp:TableCell  Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelFacility3" runat="server" Text="Facility:" AssociatedControlID="ddlFaclilities_3"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlFaclilities_3" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFacility3" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlFaclilities_3"></asp:RequiredFieldValidator>
                        </asp:TableCell>
                    </asp:TableRow>
                    </asp:Table>
            </div>

            <div id="FacProv" runat="server">
            <asp:Table ID="tblFacProv" runat="server">
                    <asp:TableRow>
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelFacility2" runat="server" Text="Facility:" AssociatedControlID="ddlFacilities_2"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300">
                            <asp:DropDownList ID="ddlFacilities_2" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFacility2" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlFacilities_2" InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                         <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelProvider2" runat="server" Text="Ordering Provider:" AssociatedControlID="ddlProviders_2"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" HorizontalAlign="Left">
                            <asp:DropDownList ID="ddlProviders_2" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlProviders_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorProvider2" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlProviders_2"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </div>

            <div ID="FacSrvPrv" runat="server">            
                <asp:Table ID="tblFacSrvPrvStEndDates" runat="server">
                    <asp:TableRow>
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelFacility1" runat="server" Text="Facility:" AssociatedControlID="ddlFacilities_1"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlFacilities_1" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFacility1" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlFacilities_1"></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelService1" runat="server" Text="Service:" AssociatedControlID="ddlServices_1"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" HorizontalAlign="Left" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlServices_1" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorService1" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlServices_1"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelProvider1" runat="server" Text="Ordering Provider:" AssociatedControlID="ddlProviders_1"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" HorizontalAlign="Left" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlProviders_1" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlProviders_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorProvider1" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlProviders_1"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </div>
            
            <div ID="FacSrvClnPrvAlt" runat="server">     
                <asp:Table ID="tblFacSrvClnPrvAltStEnDates" runat="server">
                    <asp:TableRow>
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelFacility" runat="server" Text="Facility:" AssociatedControlID="ddlFacilities"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlFacilities" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlFacilities_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFacility" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlFacilities" InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelService" runat="server" Text="Service:" AssociatedControlID="ddlServices"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell Width="300" HorizontalAlign="Left" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlServices" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlServices_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorService" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlServices"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="80" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelClinic" runat="server" Text="Clinic:" AssociatedControlID="ddlClinics"></asp:Label>
                        </asp:TableCell> 
                        <asp:TableCell Width="300" HorizontalAlign="Left" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlClinics" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlClinics_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorClinic" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlClinics"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                    </asp:TableRow>

                    <asp:TableRow>
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="LabelProvider" runat="server" Text="Ordering Provider:" AssociatedControlID="ddlProviders"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell  Width="300" HorizontalAlign="Left" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlProviders" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlProviders_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorProvider" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlProviders"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">
                            <asp:Label ID="AlertTypeLabel" runat="server" Text="Alert Type:" AssociatedControlID="ddlAlertTypes"></asp:Label>
                        </asp:TableCell>
                        <asp:TableCell  Width="300" HorizontalAlign="Left" VerticalAlign="Top">
                            <asp:DropDownList ID="ddlAlertTypes" runat="server" AutoPostBack="True" width="300px" 
                                onselectedindexchanged="ddlAlertTypes_SelectedIndexChanged"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAlertType" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="ddlAlertTypes"  InitialValue="...Select a Value..."></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell>&nbsp;</asp:TableCell><asp:TableCell>&nbsp;</asp:TableCell>
                    </asp:TableRow>  
                </asp:Table>
            </div>
            
            <!-- The calendars for the reports -->
            <div id="CalStartEndDates" runat="server">  
            <cc1:CalendarExtender ID="CalendarExtenderStart" runat="server" TargetControlID="TbalertStartDate" Format="MM/dd/yyyy" PopupButtonID="imgCalender" PopupPosition="Right"></cc1:CalendarExtender>  
            <cc1:CalendarExtender ID="CalendarExtenderEnd" runat="server" TargetControlID="TbalertEndDate" Format="MM/dd/yyyy" PopupButtonID="imgCalender2" PopupPosition="Right"></cc1:CalendarExtender>                                 
                <asp:Table id="tblCalStartEndDates" runat="server">
                    <asp:TableRow>
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">Alert Start Date:</asp:TableCell>
                        <asp:TableCell Width="355" VerticalAlign="Top">
                            <asp:TextBox ID="TbAlertStartDate" runat="server" Width="100" AutoPostBack="false"></asp:TextBox>                            
                            <asp:Image ID="imgCalender" runat="server" ImageUrl="images/calendar.bmp" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorStartDate" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="TbAlertStartDate" ></asp:RequiredFieldValidator>
                        </asp:TableCell>
                        <asp:TableCell Width="20" />
                        <asp:TableCell Width="120" HorizontalAlign="Right" VerticalAlign="Top">Alert End Date:</asp:TableCell>
                        <asp:TableCell VerticalAlign="Top">
                            <asp:TextBox ID="TbAlertEndDate" runat="server" Width="100" AutoPostBack="false"></asp:TextBox>
                            <asp:Image ID="imgCalender2" runat="server" ImageUrl="images/calendar.bmp" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorEndDate" runat="server" ErrorMessage="Required" ForeColor="Red" 
                                ControlToValidate="TbAlertEndDate" ></asp:RequiredFieldValidator>
                        </asp:TableCell>
                    </asp:TableRow>                    
                </asp:Table>
            </div>

            <div style="text-align:center">
                <br />
                <asp:Button ID="btnViewReport" runat="server" Text="View Report" 
                    onclick="btnViewReport_Click" />
                
            </div>
            <br />
        </asp:Panel>    
    </asp:Panel>     
    <!-- END - report parameter section -->
    <asp:Panel ID="Panel2" runat="server" Width="100%">
    
        
        <rsweb:ReportViewer ID="rptViewerMain" runat="server" Width="100%" 
            Height="100%">
        </rsweb:ReportViewer>
    
    </asp:Panel>
</asp:Content>
