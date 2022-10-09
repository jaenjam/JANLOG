<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m"));
	int d = Integer.parseInt(request.getParameter("d"));
	/*
	?y=2022&m=6&d=1
	
	insert into diary (diary_date, diary_todo, create_date)values (?,?,now());
	
	*/
	
	// 메뉴 목록
	String locationSql = "SELECT diary_date diaryDate, diary_todo diaryTodo FROM diary";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
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
</head>
<body>
	<div class="col-sm-6">
		<h1>나의 다이어리</h1>
		<div>
		<form method="post" action="./insertDiaryAction.jsp?y=<%=y%>&m=<%=m%>&d=<%=d%>">
			<table class="table table-bordered">
				<tr>
					<td>DiaryTodo</td>
					<td>
					<input type="hidden" value="y" name="y">
					<input type="hidden" value="m" name="m">
					<input type="hidden" value="d" name="d">
					<textarea rows="5" cols="80" name="diaryTodo"></textarea>
					</td>
				</tr>
			</table>
			<button type="submit" class="btn btn-success">글입력</button>
			<button type="reset" class="btn btn-danger">초기화</button>
		</form>	
		</div>
	</div>
</body>
</html>