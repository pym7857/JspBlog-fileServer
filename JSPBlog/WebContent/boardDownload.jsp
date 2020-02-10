<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<!-- 천하제일 타자 대회 -->

<!DOCTYPE html> 
<html>
<head>
	<meta charset="UTF-8">
	<title>JSP Ajax 실시간 회원제 채팅 서비스</title>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
		String boardID = request.getParameter("boardID");
		
		if(boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "접근할 수 없습니다."); 
			response.sendRedirect("index.jsp");	
			return;
		}
		
		
		//String root = request.getSession().getServletContext().getRealPath("/");
		//String savePath = root + "upload"; // 만들었던 upload 폴더에 접근
		String savePath = "/pym7857/tomcat/webapps/file/";
		String fileName = "";
		String realFile = "";
		BoardDAO boardDAO = new BoardDAO();
		fileName = boardDAO.getFile(boardID);
		realFile = boardDAO.getRealFile(boardID);
		
		if(fileName.equals("") || realFile.equals("")) {
			session.setAttribute("messageType", "오류 메세지");
			session.setAttribute("messageContent", "접근할 수 없습니다."); 
			response.sendRedirect("index.jsp");	
			return;
		}
		
		InputStream in = null;
		OutputStream os = null;
		File file = null;
		boolean skip = false;
		String client = "";
		
		try {
			try {
				file = new File(savePath, realFile);
				in = new FileInputStream(file);
			} catch (FileNotFoundException e){
				skip = true;
			}
			client = request.getHeader("User-Agent");
			response.reset();
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Description", "JSP Generated Data");
			if(!skip) {
				if(client.indexOf("MSIE") != -1) {
					response.setHeader("Content-Disposition", "attachment; filename =" + new String(fileName.getBytes("KSC5601"), "ISO8859_1"));
				}
				else {
					fileName = new String(fileName.getBytes("UTF-8"), "iso-8859-1");
					response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
					response.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
				}
				response.setHeader("Content-Length", "" + file.length());
				os = response.getOutputStream();
				byte b[] = new byte[(int)file.length()];
				int len = 0;
				while((len = in.read(b)) > 0) {
					os.write(b, 0, len);
				}
			}
			else {
				response.setContentType("text/html; charset=UTF-8");
				out.println("<script> alert('파일을 찾을 수 없습니다.'); history.back();</script>");
			}
			in.close();
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
</body>
</html>