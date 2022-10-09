<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel")<1){
		response.sendRedirect("./index.jsp?errorMsg=Level 0 or higher");
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
	
	System.out.println(diaryNo + " <-- diaryNo");

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
			<%
				if(DRS.next()) {
			%>
		<form action="./updateDiaryAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<td>DiaryNo</td>
					<td><input type="text" value="<%=DRS.getString("diaryNo")%>" readonly="readonly" name="diaryNo"></td>
				</tr>
				<tr>
					<td>DiaryDate</td>
					<td><input type="text" value="<%=DRS.getString("diaryDate")%>" name="diaryDate"></td>
				</tr>
				<tr>
					<td>DiaryTodo</td>
					<td><textarea rows="5" cols="40" name="diaryTodo"><%=DRS.getString("diaryTodo")%></textarea></td>
				</tr>
			</table>
			<%
				}
			%>
			<button type="reset" class="btn btn-danger">초기화</button>
			<button type="submit" class="btn btn-warning">입력</button>
		</form>
		</div>
	</div>
</body>
</html>