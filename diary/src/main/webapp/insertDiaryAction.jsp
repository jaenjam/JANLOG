<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m"))+1;
	int d = Integer.parseInt(request.getParameter("d"));
	String diaryTodo = request.getParameter("diaryTodo");
	/*
	?y=2022&m=6&d=1
	
	INSERT INTO diary (diary_date, diary_todo, create_date)values (?,?,now());
	
	*/
	
	// 메뉴 목록
	String sql = "INSERT INTO diary (diary_date, diary_todo, create_date)values (?,?,now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y+"-"+m+"-"+d);
	stmt.setString(2, diaryTodo);
	int row = stmt.executeUpdate();
	

	response.sendRedirect("./diary.jsp");	
	
	
%>
