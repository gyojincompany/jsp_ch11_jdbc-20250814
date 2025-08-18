<%@page import="com.gyojincompany.member.MemberDto"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>     
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		String mid = request.getParameter("mid"); //조회할 아이디		
		//DB에 삽입할 데이터 준비 완료
		
		//DB 커넥션 준비
		String driverName = "com.mysql.jdbc.Driver"; //MySQL JDBC 드라이버 이름
		String url = "jdbc:mysql://localhost:3306/jspdb"; //MySQL이 설치된 서버의 주소(ip)와 연결할 DB(스키마) 이름		
		String username = "root";
		String password = "12345";
		
		//SQL문 만들기
		String sql = "SELECT * FROM members WHERE memberid='" + mid + "'";
		//String sql = "SELECT * FROM members where memberid='tiger99'";
		
		
		Connection conn = null; //커넥션 인터페이스로 선언 후 null로 초기값 설정
		Statement stmt = null; //sql문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언
		ResultSet rs = null; //select문 실행 시 DB에서 반환해주는 레코드 결과를 받아주는 자료타입 rs 선언
		MemberDto memberDto = new MemberDto(); //dto 객체 선언
		
		try {
			Class.forName(driverName); //MySQL 드라이버 클래스 불러오기			
			conn = DriverManager.getConnection(url, username, password);
			//커넥션이 메모리 생성(DB와 연결 커넥션 conn 생성)
			stmt = conn.createStatement(); //stmt 객체 생성
			
			
			//int sqlResult = stmt.executeUpdate(sql);
			rs = stmt.executeQuery(sql); 
			//select문 실행->결과가 DB로부터 반환->그 결과(레코드(행))을 받아 주는 ResultSet 타입 객체로 받아야 함			
			
			//String sid = null;
			
			if(rs.next()) { //참이면 레코드가 1개 이상 존재->아이디가 존재
				 do { //rs에서 레코드를 추출하는 방법
					String sid = rs.getString("memberid");
					String spw = rs.getString("memberpw");
					String sname = rs.getString("membername");
					String semail = rs.getString("memberemail");
					String sdate = rs.getString("memberdate");
					
					memberDto.setMemberid(sid);
					memberDto.setMemberpw(spw);
					memberDto.setMembername(sname);
					memberDto.setMemberemail(semail);
					memberDto.setMemberdate(sdate);
											
				} while(rs.next());
			} else { //거짓이면 레코드가 0개->아이디 존재하지 않음
				response.sendRedirect("memberModify.jsp"); //수정할 멤버 아이디 입력 페이지로 강제 이동
			}
			//if(sid == null) {
				//out.println("** 존재하지 않는 회원입니다 **");
			//}
			
		} catch (Exception e) {
			out.println("DB 에러 발생! 회원 조회 실패!");
			e.printStackTrace(); //에러 내용 출력
		} finally { //에러의 발생여부와 상관 없이 Connection 닫기 실행 
			try {
				if(rs != null) {
					rs.close();
				}				
				if(stmt != null) { //stmt가 null 이 아니면 닫기(conn 닫기 보다 먼저 실행)
					stmt.close();
				}				
				if(conn != null) { //Connection이 null 이 아닐 때만 닫기
					conn.close();
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		request.setAttribute("memberDto", memberDto); 
		//조회된 회원정보가 들어있는 memberDto를 request 객체에 set 
	
	%>

	<h2>회원 정보 수정</h2>
	<hr>
	<form action="memberModifyOk.jsp" method="post">
		<input type="hidden" name="mid" value="${memberDto.memberid }">
		아이디 : <input type="text" name="mid" value="${memberDto.memberid }" disabled="disabled"><br><br>
		비밀번호 : <input type="password" name="mpw" value="${memberDto.memberpw }"><br><br>
		이름 : <input type="text" name="mname" value="${memberDto.membername }"><br><br>
		이메일 : <input type="text" name="memail" value="${memberDto.memberemail }"><br><br>
		가입일 : <input type="text" name="mdate" value="${memberDto.memberdate }" readonly="readonly"><br><br>
		<input type="submit" value="수정완료">
	</form>
</body>
</html>