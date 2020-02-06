package file;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/deleteThisFile")
public class deleteThisFile extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String fileName = request.getParameter("file"); // url의 parameter에서 file=? 부분 
		System.out.println(fileName);
		if (fileName != null) {
			if(new FileDAO().deleteFile(fileName) == 1) {
				request.getSession().setAttribute("messageType", "성공 메세지");
				request.getSession().setAttribute("messageContent", "성공적으로 파일이 삭제 되었습니다.");
				response.sendRedirect("fileShare.jsp");
			} else {
				request.getSession().setAttribute("messageType", "오류 메세지");
				request.getSession().setAttribute("messageContent", "??");
				response.sendRedirect("fileShare.jsp");
			}
			
		} else {
			request.getSession().setAttribute("messageType", "오류  메세지");
			request.getSession().setAttribute("messageContent", "파일 삭제 실패");
			response.sendRedirect("fileShare.jsp");
		}
		
	}
	
}
