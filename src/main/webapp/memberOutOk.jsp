<%@page import="java.sql.Statement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴 처리</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
	
		String mid = request.getParameter("outid"); //탈퇴할 아이디		
		//DB에 삽입할 데이터 준비 완료
		
		//DB 커넥션 준비
		String driverName = "com.mysql.jdbc.Driver"; //MySQL JDBC 드라이버 이름
		String url = "jdbc:mysql://localhost:3306/jspdb"; //MySQL이 설치된 서버의 주소(ip)와 연결할 DB(스키마) 이름		
		String username = "root";
		String password = "12345";
		
		//SQL문 만들기
		String sql = "DELETE FROM members WHERE memberid='"+mid+"'";
		
		
		Connection conn = null; //커넥션 인터페이스로 선언 후 null로 초기값 설정
		Statement stmt = null; //sql문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언		
		
		try {
			Class.forName(driverName); //MySQL 드라이버 클래스 불러오기			
			conn = DriverManager.getConnection(url, username, password);
			//커넥션이 메모리 생성(DB와 연결 커넥션 conn 생성)
			stmt = conn.createStatement(); //stmt 객체 생성
			
			int sqlResult = stmt.executeUpdate(sql); 
			// SQL문을 DB에서 실행->성공하면 1이 반환, 실패면 1이 아닌 값이 반환
			System.out.println("sqlResult:"+sqlResult);
			if(sqlResult == 1) { //1이 반환되면 삭제 성공
				out.println(mid + "님 회원 탈퇴 성공!");
			} else {
				out.println(mid + "님 회원 탈퇴 실패! 존재하지 않는 아이디 입니다.");
			}
			
		} catch (Exception e) {
			out.println("DB 에러 발생! 회원 가입 실패!");
			e.printStackTrace(); //에러 내용 출력
		} finally { //에러의 발생여부와 상관 없이 Connection 닫기 실행 
			try {
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
		
		
	
	%>
</body>
</html>