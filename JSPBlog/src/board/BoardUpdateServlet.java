package board;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import user.UserDAO;

public class BoardUpdateServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		// cos.jar 을 이용하여 파일업로드 환경설정 (MultipartRequest 이용)
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = "/pym7857/tomcat/webapps/file/".replaceAll("\\\\", "/"); // upload라는 폴더 직접 가서 만들어줘야됨  (C:\Users\pym78\Documents\GitHub\javaAjaxChat\JspAjax\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\UserChat)
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "파일 크기는 10MB를 넘을 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		// 본인이 아니면 접근 할 수 없도록 설정
		String userID = multi.getParameter("userID");
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		String boardID = multi.getParameter("boardID");
		if(boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(boardID);
		if(!userID.equals(board.getUserID())) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		// 내용을 모두 채우지 않았을시 오류메세지 발생 
		String boardTitle = multi.getParameter("boardTitle");
		String boardContent = multi.getParameter("boardContent");
		if(boardTitle == null || boardTitle.equals("") || boardContent == null || boardContent.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "내용을 모두 채워주세요.");
			response.sendRedirect("boardWrite.jsp");
			return;
		}
		// 서블릿으로 request 받은것들을 실제로 db에 쓰는 부분 (수정)
		String boardFile = "";
		String boardRealFile = "";
		File file = multi.getFile("boardFile");
		
		if(file != null) {  // 파일이 이미 있는경우 
			boardFile = multi.getOriginalFileName("boardFile");
			boardRealFile = file.getName();
			String prev = boardDAO.getRealFile(boardID);
			File prevFile = new File(savePath + "/" + prev); // 이전 파일
			if(prevFile.exists()) { // 이전 파일이 이미 존재한다면
				prevFile.delete(); // 이전 파일 삭제
			}
		}
		else { // 파일을 처음 등록할 경우 
			boardFile = boardDAO.getFile(boardID);
			boardRealFile = boardDAO.getRealFile(boardID);
		}
		boardDAO.update(boardID, boardTitle, boardContent, boardFile, boardRealFile);
		session.setAttribute("messageType", "성공 메세지");
		session.setAttribute("messageContent", "성공적으로 게시글이 수정되었습니다.");
		response.sendRedirect("boardView.jsp");
		return;
	}

}