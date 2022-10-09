<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	if(id==null || pw==null || id.length() < 4 || pw.length() < 4){
		response.sendRedirect("./insertMember.jsp?errorMsg=error");
		return;
	}
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String sql = "INSERT INTO member(id, pw, level) VALUES(?,PASSWORD(?),0)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, id);
	stmt.setString(2, pw);
	stmt.execute();
	
	response.sendRedirect("./index.jsp");
%>