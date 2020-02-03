package file;

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

public class uploadActionServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String directory = "C:/JSP/upload/";
		int maxSize = 1024 * 1024 * 100; // 100MB 까지만 업로드
		String encoding = "UTF-8";
		
		// 파일 업로드 객체 생성
		MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
		
		String fileName = multipartRequest.getOriginalFileName("file"); // fileShare.jsp에서 input name="file"이었음
		String fileRealName = multipartRequest.getFilesystemName("file"); 
		
		// 확장자 예외처리 
		if (fileName.endsWith(".doc") || fileName.endsWith(".hwp") || fileName.endsWith(".pdf") || fileName.endsWith(".xls") ||
				fileName.endsWith(".jpg") || fileName.endsWith(".png") || fileName.endsWith(".jpeg") || fileName.endsWith(".gif")) {
			new FileDAO().upload(fileName, fileRealName);
			request.getSession().setAttribute("messageType", "성공 메세지");
			request.getSession().setAttribute("messageContent", "성공적으로 파일이 업로드 되었습니다.");
			response.sendRedirect("fileShare.jsp");
		} else {
			File file = new File(directory + fileRealName);
			file.delete();
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "업로할 수 없는 확장자 입니다.");
			response.sendRedirect("fileShare.jsp");
		}
	}
	
}
