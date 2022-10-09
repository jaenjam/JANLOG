<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}

	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(boardNo + " <-- boardNo");

	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	
	ResultSet locationRs = locationStmt.executeQuery();
	
	/*
		SELECT 
			l.location_name locationName,  
			b.board_title boardTitle, 
			b.board_content boardContent, 
			b.create_date createDate
		FROM location l INNER JOIN board b
		ON l.location_no = b.location_no
		WHERE b.board_no = ?
	*/
	String boardSql = "SELECT l.location_name locationName,b.board_title boardTitle,b.board_content boardContent,b.create_date createDate FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	// db자원해제
	
	
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

<style>
a {
    text-decoration: none;
}
a:link {
  color: skyblue;
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
<div class="container-fluid">
<div style="padding: 50px 100px 25px;">
	<a href="./1boardList.jsp">
		<h1>JANLOG</h1>
	</a>
	<div style="text-align: right;">
		<a href="./guest.jsp">방명록</a>&emsp;&emsp;
		<a href="./diary.jsp">다이어리</a>&emsp;&emsp;
		<a href="./logout.jsp" target="_blank" style="color:red">로그아웃</a>&emsp;&emsp;
	</div>
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
		<div>
			<%
				if(boardRs.next()) {
			%>
				
					<table class="table table-bordered">
						<tr>
							<td>locationName</td>
							<td><%=boardRs.getString("locationName")%></td>
						</tr>
						<tr>
							<td>boardTitle</td>
							<td><%=boardRs.getString("boardTitle")%></td>
						</tr>
						<tr>
							<td>boardContent</td>
							<td><%=boardRs.getString("boardContent")%></td>
						</tr>
						<tr>
							<td>createDate</td>
							<td><%=boardRs.getString("createDate")%></td>
						</tr>
					</table>
					</div>
			<%
				}
			
				if((Integer)session.getAttribute("loginLevel")>0){
			%>
					<div style="text-align: right">
						
						<a href="./updateBoardForm.jsp?boardNo=<%=boardNo%>"style="color:blue">수정</a>&emsp;
						<a href="./deleteBoardForm.jsp?boardNo=<%=boardNo%>"style="color:red">삭제</a>
						
					</div>
			<%
				}
			%>
			
					
					<hr/>					
			<div>

	

			<%
				while(RSC.next()){
			%>
						
			<table class="table table-bordered">
				<tr>
					<td style="width:10%"><%=RSC.getString("comment_id")%></td>
					<td style="width:70%"><%=RSC.getString("comment_content")%></td>
					<td style="width:20%"><%=RSC.getString("create_date")%></td>
				</tr>
				</table>
				<div style="text-align: right">
				<a href="./updateCommentForm.jsp?commentNo=<%=RSC.getInt("comment_no")%>&boardNo=<%=boardNo%>&commentId=<%=RSC.getString("comment_id")%>" style="color:blue">수정</a>
				<a href="./deleteCommentForm.jsp?commentNo=<%=RSC.getInt("comment_no")%>&boardNo=<%=boardNo%>&commentId=<%=RSC.getString("comment_id")%>" style="color:red">삭제</a>		
				</div>
			<%
				}
			
			%>	
			<hr/>
			
			<!-- 댓글 입력 폼 -->
			<div>
		 <%
            if(session.getAttribute("loginId") != null) {
         %>
			
			<form action="./insertCommentAction.jsp?boardNo=<%=boardNo%>" method="post">
			<table class="table table-bordered">
				<tr>
					<th>댓글</th><td><textarea class="ridge" style="resize: none;" rows="2" cols="100" name="commentContent"></textarea></td>
				</tr>
				<tr>
					<th>비밀번호설정</th><td><input type="password" name="commentPw"></td>
				</tr>
			</table>
			<div>
				<button type="submit" class="btn btn-success">댓글입력</button>
			</div>
		 <%
            }
         %>
			
			</form>
			</div>
		</div><!-- div end -->
		
					
		</div><!-- end main -->

		
		
		
		
	</div>
	</div>
</div>
</body>
</html>