<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId")==null ){
		response.sendRedirect("./index.jsp");
		return;
	}
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String Pw = request.getParameter("Pw");
	String commentContent = request.getParameter("commentContent");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "UPDATE comment set comment_content = ? WHERE comment_no=? and comment_pw = password(?)";
	PreparedStatement stmt= conn.prepareStatement(sql);
	stmt.setString(1, commentContent);
	stmt.setInt(2, commentNo);
	stmt.setString(3, Pw);
	
	int row = stmt.executeUpdate();
	System.out.println(row + " <-- row");

	response.sendRedirect("./1boardOne.jsp?boardNo="+boardNo);
%>