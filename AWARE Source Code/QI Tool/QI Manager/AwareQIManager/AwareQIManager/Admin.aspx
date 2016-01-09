<%@ Page Title="" Language="C#" MasterPageFile="~/AwareQIManager.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="AwareQIManager.Admin" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server" >
    <asp:Panel ID="PnlGroups" runat="server" Width="100%" BackColor="Bisque" >
        
            <asp:Table ID="Table10" runat="server" Width="100%">
                <asp:TableRow>
                    <asp:TableCell HorizontalAlign="Left" Width="40">
                        <asp:LinkButton ID="LnkBtnRetToDef" runat="server" OnClick="LnkBtnRetToDef_Click">Home</asp:LinkButton>
                    </asp:TableCell>
                    <asp:TableCell HorizontalAlign="Center">
                        <asp:Label ID="Label1" runat="server" Text="QI Tool Administration Tools" Font-Bold="true" Font-Size="X-Large" CssClass="StrongText"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>                
            </asp:Table>
           
    </asp:Panel>
    <br />
    
    <asp:Panel ID="Panel5" runat="server" BackColor="Gray" BorderStyle="Groove" Width="100%">
        <asp:Table ID="Table1" runat="server" CellPadding="10" HorizontalAlign="Center">
            <asp:TableRow>
                <asp:TableCell>
                    <asp:Panel ID="Panel1" runat="server" Width="250px" BackColor="Aquamarine">
                        <div style="margin-left: auto; margin-right: auto; text-align: center;">
                            <asp:Label ID="Label2" runat="server" Text="QI Tool Groups" Font-Bold="true" ></asp:Label>
                        </div>
                        <asp:Table ID="Table2" runat="server">
                            <asp:TableRow>
                                <asp:TableCell>
                                    <asp:ListBox ID="LstQiGrps" runat="server" Width="175px" Height="120px" AutoPostBack="false"></asp:ListBox>
                                </asp:TableCell>
                                <asp:TableCell>
                                    <asp:Button ID="BtnGrpAdd" runat="server" Text="Add" Width="60px" onclick="BtnGrpAdd_Click" /><br /><br />
                                    <asp:Button ID="BtnGrpEdit" runat="server" Text="Edit" Width="60px" onclick="BtnGrpEdit_Click" /><br /><br />
                                    <asp:Button ID="BtnGrpDelete" runat="server" Text="Delete" Width="60px" onclick="BtnGrpDelete_Click" />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <asp:Label ID="Label6" runat="server" Text="*Select a group and click an action" Font-Italic="true" ></asp:Label>                    
                    </asp:Panel>
                </asp:TableCell>

                <asp:TableCell>
                    <asp:Panel ID="Panel2" runat="server" Width="250px" BackColor="Aquamarine">
                        <div style="margin-left: auto; margin-right: auto; text-align: center;">
                            <asp:Label ID="Label3" runat="server" Text="VistA Groups" Font-Bold="true" ></asp:Label>
                        </div>
                        <asp:Table ID="Table3" runat="server">
                            <asp:TableRow>
                                <asp:TableCell>
                                    <asp:ListBox ID="LstVistaGrps" runat="server" Width="175px" Height="120px" AutoPostBack="false"></asp:ListBox>
                                </asp:TableCell>
                                <asp:TableCell>
                                    <asp:Button ID="BtnVistaGrpAdd" runat="server" Text="Add" Width="60px" onclick="BtnVistaGrpAdd_Click" /><br /><br />
                                    <asp:Button ID="BtnVistaGrpEdit" runat="server" Text="Edit" Width="60px" onclick="BtnVistaGrpEdit_Click" /><br /><br />
                                    <asp:Button ID="BtnVistaGrpDel" runat="server" Text="Delete" Width="60px" onclick="BtnVistaGrpDel_Click" />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <asp:Label ID="Label7" runat="server" Text="*Select a group and click an action" Font-Italic="true" ></asp:Label>
                    </asp:Panel>                
                </asp:TableCell>   
            
                <asp:TableCell>
                    <asp:Panel ID="Panel3" runat="server" Width="250px" BackColor="Aquamarine">
                        <div style="margin-left: auto; margin-right: auto; text-align: center;">
                            <asp:Label ID="Label4" runat="server" Text="Users" Font-Bold="true" ></asp:Label>
                        </div>
                        <asp:Table ID="Table4" runat="server">
                            <asp:TableRow>
                                <asp:TableCell>
                                    <asp:ListBox ID="LstUsers" runat="server" Width="175px" Height="120px" AutoPostBack="false"></asp:ListBox>
                                </asp:TableCell>
                                <asp:TableCell>
                                    <asp:Button ID="BtnUsersAdd" runat="server" Text="Add" Width="60px" onclick="BtnUsersAdd_Click" /><br /><br />
                                    <asp:Button ID="BtnUsersEdit" runat="server" Text="Edit" Width="60px" onclick="BtnUsersEdit_Click" /><br /><br />
                                    <asp:Button ID="BtnUsersDel" runat="server"  Text="Delete" Width="60px" onclick="BtnUsersDel_Click" />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>                    
                            <asp:Label ID="Label8" runat="server" Text="*Select a user and click an action" Font-Italic="true" ></asp:Label>                    
                    </asp:Panel>
                </asp:TableCell> 

                <asp:TableCell>
                    <asp:Panel ID="Panel4" runat="server" Width="550px" BackColor="Aquamarine">
                        <div style="margin-left: auto; margin-right: auto; text-align: center;">
                            <asp:Label ID="Label5" runat="server" Text="Reports" Font-Bold="true" ></asp:Label>
                        </div>
                        <asp:Table ID="Table5" runat="server">
                            <asp:TableRow>
                                <asp:TableCell>
                                    <asp:ListBox ID="LstReports" runat="server" Width="475px" Height="120px" AutoPostBack="false"></asp:ListBox>
                                </asp:TableCell>
                                <asp:TableCell>
                                    <asp:Button ID="BtnReportsEdit" runat="server" Text="Edit" Width="60px" onclick="BtnReportsEdit_Click" />                                    
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <asp:Label ID="Label9" runat="server" Text="*Select a report and click an action" Font-Italic="true" ></asp:Label>                    
                    </asp:Panel>
                </asp:TableCell> 
            </asp:TableRow>
        </asp:Table>
    </asp:Panel>
    <br />

    <!-- Aware Group code -->
    <asp:Panel ID="PnlAddEditGroup" runat="server" Width="100%" BackColor="Gray" BorderStyle='Groove' >   
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager> 
        <div id="GrpAddEdit">
        <br />
            <asp:Table ID="Table6" runat="server" HorizontalAlign="Center">
                <asp:TableRow>
                    <asp:TableCell VerticalAlign="Top" >
                        <asp:Label ID="Label10" runat="server" Text="QI Group Name:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell VerticalAlign="Top">
                        <asp:TextBox ID="TbxQiGrpName" runat="server" AutoPostBack= "false"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorQIGroupName" runat="server" ErrorMessage="QI Group Name is Required" ForeColor="Red" 
                                ControlToValidate="TbxQiGrpName"  ValidationGroup="SaveQIGroup"></asp:RequiredFieldValidator>

                    </asp:TableCell>
                    <asp:TableCell Width="75px" />
                    <asp:TableCell VerticalAlign="Top">
                        <asp:Label ID="Label11" runat="server" Text="Active:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell Width="75px" VerticalAlign="Top">
                        <asp:CheckBox ID="CkBxGrpActive" runat="server" AutoPostBack="false" />
                    </asp:TableCell>
                    <asp:TableCell VerticalAlign="Top">
                        <asp:Label ID="Label12" runat="server" Text="Group Members:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="TbxUsers" Text="Select Users" runat="server" CssClass="txtbox" Height="20px" Width="175px" ReadOnly="true"></asp:TextBox>
                        <asp:Panel ID="PnlUsers" runat="server" CssClass="PnlDesign">
                            <asp:CheckBoxList ID="CkBxLstUsers" runat="server" BackColor="White" Width="175px"></asp:CheckBoxList>
                        </asp:Panel>
                    </asp:TableCell>                    
                </asp:TableRow>
                <asp:TableRow />
                <asp:TableRow>
                    <asp:TableCell  VerticalAlign="Top">
                        <asp:Label ID="Label21" runat="server" Text="Available Reports:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell>
                    <!-- insert a list of reports here -->
                     <asp:TextBox ID="TbxReports" Text="Select Reports for this group" runat="server" CssClass="txtbox" Height="20px" Width="200px" ReadOnly="true"></asp:TextBox>
                        <asp:Panel ID="PnlRptsChkList" runat="server" CssClass="PnlDesign">
                            <asp:CheckBoxList ID="CkBxLstReports" runat="server" BackColor="White" Width="175px"></asp:CheckBoxList>
                        </asp:Panel>

                   
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <cc1:PopupControlExtender ID="PceSelectUsers" runat="server" TargetControlID="TbxUsers" PopupControlID="PnlUsers" Position="Bottom"></cc1:PopupControlExtender>
            <cc1:PopupControlExtender ID="PceSelectRpts" runat="server" TargetControlID="TbxReports" PopupControlID="PnlRptsChkList" Position="Bottom"></cc1:PopupControlExtender>
            <br />

            <center>
                <asp:Button ID="BtnGroupApply" runat="server" Text="Apply Changes" onclick="BtnGroupApply_Click" ValidationGroup="SaveQIGroup"/>
            </center>
            
        </div>
    </asp:Panel>

    <asp:Panel ID="PnlDeleteGrp" runat="server" Width="100%" Height="110px" BackColor="Red" BorderStyle='Groove' HorizontalAlign="center" >
        <br />
        <asp:Label ID="LblGrpDeleteMsg" runat="server" Text="Label" Font-Bold="true" Font-Size="Large"></asp:Label>
        <br /><br />
        <asp:Button ID="BtnGrpDelYes" runat="server" Text="Yes" Width="60px" onclick="BtnGrpDelYes_Click" />&nbsp; &nbsp;
        <asp:Button ID="BtnGrpDelNo" runat="server" Text="No" Width="60px" onclick="BtnGrpDelNo_Click" />
        <br />
    </asp:Panel>
    <!-- End Aware Group code -->

    <!-- Vista Group code -->
    <asp:Panel ID="PnlAddEditVistaGroup" runat="server" Width="100%" BackColor="Gray" BorderStyle='Groove' HorizontalAlign="Center" >
    <br />
        <asp:Table ID="Table7" runat="server">
            <asp:TableRow>
                <asp:TableCell HorizontalAlign="Right"><asp:Label ID="Label16" runat="server" Text="Facility:"></asp:Label></asp:TableCell>
                <asp:TableCell 
                HorizontalAlign="Left"><asp:DropDownList ID="DlstVisGrpFac" runat="server" Width="300px"></asp:DropDownList></asp:TableCell>                    
            </asp:TableRow>
            <asp:TableRow Height="10px" />
            <asp:TableRow>
                <asp:TableCell HorizontalAlign="Right"><asp:Label ID="Label13" runat="server" Text="Vista Group Name:"></asp:Label></asp:TableCell>
                <asp:TableCell>
                    <asp:TextBox ID="TbxVisGrp" runat="server" Width="298px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorVistaGroupName" runat="server" ErrorMessage="Vista Group Name is Required" ForeColor="Red" 
                                ControlToValidate="TbxVisGrp"  ValidationGroup="SaveVistaGroup"></asp:RequiredFieldValidator>

                 </asp:TableCell> 
                 <asp:TableCell Width="10px" />                
                 <asp:TableCell HorizontalAlign="Right"><asp:Label ID="Label14" runat="server" Text="Aware Group Name:"></asp:Label></asp:TableCell>
                 <asp:TableCell><asp:DropDownList ID="DlstVisQiGrps" runat="server" Width="300px"></asp:DropDownList>  
                 <asp:RequiredFieldValidator ID="RequiredFieldValidatorVistaQIGroup" runat="server" ErrorMessage="Aware Group Name is Required" ForeColor="Red" 
                                ControlToValidate="DlstVisQiGrps"  ValidationGroup="SaveVistaGroup" InitialValue="...Select a group..."></asp:RequiredFieldValidator>
                </asp:TableCell>
           </asp:TableRow>
            <asp:TableRow Height="10px" />
            <asp:TableRow>
                <asp:TableCell />
                <asp:TableCell HorizontalAlign="Left"> 
                    <asp:CheckBox ID="ChkBxOtherProvVisible" runat="server" Text="Can see other providers alerts." />
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
        <br />
        <asp:Panel ID="Panel6" runat="server" Width="100%" BackColor="Gray" HorizontalAlign="Center">
            <asp:Button ID="VistaGrpApplyChanges" runat="server" Text="Apply Changes" onclick="VistaGrpApplyChanges_Click" ValidationGroup="SaveVistaGroup"/>
            <br />
        </asp:Panel>

    </asp:Panel>
   
   <asp:Panel ID="PnlDeleteVistaGrp" runat="server" Width="100%" Height="110px" BackColor="Red" BorderStyle='Groove' HorizontalAlign="center" >
        <br />
        <asp:Label ID="LblVistaGrpDeleteMsg" runat="server" Text="Label" Font-Bold="true" Font-Size="Large"></asp:Label>
        <br /><br />
        <asp:Button ID="BtnVistaGrpDelYes" runat="server" Text="Yes" Width="60px" onclick="BtnVistaGrpDelYes_Click" />&nbsp; &nbsp;
        <asp:Button ID="BtnVistaGrpDelNo" runat="server" Text="No" Width="60px" onclick="BtnVistaGrpDelNo_Click" />
        <br />
    </asp:Panel>
     <!-- End Vista Group code -->

     <!-- Begin Users code -->
     <asp:Panel ID="PnlUsersDtl" runat="server" Width="100%" BackColor="Gray" BorderStyle='Groove' HorizontalAlign="Center" >
     <br />
        <asp:Table ID="Table8" runat="server">
            <asp:TableRow>
                <asp:TableCell HorizontalAlign="Right"><asp:Label ID="Label15" runat="server" Text="Facility:"></asp:Label></asp:TableCell>
                <asp:TableCell HorizontalAlign="Left"><asp:DropDownList ID="DdlUsersFac" runat="server" Width="300px"></asp:DropDownList></asp:TableCell>    
            </asp:TableRow>
            <asp:TableRow Height="10px" />
            <asp:TableRow>
                <asp:TableCell><asp:Label ID="Label17" runat="server" Text="User Name:"></asp:Label></asp:TableCell>
                <asp:TableCell>
                    <asp:TextBox ID="TbxUserName" runat="server" Width="300px"></asp:TextBox>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidatorUserName" runat="server" ErrorMessage="User Name is Required" ForeColor="Red" 
                                ControlToValidate="TbxUserName"  ValidationGroup="SaveUser"></asp:RequiredFieldValidator>
                </asp:TableCell>                   
            </asp:TableRow>
            <asp:TableRow Height="10px" />            
            <asp:TableRow>
                <asp:TableCell><asp:Label ID="Label20" runat="server" Text="Verify Code:"></asp:Label></asp:TableCell>
                <asp:TableCell>
                    <asp:TextBox ID="TbxVerifyCode" runat="server" Width="300px"></asp:TextBox>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidatorVeryfyCode" runat="server" ErrorMessage="Verify Code is Required" ForeColor="Red" 
                                ControlToValidate="TbxVerifyCode"  ValidationGroup="SaveUser"></asp:RequiredFieldValidator>
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
        <br />
        <asp:Panel ID="Panel8" runat="server" Width="100%" BackColor="Gray" HorizontalAlign="Center">
            <asp:Button ID="BtnUsersApply" runat="server" Text="Apply Changes" onclick="BtnUsersApplyChanges_Click" ValidationGroup="SaveUser" />
            <br />
        </asp:Panel>
    </asp:Panel>

    <asp:Panel ID="PnlUserDel" runat="server" Width="100%" Height="110px" BackColor="Red" BorderStyle='Groove' HorizontalAlign="center" >
        <br />
        <asp:Label ID="LblUsersDel" runat="server" Text="Label" Font-Bold="true" Font-Size="Large"></asp:Label>
        <br /><br />
        <asp:Button ID="Button1" runat="server" Text="Yes" Width="60px" onclick="BtnUserDelYes_Click" />&nbsp; &nbsp;
        <asp:Button ID="Button2" runat="server" Text="No" Width="60px" onclick="BtnUserDelNo_Click" />
        <br />
    </asp:Panel>
     <!-- End users code -->

     <!-- Begin reports code -->
    <asp:Panel ID="PnlReports" runat="server" BackColor="Gray" BorderStyle="Groove" Width="100%" HorizontalAlign="Center">
    <br />
        <asp:Table ID="Table9" runat="server">
            <asp:TableRow>
                <asp:TableCell HorizontalAlign="Right">
                    <asp:Label ID="Label18" runat="server" Text="Report Name:"></asp:Label>
                </asp:TableCell>
                <asp:TableCell>
                    <asp:TextBox ID="TbxReportName" runat="server" ReadOnly = "true" width="400px"></asp:TextBox>
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell  HorizontalAlign="Right">
                    <asp:Label ID="Label19" runat="server" Text="Presentation Name:"></asp:Label>
                </asp:TableCell>
                <asp:TableCell>
                    <asp:TextBox ID="TbxPresName" runat="server" width="400px" MaxLength="100"></asp:TextBox>
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
        <br />   
        <asp:Panel ID="Panel7" runat="server" Width="100%" HorizontalAlign="Center">
            <asp:Button ID="BtnRptsApply" runat="server" Text="Apply Changes" onclick="BtnRptsApply_Click" />
        </asp:Panel>
    </asp:Panel>
     
</asp:Content>
