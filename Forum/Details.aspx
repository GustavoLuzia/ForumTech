<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="Forum.Details" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        function reply() {
            $("#MainContent_div_reply").dialog({ width: 500, height: 400});
        }

        function sendReply() {
            var text = $("#txt_reply").html();
            var id = $("#MainContent_hdn_post").val();

            var paramters = {
                text: text,
                id: id            
            }

            $.ajax({
                type: "POST",
                url: "Details.aspx/SendReply",
                data: JSON.stringify(paramters),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    alert(data.d);
                    window.location.reload();
                }
            });
        }

        function editPost(idHtml, type, id) {
            $("#MainContent_div_edit").dialog({ width: 500, height: 400 });
            $("#MainContent_hdn_editing").val(id);
            $("#MainContent_hdn_editing_type").val(type);
            $("#txt_edit").html($("#" + idHtml).html());
        }

        function sendEdit(){
            var text = $("#txt_edit").html();
            var id = $("#MainContent_hdn_editing").val();
            var type = $("#MainContent_hdn_editing_type").val();

            var paramters = {
                text: text,
                id: id,
                type: type
            } 

            $.ajax({
                type: "POST",
                url: "Details.aspx/EditPost",
                data: JSON.stringify(paramters),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    alert(data.d);
                    window.location.reload();
                }
            });
        }
    </script>
    <asp:HiddenField runat="server" ID="hdn_post" value="" />
    <asp:HiddenField runat="server" ID="hdn_editing" value="" />
    <asp:HiddenField runat="server" ID="hdn_editing_type" value="" />
    <div style="background-image: url(Content/Images/Background.jpg);width: 100%;height: 800px;">
        <div style="height: 50px;"></div>
        <div style="width: 70%; margin: auto; padding-top: 50px">
            <div id="div_content" runat="server" style="height: 500px; background-color: white; padding: 10px; overflow-y: scroll;">

            </div>
            <br />
            <asp:Button runat="server" ID="btn_reply_down" style="float: left" Text="Reply" OnClientClick="reply(); return false;"/>
        </div>
    </div>

    <div runat="server" id="div_reply" style="display: none;">
        <asp:Label runat="server" ID="lbl_reply" Text="Text Here:"></asp:Label>
        <div id="txt_reply" contenteditable="true" style="width: 100%; height: 250px; border: 1px solid gray; overflow-y: scroll;">
        </div>
        <br />
        <input type="button" id="btn_sendReply" value="Send" onclick="sendReply()"/>
    </div>
    
    <div runat="server" id="div_edit" style="display: none;">
        <asp:Label runat="server" ID="Label1" Text="Text Here:"></asp:Label>
        <div id="txt_edit" contenteditable="true" style="width: 100%; height: 250px; border: 1px solid gray; overflow-y: scroll;">
        </div>
        <br />
        <input type="button" id="btn_sendEdit" value="Send" onclick="sendEdit()"/>
    </div>
</asp:Content>
