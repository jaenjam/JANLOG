<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String locationNo = request.getParameter("locationNo");
   
   String word = request.getParameter("word"); 
   int currentPage = 1;
   if(request.getParameter("currentPage") != null) {
      currentPage = Integer.parseInt(request.getParameter("currentPage"));
   }
   final int ROW_PER_PAGE = 10;
   int beginRow = (currentPage - 1) * ROW_PER_PAGE;
   
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
table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  padding: 8px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

tr:hover {background-color: #FFFFE0;}

th {
  background-color: #87CEFA;
  color: white;
}

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
  color: skyblue;
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
.a:active {
  color: yellow;
  background-color: transparent;
  text-decoration: underline;
}

</style>
</head>
<body>
<div class="container-fluid" >
<div style="padding: 50px 100px 25px;">
<div>
	<a href="./1boardList.jsp">
		<h1>JANLOG</h1>
	</a>
	<div style="text-align: right">
		<a href="./guest.jsp">방명록</a>&emsp;&emsp;
		<a href="./diary.jsp">다이어리</a>&emsp;&emsp;
		<a href="./logout.jsp" target="_blank" style="color:red">로그아웃</a>&emsp;&emsp;
	</div>
</div>
   <hr>
   <div class="row">
      <div class="col-sm-2">
         <!-- left menu -->
         <div>
            <ul>
               
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
            <div style="margin-bottom:50px">
    		 	<button type="submit" class="btn btn-warning"  onclick="location.href='insertBoard.jsp'">글 입력</button>
    		</div>
      </div>
      
 
      <div class="col-sm-10">
         <!-- main -->
         <%
            // 게시글 목록
            String boardSql = "";
            PreparedStatement boardStmt = null;
            if(locationNo == null) {
               boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no ORDER BY board_no DESC LIMIT ?, ?";
               boardStmt = conn.prepareStatement(boardSql);
               boardStmt.setInt(1, beginRow);
               boardStmt.setInt(2, ROW_PER_PAGE);
            } else {
               boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.location_no = ? ORDER BY board_no DESC LIMIT ?, ?";
               boardStmt = conn.prepareStatement(boardSql);
               boardStmt.setInt(1, Integer.parseInt(locationNo));
               boardStmt.setInt(2, beginRow);
               boardStmt.setInt(3, ROW_PER_PAGE);
            }
            ResultSet boardRs = boardStmt.executeQuery();
         
     	PreparedStatement stmt2 = null;
     	if(word == null) {
     		stmt2 = conn.prepareStatement("select count(*) from board");
     	} else {
     		stmt2 = conn.prepareStatement("select count(*) from board where board_title like ?");
     		stmt2.setString(1, "%"+word+"%");
     	}
     	ResultSet rs2 = stmt2.executeQuery();
     	int totalCount = 0;
     	if(rs2.next()) {
     		totalCount = rs2.getInt("count(*)");
     	}
         
         %>
         
         <%
         
         	if(session.getAttribute("loginLevel")!=null 
         		&& (Integer)(session.getAttribute("loginLevel"))>0){
         
         %>


     	<%
         	}
     	%>
         <div>
         <table>
         
            <thead>
               <tr>
                  <th>locationName</th>
                  <th>boardNo</th>
                  <th>boardTitle</th>
               </tr>
            </thead>
            <tbody>
               <% 
                  while(boardRs.next()) {
               %>
                     <tr>
                        <td><%=boardRs.getString("locationName")%></td>
                        <td><%=boardRs.getInt("boardNo")%></td>
                        <td><a href="./1boardOne.jsp?boardNo=<%=boardRs.getInt("boardNo")%>">
                        <%=boardRs.getString("boardTitle")%></a></td>
                     </tr>
               <%      
                  }
               %>
            </tbody>
         </table>           
        
         <div>
         	<form class="form-inline" action="./1boardList.jsp">
         		<%
         			if(locationNo != null){
         		%>
         		<input type="hidden" name="locationNo" value="<%=locationNo%>">
         		<%
         			}
         		%>
         		
         		<br>
         		<label>제목검색</label>
         		<input type="text" class="form-control" name="word">
         		<button type="submit" class="btn btn-primary">Submit</button>
         	</form>
         </div>
         
         
         <!--  페이징 -->
         <div>
         	<ul class="pagination pagination-sm">
            <%
            if(locationNo == null) {
                  if(currentPage > 1) {
            %>
                     <li class="page-item"><a href="./1boardList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
            <% 
            		}
               } else {
                  if(currentPage > 1) {
            %>
                    <li class="page-item"><a href="./1boardList.jsp?currentPage=<%=currentPage-1%>&locationNo=<%=locationNo%>&word=<%=word%>">이전</a></li>
            <%      
                  }
               }
           
            %>

            
            <%
			
            if(locationNo == null) { //전체
            %>
                 <li class="page-item"><a href="./1boardList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
            <%
               } else { //전체 + 검색함
            %>
              <li class="page-item"><a href="./1boardList.jsp?currentPage=<%=currentPage+1%>&locationNo=<%=locationNo%>">다음</a></li>
            <%
               }
            %>

            </ul>
         </div>
          </div>
		</div><!-- end main -->
	</div>
	</div>
</div>
</body>
</html>