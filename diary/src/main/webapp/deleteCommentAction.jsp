<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	PreparedStatement stmt = conn.prepareStatement("DELETE from comment WHERE comment_no = ? and board_no=? and comment_pw=password(?)");
	stmt.setInt(1, commentNo);
	stmt.setInt(2, boardNo);
	stmt.setString(3, commentPw);
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	
	response.sendRedirect("./1boardOne.jsp?boardNo="+boardNo);
%>