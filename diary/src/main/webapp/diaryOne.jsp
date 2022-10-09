<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}

	request.setCharacterEncoding("utf-8");
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	/*
	?y=2022&m=6&d=1
	
	insert into diary (diary_date, diary_todo, create_date)values (?,?,now());
	
	*/
	
	// 메뉴 목록
	String sql = "SELECT diary_date diaryDate, diary_todo diaryTodo FROM diary";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	String Dsql = "SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo, create_date createDate FROM diary where diary_no = ?";
	PreparedStatement Dstmt = conn.prepareStatement(Dsql);
	Dstmt.setInt(1, diaryNo);
	
	ResultSet DRS = Dstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<!-- jQuery library -->
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
	<!-- Popper JS -->
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  padding: 8px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

tr:hover {background-color: #FFFFE0;}


  textarea {
    width: 100%;
    height: 6.25em;
    border: none;
    resize: none;
    border-style: ridge;
  }
a {
    text-decoration: none;
}
a:link {
  color: black;
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
.a:active {
  color: yellow;
  background-color: transparent;
  text-decoration: underline;
}
</style>
</head>
<body>
<div style="text-align: center; padding: 50px 10px 25px;">
		<a href="./diary.jsp"><h1>PLAN</h1></a>
		<div>
			<%
				if(DRS.next()) {
			%>
			<div style="padding: 10px 300px 10px;">
			<table class="table table-bordered">
				<tr>
					<td>DiaryNo</td>
					<td><%=DRS.getString("diaryNo")%></td>
				</tr>
				<tr>
					<td>DiaryDate</td>
					<td><%=DRS.getString("diaryDate")%></td>
				</tr>
				<tr>
					<td>DiaryTodo</td>
					<td><%=DRS.getString("diaryTodo")%></td>
				</tr>
				<tr>
					<td>createDate</td>
					<td><%=DRS.getString("createDate")%></td>
				</tr>
			</table>
			</div>
			<%
				}
			%>
			<div style="text-align: right; padding: 10px 300px 10px;">
				<a href="./updateDiary.jsp?diaryNo=<%=diaryNo%>" >수정하기</a>
				<a href="./deleteDiary.jsp?diaryNo=<%=diaryNo%>"style="color:red">삭제</a>
			</div>
		</div>
	</div>
</body>
</html>