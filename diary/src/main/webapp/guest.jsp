<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
   Class.forName("org.mariadb.jdbc.Driver");
   String url = "jdbc:mariadb://localhost:3306/blog";
   String dbuser = "root";
   String dbpw = "1234";
   Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
   
   // 메뉴 목록
   String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
   PreparedStatement locationStmt = conn.prepareStatement(locationSql);
   ResultSet locationRs = locationStmt.executeQuery();
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
  textarea {
    width: 100%;
    height: 6.25em;
    border: none;
    resize: none;
    border-style: ridge;
  }
a {
    text-decoration: none;
}
a:link {
  color: red;
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
a:active {
  color: yellow;
  background-color: transparent;
  text-decoration: underline;
}

</style>

</head>
<body>
<div class="container-fluid">
   <div>
   		<a href="./1boardList.jsp">
   			<h1>JANLOG</h1>
   		</a>
   		<div style="text-align: right">
   			<a href="./1boardList.jsp">게시판</a>&emsp;&emsp;
   			<a href="./diary.jsp">다이어리</a>&emsp;&emsp;
   			<a href="./logout.jsp" style="color:red">로그아웃</a>&emsp;&emsp;
   		</div>
   	</div>
   <hr>
   <div class="row">
      <div class="col-sm-2">
         <!-- left menu -->
         <div>
            <ul>
               <li><a href="./index.jsp">홈으로</a></li>
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
      <div class="col-sm-8">
               <!-- to do -->
         <%
            /*
               SELECT guestbook_no guestbookNo, 
                     guestbook_content guestbookContent, 
                     id, 
                     create_date createDate 
               FROM guestbook 
               ORDER BY create_date DESC 
               LIMIT ?,?
            */
            
            int ROW_PER_PAGE = 10;
            int beginRow = 0;
            
            String guestbookSql = "SELECT guestbook_no guestbookNo, guestbook_content guestbookContent, id, create_date createDate FROM guestbook ORDER BY guestbook_no DESC LIMIT ?,?";
            PreparedStatement guestbookStmt = conn.prepareStatement(guestbookSql);
            guestbookStmt.setInt(1, beginRow);
            guestbookStmt.setInt(2, ROW_PER_PAGE);
            ResultSet guestbookRs = guestbookStmt.executeQuery();
         %>
               <%
                  while(guestbookRs.next()) {
               %>
                     <table class="table table-bordered">
                        <tr>
                           <td style="width:10%"><%=guestbookRs.getString("id")%></td>
                           <td style="width:50%"><%=guestbookRs.getString("guestbookContent")%></td>
                           <td style="width:15%"><%=guestbookRs.getString("createDate")%></td>
                        </tr>
                     </table>
                     <%
                        String loginId = (String)session.getAttribute("loginId");
                        if(loginId != null && loginId.equals(guestbookRs.getString("id"))) {
                     %>
                          <div style="text-align:right; margin-top: -10px;"><a href="./deleteGuestbook.jsp?guestbookNo=<%=guestbookRs.getInt("guestbookNo")%>">삭제</a></div>
                     <%
                        }
                  }
               %>
      
         <%
            if(session.getAttribute("loginId") != null) {
         %>
               <form method="post" action="./insertGuestbookAction.jsp">
                  <div>
                     <textarea class="ridge" rows="3" cols="50" name="guestbookContent"></textarea>
                  </div>
                  <div style="text-align:right">
                     <button type="submit" class="btn btn-warning">글입력</button>
                  </div>
                  <!-- 
                     guestbook_no : auto increment
                     guestbook_content : guestbookContent
                     id : session.getAttribute("loginId")
                     create_date : now()
                   -->
               </form>
         <%
            }
         %>

            
      </div><!-- end main -->
   </div>
</div>
</body>
</html>
<%
	guestbookRs.close();
	guestbookStmt.close();
	locationRs.close();
	locationStmt.close();
	conn.close();
%>