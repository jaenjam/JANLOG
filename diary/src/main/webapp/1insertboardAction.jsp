<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	if(session.getAttribute("loginId")==null || (Integer)session.getAttribute("loginLevel")<1){
		response.sendRedirect("./index.jsp");
		return;
	}

	request.setCharacterEncoding("utf-8");	

	int locationNo = Integer.parseInt(request.getParameter("locationNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	System.out.println(locationNo + " <-- locationNo");
	// 디버깅
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/blog";
	String dbuser = "root";
	String dbpw = "1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String sql = "INSERT INTO board(location_no,board_title,board_content,board_pw,create_date) VALUES(?,?,?,PASSWORD(?),NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, locationNo);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardPw);
	int row = stmt.executeUpdate();
	// 쿼리 실행 겨로가 디버깅
	if(row == 1) {
		//
	} else {
		//
	}
	// 재요청
	response.sendRedirect("./1boardList.jsp");	
%>