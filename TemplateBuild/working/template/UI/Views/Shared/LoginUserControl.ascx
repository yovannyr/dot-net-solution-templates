﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LoginUserControl.ascx.cs" Inherits="Web_App.$safeprojectname$.Views.Shared.LoginUserControl" %>
<%
    if (Request.IsAuthenticated) {
%>
        Welcome <b><%= Html.Encode(Page.User.Identity.Name) %></b>!
        [ <%= Html.ActionLink("Logout", "Logout", "Account") %> ]
<%
    }
    else {
%> 
        [ <%= Html.ActionLink("Login", "Login", "Account") %> ]
<%
    }
%>
