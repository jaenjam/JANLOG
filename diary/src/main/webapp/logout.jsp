<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(session.getAttribute("loginId")==null){
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}

 	session.invalidate(); //세션리셋
 	response.sendRedirect("./index.jsp");
%>