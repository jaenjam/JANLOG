<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel")<1){
		response.sendRedirect("./index.jsp?errorMsg=Level 0 or higher");
		return;
	}	
%>
<%
	String boardNo = request.getParameter("boardNo");
	System.out.println(boardNo + " <-- boardNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="./deleteBoardAction.jsp" method="post">
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
		비밀번호 :
		<input type="password" name="boardPw">
		<button type="submit">삭제</button>
	</form>
</body>
</html>