<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel")<1){
		response.sendRedirect("./index.jsp?errorMsg=Level 0 or higher");
		return;
	}	

	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	out.println(conn);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	System.out.println(locationStmt);
	ResultSet locationRs = locationStmt.executeQuery();
	
	String boardSql = "SELECT l.location_name locationName, b.board_title boardTitle,b.board_content boardContent,b.create_date createDate FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	// db자원해제
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
<div class="container-fluid">
	<h1>Blog</h1>
	<hr>
	<div class="row">
		<div class="col-sm-2">
			<!-- left menu -->
			<div>
				<ul>
					
					<li><a href="./1boardList.jsp">전체</a></li>
					<%
						while(locationRs.next()) {
					%>
							<li>
								<a href="./1boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
									<%=locationRs.getString("locationName")%>
								</a>
							</li>
					<%		
						}
					%>	
				</ul>
			</div>
		</div>
		
		<!-- start main -->
		<div class="col-sm-10">
		
			<%
				while(boardRs.next()) {
			%>
			<form action="./updateBoardAction.jsp" method="post">
					<table class="table table-bordered">
						<tr>
						<td>locationName</td>
		                  <td>
		                     <input type="hidden" name="boardNo" value="<%=boardNo%>">
		                     <input type="text" name="locationName" value="<%=boardRs.getString("locationName")%>" readonly="readonly">
		                  </td>
		                  </tr>
		                  <tr>
		                     <td>boardTitle</td>
		                     <td><input type="text" name="boardTitle" value="<%=boardRs.getString("boardTitle")%>"></td>
		                  </tr>
		                  <tr>
		                     <td>boardContent</td>
		                     <td><textarea rows="5" cols="80" name="boardContent"><%=boardRs.getString("boardContent")%></textarea></td>
		                  </tr>
		                  <tr>
		                     <td>boardPw</td>
		                     <td><input type="password" name="boardPw"></td>
		                  </tr>
		              </table>
			<%
				}
			%>
					<button type="submit">입력</button>
				</form>
		</div><!-- end main -->
	</div>
</div>
</body>
</html>