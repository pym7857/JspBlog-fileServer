package file;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class FileDAO {
	
	DataSource dataSource;
	
	public FileDAO() { 
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/pym7857");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int upload(String fileName, String fileRealName, String fileType, String fileSize, String uploadUserID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO file VALUES (?, ?, 0, now(), ?, ?, ?)";
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fileName);
			pstmt.setString(2, fileRealName);
			pstmt.setString(3, fileType);
			pstmt.setString(4, fileSize);
			pstmt.setString(5, uploadUserID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; 
	}
	
	// 자동으로 다운로드 횟수 증가 
	public int hit(String fileRealName) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE file SET downloadCount = downloadCount + 1 WHERE fileRealName = ?"; // update SQL오류시 : MySQL: Edit-preference-SQLEditor-Other-Safe Updates 해제 !
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fileRealName);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; 
	} // 디비를 껐다켜도, 서버를 껐다켜도, 컴퓨터를 껐다켜도, 계속 콘솔창에 SQL UPDATE 문법오류 떠서 count가 도저히 안올라 가지다가..... SQL문을 프린트로 찍어보니까 오류없어짐 (도무지 알수없고 이해할 수 없는 이클립스 오류)
		// 정확히 이클립스에서 계속해서 어이없게 찍었던 SQL문법오류: 'fileName='ryan.jpg'' at line 1
		// 그래서 ? 주변에 '' 처리 했더니, ''찍어서 생기는 다른 오류뜸. 다시 원래대로 돌려놓았음. (이러한 어이없는 오류떄문에, 도무지 원인을 알 수 없어서, 최소 3시간 이상 허비.. 이클립스 말고 인텔리제이 합시다)
	
	/* FILE 데이터베이스 정보 가져오기 */
	public ArrayList<FileDTO> getList() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM file";
		ArrayList<FileDTO> list = new ArrayList<FileDTO>();
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); // 쿼리문의 결과가 rs에 담긴다 
			while(rs.next()) {
				FileDTO file = new FileDTO(rs.getString(1), rs.getString(2), rs.getInt(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7));
				list.add(file);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return list;
	}
	
	/* 해당 파일 삭제 */
	public int deleteFile(String fileName) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "DELETE FROM file WHERE fileRealName = ?"; // fileName이 아니라, fileRealName으로 해주어야 정상작동 !
		try {
			conn = dataSource.getConnection(); 
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fileName);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; 
	}
	
}
