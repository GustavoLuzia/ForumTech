<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Forum._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        function loadPost(id) {
            window.location = "Details.aspx?PostId=" + id;
        }

        function newPost() {
            $("#MainContent_div_newPost").dialog({ width: 500, height: 600 });
        }

        function sendNewPost() {
            var title = $("#MainContent_txt_title").val();
            var category = $("#MainContent_ddl_category").val();
            var text = $("#txt_newPost").html();

            var paramters = {
                title: title,
                category: category,
                text: text
            }

            $.ajax({
                type: "POST",
                url: "Home.aspx/NewPost",
                data: JSON.stringify(paramters),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    alert(data.d);
                    window.location.reload();
                }
            });
        }

        function filterList() {
            $("#MainContent_tbody_content tr :nth-child(1) label").each(function () {
                if ($(this).text().toLowerCase().indexOf($("#txt_filter").val().toLowerCase()) > -1) {
                    $(this).closest('tr').show();
                }
                else {
                    $(this).closest('tr').hide();
                }
            });
        }
    </script>

    <div style="background-image: url(Content/Images/Background.jpg);width: 100%;min-height: 800px;background-repeat-y: repeat;">
        <div style="height: 50px;">
            <br />
            <div style="margin: auto; width: 70%; height: 100%; background-color: #fff;">
                <table style="width: 100%; height: 100%; border-collapse: collapse; border: 1px solid gray;">
                    <tbody>
                        <tr>
                            <td style="padding: 0 20px;background-color: #0c2da7;">
                                <div style="font-size: 20px;display: inline-block;height: 100%;line-height: 50px;color: #fff;">
                                    <asp:Label runat="server" id="lbl_Search" Text="Search"></asp:Label>
                                </div>
                            </td>
                            <td style="width: 100%; height: 100%; line-height: 50px; padding: 0; overflow: hidden;">
                                <input type="text" id="txt_filter" onkeyup="filterList()" placeholder="Title" style="width: 100%; height: Calc(100% - 2px); border: none; padding: 0; margin: 0; margin-left: 20px; outline: none; font-size: 18px;">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div style="width: 70%; margin: auto; padding-top: 50px">
            <div id="div_content" runat="server" style="min-height: 500px; background-color: white;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead style="background-color: #0c2da7; color: #fff; font-size: 20px;">
                        <tr style="height: 35px;">
                            <th><asp:Label runat="server" ID="lbl_Posts_Title" Text="Title"></asp:Label></th>
                            <th><asp:Label runat="server" ID="lbl_Category_Name" Text="Category"></asp:Label></th>
                            <th><asp:Label runat="server" ID="lbl_Owner" Text="Owner"></asp:Label></th>
                            <th><asp:Label runat="server" ID="lbl_Creation_Date" Text="Creation Date"></asp:Label></th>
                        </tr>
                    </thead>
                    <tbody runat="server" id="tbody_content"></tbody>
                </table>
            </div>
            <br />
            <asp:Button runat="server" ID="btn_newPost" style="float: left" Text="New Post" OnClientClick="newPost(); return false;"/>
        </div>
    </div>

    <div runat="server" id="div_newPost" style="display: none;">
        <div><asp:Label runat="server" ID="lbl_titel" Text="Title:"></asp:Label></div>
        <div><asp:TextBox runat="server" ID="txt_title" placeholder="title" MaxLength="100"></asp:TextBox></div>
        <br />
        <div><asp:Label runat="server" ID="lbl_category" Text="Category:"></asp:Label></div>
        <div><asp:DropDownList runat="server" ID="ddl_category" style="width: 200px;"></asp:DropDownList></div>
        <br />
        <div><asp:Label runat="server" ID="lbl_textHere" Text="Text Here:"></asp:Label></div>
        <div id="txt_newPost" contenteditable="true" style="width: 100%; height: 250px; border: 1px solid gray; overflow-y: scroll;"></div>
        <br />
        <input type="button" id="btn_sendNewPost" value="Send" onclick="sendNewPost()"/>
    </div>
</asp:Content>