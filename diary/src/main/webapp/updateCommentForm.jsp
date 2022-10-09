<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}

	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentId = request.getParameter("commentId");
	System.out.println(boardNo + " <-- boardNo");

	
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
	
	String Csql = "SELECT comment_no, comment_id, board_no, comment_content, create_date from comment where board_no = ? order by create_date";
	PreparedStatement stmtC = conn.prepareStatement(Csql);
	stmtC.setInt(1, boardNo);
	
	ResultSet RSC = stmtC.executeQuery();
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
				if(RSC.next()){
			%>
		<form action="./updateCommentAction.jsp" method="post">	
			<table class="table table-bordered">
				<tr>
					<th>ID</th>
					<th>CONTENT</th>
					<th>PASSWORD</th>
				</tr>
				<tr>	
					<td>
					<input type="hidden" name="commentNo" value="<%=commentNo%>">
					<input type="hidden" name="boardNo" value="<%=boardNo%>">
					<input type="text" name="commentId" value="<%=commentId%>" readonly="readonly">
					</td>
					
					<td>
					<textarea rows="5" cols="80" name="commentContent"><%=RSC.getString("comment_content")%></textarea>
					</td>
					
					<td>
					<input type="password" name="Pw">
					</td>
				</tr>
				</table>
				
				
			<%
				}
			%>	
				<button type="submit">저장</button>
			</form>
		</div><!-- div end -->
		
					
		</div><!-- end main -->

		
		
		
		
	</div>
</body>
</html>