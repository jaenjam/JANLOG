<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel")<1){
		response.sendRedirect("./index.jsp?errorMsg=Level 0 or higher");
		return;
	}		

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	
	System.out.println(boardNo + " <-- boardNo");
	System.out.println(boardPw + " <-- boardPw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/blog","root","1234");
	out.println(conn + "<--conn");
	
	
	PreparedStatement stmt = conn.prepareStatement("DELETE from board WHERE board_no=? and board_pw=password(?)");
	stmt.setInt(1,boardNo);
	stmt.setString(2,boardPw);
	System.out.println(stmt);
	
	
	int row = stmt.executeUpdate(); //1이면 삭제 성공, 0이면 삭제 실패
	if(row==0){
		response.sendRedirect("./1boardOne.jsp?boardNo="+boardNo);
		out.println("삭제실패");
	}else{
		response.sendRedirect("./1boardList.jsp");
		out.println("삭제성공");
	}
	System.out.println(row + " <-- row");

	stmt.close();
	conn.close();
%>
