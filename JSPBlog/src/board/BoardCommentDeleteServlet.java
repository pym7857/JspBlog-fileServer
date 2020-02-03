package board;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BoardCommentDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/* JSP 페이지를 통하지 않고 서블릿에서 바로 작업을 수행하는 삭제의 경우, URL매핑으로 이동하는것이기 때문에 GET 메서드를 만들어주어야 한다.*/
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost (request, response);
	}
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		HttpSession session = request.getSession();
		String userID = (String) session.getAttribute("userID"); 	//String userID = request.getParameter("userID");
		
		String commentID = request.getParameter("commentID");
		
		BoardDAO boardDAO = new BoardDAO();
		CommentDTO comment = boardDAO.getComment(commentID);
		
		//System.out.println(userID + " " + comment.getUserID() + " " + commentID);
		
		if(!userID.equals(comment.getUserID())) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "userID 오류");
			response.sendRedirect("index.jsp");
			return;
		}
		
		/* 모든 예외를 통과한 후에 */
		int result = boardDAO.deleteComment(commentID); // 삭제
		if(result == -1) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "삭제할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		else {
			request.getSession().setAttribute("messageType", "성공 메세지");
			request.getSession().setAttribute("messageContent", "삭제에 성공했습니다.");
			response.sendRedirect("boardView.jsp");
		}
	}

}