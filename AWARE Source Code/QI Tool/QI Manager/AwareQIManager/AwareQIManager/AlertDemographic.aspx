<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlertDemographic.aspx.cs" Inherits="AwareQIManager.AlertDemographic" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Demographic</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <asp:Panel ID="Panel3" runat="server" Width= "560" BackColor="#2D3A40">
            <table id="Table2" border="0" cellpadding="0" cellspacing="0" width="560" summary="Table is used for layout purposes" style=" margin-bottom:0px; z-index:1">
                <tbody>
                    <tr>
	                    <td width="560">
                            <img src="Images/inter-header-banner-top.jpg" alt="United States Department of Veterans Affairs Alert Watch and Response Engine" width="560" height="67" style="border:0px"/></td>
	                    
                        
                    </tr>
                <tr>
	                <td colspan="2">
		                <table border="0" cellpadding="0" cellspacing="0" width="560" summary="table is used for layout purposes">
		                    <tbody>
		                        <tr>
			                        <td width="550" id="Td4" style="background-color:#2D3A40"><img src="./Images/inter-header-banner-bottom.jpg" alt="United States Department of Veterans Affairs Alert Watch and Response Engine" width="142" height="27" style="border:0px"/></td>
			                        
		                        </tr>
		                    </tbody>
		                </table>
	                </td>
	        
                </tr>
                </tbody>
            </table>
        </asp:Panel>
    </div>

    <div>
        <asp:Panel ID="Panel1" runat="server" BorderColor="Blue" BorderStyle="Inset" Style="margin: 0 auto; width: 100;">
            <h2 id="DemogrHdr" style="text-align:center">AWARE Alert Demographic Data</h2>            
        </asp:Panel>
        <br />
        <asp:Panel ID="Panel2" runat="server" BorderColor="Blue" BorderStyle="Inset" Style="margin: 0 auto; width: 100;">          
        <br />
        <div style="width: 100; text-align: center;"> 
            <table border="1" cellpadding="4">
            <tr>
                <td align="right"><asp:Label ID="lblDemId" runat="server" Text="Patient ID: " AssociatedControlID="lblDemIdValue" Width="250"></asp:Label>
                </td>
                <td align="left"><asp:Label ID="lblDemIdValue" runat="server" width="150px"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right"><asp:Label ID="lblDemName" runat="server" Text="Patient Name: " AssociatedControlID="lblDemNameValue"></asp:Label>
                </td>
                <td align="left"><asp:Label ID="lblDemNameValue" runat="server" TextMode="Password" width="370px"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right"><asp:Label ID="lblLastAndFour" runat="server" 
                        Text="Patient 1U4N: " AssociatedControlID="lblLastandFourValue" 
                        ToolTip="1st Letter of Last Name + Last 4 of SSN "></asp:Label>
                </td>
                <td align="left"><asp:Label ID="lblLastandFourValue" runat="server" width="370px"></asp:Label>
                </td>
            </tr>

            </table>   
            <table border="0" cellpadding="4">
                <tr>
                    <td>
                        <asp:Button ID="btnClose" runat="server" Text="Close" 
                            onclick="btnClose_Click" />                        
                    </td>
                </tr>
            </table>
        
            <!--<h3 id="PrintInstrHdr" style="text-align:center">Ctrl + P to print.</h3> -->
            </div>
            <br />
        </asp:Panel>
    </div>     
    </form>
</body>
</html>
