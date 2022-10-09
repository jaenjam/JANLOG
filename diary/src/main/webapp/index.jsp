<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
a {
    text-decoration: none;
}
a:link {
  color: red;
  disply:block;
  background-color: transparent;
  text-decoration: none;
}
a:visited {
  color: black;
  background-color: transparent;
  text-decoration: none;
}
a:hover {
  color: #87CEFA;
  background-color: transparent;
  text-decoration: underline;
}
a:active {
  color: yellow;
  background-color: transparent;
  text-decoration: underline;
}
</style>
</head>
<body>
<div style="text-align:center; padding: 10px 700px 10px;">
	<%
		if(request.getParameter("errorMsg") != null) {
	%>
		<div><%=request.getParameter("errorMsg")%></div>
	<%		
		}
	%>
	<h1>index</h1>
	<%
		if(session.getAttribute("loginId") == null) { // 로그인 전	
	%>	
			<h2>로그인</h2>
			<form method="post" action="./loginAction.jsp">
				<table border="1" style="margin:auto">
					<tr>
						<td>id</td>
						<td><input type="text" name="id" value="admin" placeholder="아이디를입력해주세요!"></td>
					</tr>
					<tr>
						<td>pw</td>
						<td><input type="password" name="pw" value="1234" placeholder="비밀번호를 입력해주세요!"></td>
					</tr>
				</table>
				<div style="padding-top:20px">
					<button type="submit" class="btn btn-light">로그인</button>
				</div>
			</form>
			<div style="margin-top:20px;"><a href="./insertMember.jsp">회원가입</a></div>
	<%
		} else {
	%>
			<div><h2><%=session.getAttribute("loginId")%>(lv.<%=session.getAttribute("loginLevel")%>)님 반갑습니다</h2></div>
			<div style="padding-bottom: 20px";><button type="button" class="btn btn-light" onclick="location.href='./logout.jsp'">로그아웃</button></div>
	<%		
		}
	%>
		<hr/>
			<div style="padding: 20px 100px 20px;">
				<a href="./1boardList.jsp">게시판</a>
				<a href="./guest.jsp">방명록</a>
				<a href="./diary.jsp">다이어리</a>
			</div>

</div>
</body>
</html>
