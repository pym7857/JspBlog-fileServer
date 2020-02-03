package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {

	DataSource dataSource;
	
	public BoardDAO() { //context.xml에서 설정한 JNDI를 이용. 이 객체는 이제 Container의 DBCP에 의해 관리된다.
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/JSPBlog");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/* 글 등록 함수 (초기값 설정) */
	public int write(String userID, String boardTitle, String boardContent, String boardFile, String boardRealFile) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO BOARD SELECT ?, IFNULL((SELECT MAX(boardID) + 1 FROM BOARD), 1), ?, ?, now(), 0, ?, ?, IFNULL((SELECT MAX(boardGroup) + 1 FROM BOARD), 1), 0, 0, 0";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, boardTitle);
			pstmt.setString(3, boardContent);
			pstmt.setString(4, boardFile);
			pstmt.setString(5, boardRealFile);
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
	
	/* 댓글 등록 함수 (초기값 설정) */
	public int commentWrite(String boardID, String content, String userID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO COMMENT SELECT 0, ?, ?, now(), ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(boardID));
			pstmt.setString(2, content);
			pstmt.setString(3, userID);
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
	
	/* 오직 한개의 게시글 정보를 가져오는 함수 */
	public BoardDTO getBoard(String boardID) {
		BoardDTO board = new BoardDTO();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM BOARD WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 11));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardLike(rs.getInt("boardLike"));
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
		return board;
	}
	
	/* 오직 한개의 댓글 정보를 가져오는 함수 */
	public CommentDTO getComment(String commentID) {
		CommentDTO comment = new CommentDTO();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM COMMENT WHERE commentID = ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, commentID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				comment.setCommentID(rs.getInt("commentID"));
				comment.setBoardID(rs.getInt("boardID"));
				comment.setContent(rs.getString("content"));
				comment.setContentDate(rs.getString("contentDate"));
				comment.setUserID(rs.getString("userID"));
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
		return comment;
	}
	
	/* 페이지에 해당하는 게시글 정보를 가져오는 함수 */
	public ArrayList<BoardDTO> getList(String pageNumber) {
		ArrayList<BoardDTO> boardList = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM BOARD WHERE boardGroup > (SELECT MAX(boardGroup) FROM BOARD) -? AND boardGroup <= (SELECT MAX(boardGroup) FROM BOARD) -? ORDER BY boardGroup DESC, boardSequence ASC";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
			pstmt.setInt(2, (Integer.parseInt(pageNumber) -1) * 10);
			rs = pstmt.executeQuery();
			boardList = new ArrayList<BoardDTO>();
			while(rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 11));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardLike(rs.getInt("boardLike"));
				boardList.add(board);
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
		return boardList;
	}
	
	/* 최신 게시글 5개의 정보를 가져오는 함수 */
	public ArrayList<BoardDTO> getRecentList() {
		ArrayList<BoardDTO> boardList = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM BOARD WHERE boardGroup > (SELECT MAX(boardGroup) FROM BOARD) -? ORDER BY boardGroup DESC, boardSequence ASC";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, 5);
			rs = pstmt.executeQuery();
			boardList = new ArrayList<BoardDTO>();
			while(rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 11));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardLike(rs.getInt("boardLike"));
				boardList.add(board);
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
		return boardList;
	}
	
	/* 실시간 인기 게시글 정보를 가져오는 함수 */
	public ArrayList<BoardDTO> getPopularList() {
		ArrayList<BoardDTO> boardList = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM BOARD WHERE boardLike >= 3 ORDER BY boardGroup DESC, boardSequence ASC";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			//pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
			rs = pstmt.executeQuery();
			boardList = new ArrayList<BoardDTO>();
			while(rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 11));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardLike(rs.getInt("boardLike"));
				boardList.add(board);
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
		return boardList;
	}
	
	/* 해당 게시물의 댓글들을 ArrayList로 가져오는 함수 */
	public ArrayList<CommentDTO> getCommentList(String boardID) {
		ArrayList<CommentDTO> commentList = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM COMMENT WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			commentList = new ArrayList<CommentDTO>();
			while(rs.next()) {
				CommentDTO comment = new CommentDTO();
				comment.setCommentID(rs.getInt("commentID"));
				comment.setBoardID(rs.getInt("BoardID"));
				comment.setContent(rs.getString("content"));
				comment.setContentDate(rs.getString("contentDate").substring(0, 19));
				comment.setUserID(rs.getString("userID"));
				commentList.add(comment);
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
		return commentList;
	}
	
	/* 조회수 증가 함수 */
	public int hit(String boardID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE BOARD SET boardHit = boardHit + 1 WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
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
	
	/* 좋아요 개수 가져오는 함수 */
	public int getLike(String boardID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT boardLike FROM BOARD WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("boardLike");
			}
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
	
	/* 좋아요 증가 함수 */
	public int likeUpdate(String boardID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "UPDATE BOARD SET boardLike = boardLike + 1 WHERE boardID = ? ";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
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
	
	/* 다음 페이지가 존재하는지 여부에 대한 함수 (페이징 처리를 이전/다음 버튼 으로만 처리할 경우 사용하는 함수) */
	public Boolean nextPage(String pageNumber) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM BOARD WHERE boardGroup >= ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
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
		return false;
	}
	
	/* 앞으로 처리할 게시물의 페이지 개수 (다중 페이지 처리를 위한 함수) */
	public int targetPage(String pageNumber) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT COUNT(boardGroup) FROM BOARD WHERE boardGroup > ?"; // pageNumber = 1 일때 : 모든 게시물의 개수 반환, pageNumber = 2 일때, 모든게시물-10개 반환 . . . 
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (Integer.parseInt(pageNumber) -1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) / 10; // 앞으로 처리할 페이지 개수 
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
		return -1;
	}
	
	public String getFile(String boardID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT boardFile FROM BOARD WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString("boardFile");
			}
			return "";
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
		return "";
	}
	
	public String getRealFile(String boardID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT boardRealFile FROM BOARD WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString("boardRealFile");
			}
			return "";
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
		return "";
	}
	
	/* 게시글 수정 함수 */
	public int update(String boardID, String boardTitle, String boardContent, String boardFile, String boardRealFile) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE BOARD SET boardTitle = ?, boardContent = ?, boardFile = ?, boardRealFile = ? WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardTitle);
			pstmt.setString(2, boardContent);
			pstmt.setString(3, boardFile);
			pstmt.setString(4, boardRealFile);
			pstmt.setInt(5, Integer.parseInt(boardID));
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
	
	/* 게시글 삭제 함수 */
	public int delete(String boardID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "DELETE FROM BOARD WHERE boardID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(boardID));
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
	
	/* 게시글 댓글 삭제 함수 */
	public int deleteComment(String commentID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "DELETE FROM COMMENT WHERE commentID = ?";
		try {
			conn = dataSource.getConnection(); // 실질적으로 커넥션풀에 접근하게 해줌 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(commentID));
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