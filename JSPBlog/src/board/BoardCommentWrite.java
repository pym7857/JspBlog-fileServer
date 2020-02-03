package board;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/boardCommentWrite") 
public class BoardCommentWrite extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		HttpSession session = request.getSession();
		
		
		String boardID = request.getParameter("boardID");
		if(boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "boardID 오류");
			System.out.println(boardID);
			response.sendRedirect("index.jsp");
			return;
		}
		
		String content = request.getParameter("content");
		if(content == null || content.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "content 오류");
			System.out.println(content);
			response.sendRedirect("index.jsp");
			return;
		}
		String userID = (String) session.getAttribute("userID"); // 세션 (현재 로그인된)
		
		BoardDAO boardDAO = new BoardDAO();
		boardDAO.commentWrite(boardID, content, userID); // 실제로 댓글을 쓰는 함수 
		session.setAttribute("messageType", "성공 메세지");
		session.setAttribute("messageContent", "성공적으로 댓글이 등록되었습니다.");
		response.sendRedirect("boardShow.jsp?boardID=" + boardID);
		return;
	}

}