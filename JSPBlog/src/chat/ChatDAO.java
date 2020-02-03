package chat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ChatDAO {
	
	DataSource dataSource;
	
	public ChatDAO() { //context.xml에서 설정한 JNDI를 이용. 이 객체는 이제 Container의 DBCP에 의해 관리된다.
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/JSPBlog");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 채팅기록 리스트 가져오는 메소드
	 * */
	public ArrayList<ChatDTO> getChatListByID(String fromID, String toID, String chatID) {
		
		ArrayList<ChatDTO> chatList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT*FROM CHAT WHERE ( (fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?) ) AND chatID > ? ORDER BY chatTime";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);	// (순서를바꿔서 넣어준다) 즉, 자신이 받던간에 보내던간에 항상 가져올 수 있도록
			pstmt.setString(4, fromID);
			pstmt.setInt(5, Integer.parseInt(chatID));
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<ChatDTO>(); // 선언
			while(rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				int hour = Integer.parseInt(rs.getString("chatTime").substring(11,13)); // 시간(hour)
				String timeType = "오전";
				if(hour >= 12) {
					timeType = "오후";
					if(hour > 12)
						hour -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + " " + timeType + " " + hour + ":" + rs.getString("chatTime").substring(14,16) + "");
				chatList.add(chat);
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
		return chatList;
	}
	
	/**
	 * 상위 몇개(number) 채팅기록 데이터만 가져오는 메소드
	 * */
	public ArrayList<ChatDTO> getChatListByRecent(String fromID, String toID, int number) {
		
		ArrayList<ChatDTO> chatList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT*FROM CHAT "
				+ "WHERE ( (fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?) ) "
				+ "AND chatID > (SELECT MAX(chatID) - ? "
								+ "FROM CHAT "
								+ "WHERE (fromID = ? AND toID = ?) OR (fromID =? AND toID = ?)) " /* 해당 두사람이 대화한 정보만 가져온다 */
								+ "ORDER BY chatTime";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);	// (순서를바꿔서 넣어준다) 즉, 자신이 받던간에 보내던간에 항상 가져올 수 있도록
			pstmt.setString(4, fromID);
			pstmt.setInt(5, number);
			pstmt.setString(6, fromID);
			pstmt.setString(7, toID);
			pstmt.setString(8, toID);	// (순서를바꿔서 넣어준다) 즉, 자신이 받던간에 보내던간에 항상 가져올 수 있도록
			pstmt.setString(9, fromID);
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<ChatDTO>();
			while(rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				int hour = Integer.parseInt(rs.getString("chatTime").substring(11,13)); // 시간(hour)
				String timeType = "오전";
				if(hour >= 12) {
					timeType = "오후";
					if(hour > 12)
						hour -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + " " + timeType + " " + hour + ":" + rs.getString("chatTime").substring(14,16) + "");
				chatList.add(chat);
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
		return chatList;
	}
	
	/* Box의 모든 요소 가져오는 메서드 */
	public ArrayList<ChatDTO> getBox(String userID) {
		
		ArrayList<ChatDTO> chatList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "select*from chat "
						+ "where chatID in ("
							+ "select max(chatID) "
							+ "from chat "
							+ "where toID = ? OR fromID = ? group by fromID OR toID)";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, userID);
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<ChatDTO>();
			while(rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				int hour = Integer.parseInt(rs.getString("chatTime").substring(11,13)); // 시간(hour)
				String timeType = "오전";
				if(hour >= 12) {
					timeType = "오후";
					if(hour > 12)
						hour -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0,11) + " " + timeType + " " + hour + ":" + rs.getString("chatTime").substring(14,16) + "");
				chatList.add(chat);
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
		return chatList;
	}
	
	/**
	 * 채팅 전송 기능 메서드
	 * : 전송 됐는지 그 여부를 반환하기 위해 int형 사용
	 * */
	public int submit(String fromID, String toID, String chatContent) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO CHAT VALUES (NULL, ?, ?, ?, NOW(), 0)"; // 보내는순간, chatRead = 0 으로 설정
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, chatContent);
			return pstmt.executeUpdate();
			// return 0;
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
	 * 상대방이 메세지 읽었을때, chatRead = 1 로 변경해주는 함수
	 * */
	public int readChat(String fromID, String toID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "UPDATE CHAT SET chatRead = 1 WHERE (fromID = ? AND toID = ?)"; // 받는사람 입장
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, toID);
			pstmt.setString(2, fromID);
			return pstmt.executeUpdate();
			// return 0;
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	
	/**
	 * 읽지않은(charRead = 0) 메세지 개수 반환
	 * */
	public int getAllUnreadChat(String userID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT COUNT(chatID) FROM CHAT WHERE toID = ? AND chatRead = 0";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("COUNT(chatID)");
			}
			return 0; // 받은 메세지가 없음
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	
	public int getUnreadChat(String fromID, String toID) { // 안읽씹 한 메세지 갯수 가져오기
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT COUNT(chatID) FROM CHAT WHERE fromID = ? AND toID = ? AND chatRead = 0";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("COUNT(chatID)");
			}
			return 0; // 받은 메세지가 없음
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}
	
}