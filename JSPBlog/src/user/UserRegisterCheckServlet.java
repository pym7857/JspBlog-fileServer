package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserRegisterCheckServlet") // 사용자에게 중복체크결과를 반환해주는 서블릿
public class UserRegisterCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	/**
	 * doPost 란?
	 * : Post방식으로 클라이언트에게 어떠한 것을 받았을때, 처리해주는 함수
	 * */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		String userID = request.getParameter("userID");
		
		// 예외처리
		if(userID == null || userID.equals("") || userID.equals("admin"))
			response.getWriter().write("-1");
		response.getWriter().write(new UserDAO().registerCheck(userID) + ""); // 문자열형태로 출력해주기위해 ""(공백) 추가
	}

}