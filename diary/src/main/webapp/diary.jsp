<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%
	Calendar c = Calendar.getInstance();
	if(request.getParameter("y") != null || request.getParameter("m") != null){
		int y  = Integer.parseInt(request.getParameter("y"));
		int m  = Integer.parseInt(request.getParameter("m"));
		
		if(m==-1){ //1월에서 이전버튼 눌렀을 때
			m = 11;
			y -= 1; //y = y - 1 --y;
		}
		
		if(m==13){ //12월에서 다음버튼 눌렀을 때
			m = 1;
			y += 1; //y = y + 1, ++y;
		}
		
		c.set(Calendar.YEAR, y);
		c.set(Calendar.MONTH, m);
	}
	
	int lastDay = c.getActualMaximum(Calendar.DATE);
	
	int startBlank = 0; //1일 전에 빈 td, (0:일,1:월,2:화,3:수,4:목,5:금,6:토) <-- 1일을 요일값 -1
	
	//출력하는 달의 1일의 날짜객체
	Calendar first = Calendar.getInstance(); //연월일
	first.set(Calendar.YEAR,c.get(Calendar.YEAR));
	first.set(Calendar.MONTH,c.get(Calendar.MONTH));
	first.set(Calendar.DATE, 1);
	startBlank = first.get(Calendar.DAY_OF_WEEK)-1;
	
	int endBlank = 7 - (startBlank+lastDay)%7; // 마지막날 이후의 빈 td개수
	if(endBlank==7){
		endBlank=0;
	}
	   Class.forName("org.mariadb.jdbc.Driver");
	   String url = "jdbc:mariadb://localhost:3306/blog";
	   String dbuser = "root";
	   String dbpw = "1234";
	   Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	/*
	SELECT diary_no diaryNo,
	diary_date diaryDate,
	diary_todo diaryTodo
	FROM diary
	WHERE YEAR(diary_date) = ? AND MONTH(diary_date)=? 
	ORDER BY diary_date
	*/
	String sql ="SELECT diary_no diaryNo, diary_date diaryDate, diary_todo diaryTodo FROM diary WHERE YEAR(diary_date) = ? AND MONTH(diary_date)=? ORDER BY diary_date";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,c.get(Calendar.YEAR));
	stmt.setInt(2,c.get(Calendar.MONTH)+1);
	ResultSet rs = stmt.executeQuery();
	// 특수한 환경의 타입 diary테이블의 ResultSet -> 자바를 ArrayList<Diary>
	
	ArrayList<Diary> list = new ArrayList<Diary>();
	while(rs.next()){
		Diary d = new Diary();
		d.diaryNo = rs.getInt("diaryNo");
		d.diaryDate = rs.getString("diaryDate");
		d.diaryTodo = rs.getString("diaryTodo");
		list.add(d);
	}
	// System.out.println(list);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
table {
  border-collapse: collapse;
  width: 100%;
  	margin-right: auto;
	margin-left: auto;
}
th {
  padding: 8px;
  text-align: left;
  border-bottom: 1px solid #ddd;
  background-color: #87CEFA;
  color: white;
}


a {
    text-decoration: none;
}
a:link {
  color: black;
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
<div >
	<div style="text-align: right; padding: 5px 10px 5px;">
		<a href="./1boardList.jsp">게시판</a>&emsp;&emsp;
		<a href="./guest.jsp">방명록</a>&emsp;&emsp;
		<a href="./index.jsp">홈으로</a>&emsp;&emsp;
	</div>
	<div style="text-align: center; padding: 50px 10px 25px;">
		<a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)-1%>">이전달</a>
		<strong>
		<span style="margin-left:20px; margin-right:20px"><%=c.get(Calendar.YEAR)%>년 <%=c.get(Calendar.MONTH)+1%>월</span>
		</strong>
		<a href="./diary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)+1%>">다음달</a>
	</div>
	
	<!-- <div>startBlank : <%=startBlank%></div> -->
	<div style="padding:50px 50px 100px 100px">
	<table border="1" width="60%">
		<tr>
			<th>일요일</th>
			<th>월요일</th>
			<th>화요일</th>
			<th>수요일</th>
			<th>목요일</th>
			<th>금요일</th>
			<th>토요일</th>
			
		</tr>
		<tr style="height:100px" width=100px">
		<%
			for(int i=1; i<=startBlank+lastDay+endBlank; i+=1){
			if(i-startBlank <1){
		%>
			<td>&nbsp;</td>
		<%	
			}else if(i-startBlank > lastDay){
		%>
			<td>&nbsp;</td>
		<%		
			}else{
		%>

				
				<td style="height:100px" width="100px">
					<input type="hidden" value="<%=c.get(Calendar.YEAR)%>" name="y">
					<input type="hidden" value="<%=c.get(Calendar.MONTH)%>" name="m">
					<input type="hidden" value="<%=i-startBlank%>" name="d">
					<a href="./insertDiary.jsp?y=<%=c.get(Calendar.YEAR)%>&m=<%=c.get(Calendar.MONTH)%>&d=<%=i-startBlank%>">
						<%=i-startBlank%>
					</a>
				
					<%
						for(Diary d:list){
							
							if(Integer.parseInt(d.diaryDate.substring(8)) == i-startBlank){
							
					%>
							<div style="margin-top:10px">
							<input type="hidden" value="<%=d.diaryNo%>" name="diaryNo">
							<a href="./diaryOne.jsp?diaryNo=<%=d.diaryNo%>"><%=d.diaryTodo%></a></div>
							
					<%
							}
						}
					%>
				</td>
		<%			
			}
				if(i%7==0 && i!=startBlank+lastDay){
		%>
			</tr><tr>
		<%			
				}
			}
		
		%>
		</tr>
	</table>
	</div>
</div>
</body>
</html>