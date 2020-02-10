package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class UserDAO {
	
	DataSource dataSource;
	
	public UserDAO() { //context.xml에서 설정한 JNDI를 이용. 이 객체는 이제 Container의 DBCP에 의해 관리된다.
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/pym7857");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/* 로그인 성공 여부 메서드 */
	public int login(String userID, String userPassword) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM user WHERE userID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString("userPassword").equals(userPassword)) {
					return 1; // 로그인 성공
				}
				return 2; //비밀번호가 틀림
			} else {
				return 0; // 해당 사용자가 존재하지 않음 
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	
	/* 회원가입 아이디 중복체크 */
	public int registerCheck(String userID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM user WHERE userID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next() || userID.equals("")) {
				return 0; // 이미 존재하는 회원
			} else {
				return 1; // 가입 가능한 회원 아이디
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	/* 회원가입 메서드 */
	public int register(String userID, String userPassword, String userName, String userAge, String userGender, String userEmail, String userProfile) { // 아이디 중복체크
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO user VALUES (?, ?, ?, ?, ?, ?, ?, 0)";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, userPassword);
			pstmt.setString(3, userName);
			pstmt.setInt(4, Integer.parseInt(userAge));
			pstmt.setString(5, userGender);
			pstmt.setString(6, userEmail);
			pstmt.setString(7, userProfile);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	
	/**
	 * 유저정보 세팅 메서드
	 * */
	public UserDTO getUser(String userID) {
		UserDTO user = new UserDTO();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM user WHERE userID = ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user.setUserID(userID);
				user.setUserPassword(rs.getString("userPassword"));
				user.setUserName(rs.getString("userName"));
				user.setUserAge(rs.getInt("userAge"));
				user.setUserGender(rs.getString("userGender"));
				user.setUserEmail(rs.getString("userEmail"));
				user.setUserProfile(rs.getString("userProfile"));
				user.setUserPoint(rs.getInt("userPoint"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return user;
	}
	
	/**
	 * 회원정보 수정 메서드
	 * */
	public int update(String userID, String userPassword, String userName, String userAge, String userGender, String userEmail) { // 아이디 중복체크
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE user SET userPassword = ?, userName = ?, userAge = ?, userGender = ?,userEmail = ? WHERE userID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userPassword);
			pstmt.setString(2, userName);
			pstmt.setInt(3, Integer.parseInt(userAge));
			pstmt.setString(4, userGender);
			pstmt.setString(5, userEmail);
			pstmt.setString(6, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	
	/* userProfile을 db에 업데이트 */
	public int profile(String userID, String userProfile) { 
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE user SET userProfile = ? WHERE userID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userProfile);
			pstmt.setString(2, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	
	/* userProfile의 경로를 가져오는 메서드 */
	public String getProfile(String userID) { // 아이디 중복체크
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT userProfile FROM user WHERE userID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString("userProfile").equals("")) { 
					return "http://pym7857.cafe24.com/images/icon.png"; // 기본 상태의 프로필 사진 
				}
				return "http://pym7857.cafe24.com/file/" + rs.getString("userProfile");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "http://localhost:8084/UserChat/images/icon.png";
	}
	
	/* 유저 포인트 증가 */
	public int getPoint(String userID) { 
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE user SET userPoint = userPoint + 1 WHERE userID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
}