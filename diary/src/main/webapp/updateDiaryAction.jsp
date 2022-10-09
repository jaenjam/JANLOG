<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel")<1){
		response.sendRedirect("./index.jsp?errorMsg=Level 0 or higher");
		return;
	}
	
	request.setCharacterEncoding("utf-8");
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	String diaryDate = request.getParameter("diaryDate");
	String diaryTodo = request.getParameter("diaryTodo");
	System.out.println(diaryNo + " <-- diaryNo");
	System.out.println(diaryDate + " <-- diaryDate");
	System.out.println(diaryTodo + " <-- diaryTodo");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	/*
	
	UPDATE diary
	SET diary_date = ?,
	diary_todo = ?
	WHERE diary_no = ? 
	*/
	
	String sql = "UPDATE diary SET diary_date = ?, diary_todo = ? WHERE diary_no = ? ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, diaryTodo);
	stmt.setInt(3, diaryNo);
	int row = stmt.executeUpdate();
	System.out.println(row + " <-- row");
	
	if(row == 0) { // 수정실패
		response.sendRedirect("./updateDiary.jsp?diaryNo="+diaryNo);
	} else {
		response.sendRedirect("./diaryOne.jsp?diaryNo="+diaryNo);
	}
%>