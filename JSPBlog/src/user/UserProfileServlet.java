package user;

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

@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		// cos.jar 을 이용하여 파일업로드 환경설정 (MultipartRequest 이용)
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/"); // upload라는 폴더 직접 가서 만들어줘야됨  (C:\Users\pym78\Documents\GitHub\javaAjaxChat\JspAjax\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\UserChat)
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "파일 크기는 10MB를 넘을 수 없습니다.");
			response.sendRedirect("profileUpdate.jsp");
			return;
		}
		// 본인이 아니면 접근 할 수 없도록 설정
		String userID = multi.getParameter("userID");
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		// 업로드 할 수 있는 확장자 설정
		String fileName = "";
		File file = multi.getFile("userProfile"); // profileUpdate.jsp에서 받아온 사진을 file 에 저장 
		if(file != null) {
			String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1); // 확장자 처리부분
			if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif")) {
				String prev = new UserDAO().getUser(userID).getUserProfile(); // 이전 프로필 사진
				File prevFile = new File(savePath + "/" + prev);
				if(prevFile.exists()) {
					prevFile.delete();
				}
				fileName = file.getName();
			} else { // 지정된 확장자가 아닌경우에 
				if(file.exists()) { // 받아온 파일 삭제
					file.delete();
				}
				request.getSession().setAttribute("messageType", "오류 메세지");
				request.getSession().setAttribute("messageContent", "이미지 파일만 업로드 가능합니다.");
				response.sendRedirect("profileUpdate.jsp");
				return;
			}
		}
		new UserDAO().profile(userID, fileName); // 실제 db에 업데이트 해주는 쿼리
		request.getSession().setAttribute("messageType", "성공 메세지");
		request.getSession().setAttribute("messageContent", "이미지 변경 완료!");
		response.sendRedirect("index.jsp");
		return;
	}

}