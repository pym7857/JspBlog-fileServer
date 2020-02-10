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

@WebServlet("/downloadAction")
public class downloadAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String fileName = request.getParameter("file"); // url의 parameter에서 file=? 부분 
		//System.out.println('1' + fileName);
		
		//String directory = this.getServletContext().getRealPath("/upload/");
		String directory = "/pym7857/tomcat/webapps/file/";
		File file = new File(directory + "/" + fileName);
		
		String mimeType = getServletContext().getMimeType(file.toString()); // mimeType을 통해 file데이터 라는것을 알려줌 
		if (mimeType == null) {
			response.setContentType("application/octet-stream"); // 이진 파일을 전송할때 octet-stream사용. 사용자 입장에서 받을 Type이 File임을 response로 알게해줌  
		}
		
		String downloadName = null;
		if (request.getHeader("user-agent").indexOf("MSIE") == -1) { // 브라우저가 IE가 아니라면 
			downloadName = new String(fileName.getBytes("UTF-8"), "8859_1"); // UTF-8 방식으로 얻어서, 8859_1형식으로 바꿔서 파일이 깨지지않게 처리해준다
		} else {
			downloadName = new String(fileName.getBytes("EUC-KR"), "8859_1");
		}
		
		// Header 설정 
		response.setHeader("Content-Disposition", "attachment;filename=\""
				+ downloadName + "\";");
		
		FileInputStream fileInputStream = new FileInputStream(file);
		ServletOutputStream servletOutputStream = response.getOutputStream();
		
		// 실제로 데이터를 전송할때는 byte단위로 쪼개서 전송 
		byte b[] = new byte[1024]; // 1024바이트 단위로 쪼개서 보내도록 설정 
		int data = 0;
		
		while ((data = (fileInputStream.read(b, 0, b.length))) != -1) { // fis이 1024씩 만큼  반복적으로 읽게해서..
			servletOutputStream.write(b, 0, data); // 1024만큼 data를 계속해서 보내도록 만듦 
		}
		
		// 파일 다운로드된 후에 다운로드 횟수 증가
		new FileDAO().hit(fileName); // 애초에 url파라미터로 RealName을 보냈기 때문에, 여기서 fileName변수는 fileRealName과 동일하다.
		
		// 데이터를 다 보낸 이후에..
		servletOutputStream.flush();
		servletOutputStream.close();
		fileInputStream.close();
	}
	
}
