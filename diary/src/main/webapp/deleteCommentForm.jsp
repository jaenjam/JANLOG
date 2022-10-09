<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(session.getAttribute("loginId")==null){
		response.sendRedirect("./index.jsp");
		return;
	}	
%>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="./deleteCommentAction.jsp" method="post">
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
		<input type="hidden" name="commentNo" value="<%=commentNo%>">
		비밀번호 :
		<input type="password" name="commentPw">
		<button type="submit">삭제</button>
	</form>
</body>
</html>