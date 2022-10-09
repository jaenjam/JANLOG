<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId")==null){
		response.sendRedirect("./index.jsp");
		return;
	}
	request.setCharacterEncoding("utf-8");
	String commentContent = request.getParameter("commentContent");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentPw = request.getParameter("commentPw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String sql = "INSERT INTO comment(comment_id, board_no, comment_content, create_date, comment_pw) VALUES(?,?,?,now(),PASSWORD(?))";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, (String)session.getAttribute("loginId"));
	stmt.setInt(2, boardNo);
	stmt.setString(3, commentContent);
	stmt.setString(4, commentPw);
	stmt.executeUpdate();
	
	response.sendRedirect("./1boardList.jsp?boardNo="+boardNo);
	//boardNo=515
%>
<%
	stmt.close();
	conn.close();
%>