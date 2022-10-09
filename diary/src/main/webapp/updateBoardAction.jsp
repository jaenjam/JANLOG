<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel")<1){
		response.sendRedirect("./index.jsp?errorMsg=Level 0 or higher");
		return;
	}	

	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	System.out.println(boardTitle + " <-- boardTitle");
	System.out.println(boardContent + " <-- boardContent");
	System.out.println(boardPw + " <-- boardPw");
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 수정
	String updateSql = "UPDATE board SET  board_title = ?, board_content = ? WHERE board_no = ? and board_pw = password(?)";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, boardTitle);
	updateStmt.setString(2, boardContent);
	updateStmt.setInt(3, boardNo);
	updateStmt.setString(4, boardPw);	
	
	int row = updateStmt.executeUpdate();
	System.out.println(row + " <-- row");

	if(row == 0) { // 수정실패
		response.sendRedirect("./updateBoardForm.jsp?boardNo="+boardNo);
	} else {
		response.sendRedirect("./1boardOne.jsp?boardNo="+boardNo);
	}
%>