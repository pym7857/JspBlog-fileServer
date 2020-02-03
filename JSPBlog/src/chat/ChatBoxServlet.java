package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import user.UserDAO;

@WebServlet("/ChatBoxServlet")
public class ChatBoxServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
			
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String userID = request.getParameter("userID");
		
		if(userID == null || userID.equals("")) {
			response.getWriter().write("");
		} else {
			try {
				/* 본인이 아닌경우에는 채팅박스 볼 수 없도록 */
				HttpSession session = request.getSession();
				if(!URLDecoder.decode(userID, "UTF-8").equals((String) session.getAttribute("userID"))) {
					response.getWriter().write("");
					return;
				}
				
				userID = URLDecoder.decode(userID, "UTF-8");
				response.getWriter().write(getBox(userID)); // getBox()
			} catch (Exception e) {
				response.getWriter().write("");
			}
		}
	}
	
	public String getBox(String userID) {

		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getBox(userID); // chatDAO.getBox()
		
		if(chatList.size() == 0) return "";
		
		JSONObject obj = new JSONObject();
		JSONArray arr = new JSONArray();
		
		for(int i = chatList.size() - 1; i>=0 ; i--) { // 내림차순 정렬
			
			String unread = "";
			String userProfile ="";
			
			// 안읽씹 메세지 갯수
			int getUnread = chatDAO.getUnreadChat(chatList.get(i).getFromID(), userID);
			
			// unread 라벨 설정 
			if(userID.equals(chatList.get(i).getToID())) { // 메세지받는 사람이 자기자신 이라면 
				unread = Integer.toString(getUnread); // unread label을 설정해주기위한 unread 변수 설정
				if(unread.equals("0")) unread = ""; // 안읽은게 없으면 비워주기
			}
			// 메세지함 프로필 사진 설정
			if(userID.equals(chatList.get(i).getToID())) { // 메세지 받는 사람이 자기자신 이라면
				userProfile = new UserDAO().getProfile(chatList.get(i).getFromID()); // 메세지 보낸 사람의 프로필 사진
			}
			else {
				userProfile = new UserDAO().getProfile(chatList.get(i).getToID());
			}
			
			JSONArray arr2 = new JSONArray();
			JSONObject obj2 = new JSONObject();
			
			obj2.put("value1", chatList.get(i).getFromID());
			obj2.put("value2", chatList.get(i).getToID());
			obj2.put("value3", chatList.get(i).getChatContent());
			obj2.put("value4", chatList.get(i).getChatTime());
			obj2.put("value5", unread);
			obj2.put("value6", userProfile);
			arr2.add(obj2);
			
			
			/*
			arr2.add(new JSONObject().put("value1", chatList.get(i).getFromID()));
			arr2.add(new JSONObject().put("value2", chatList.get(i).getToID()));
			arr2.add(new JSONObject().put("value3", chatList.get(i).getChatContent()));
			arr2.add(new JSONObject().put("value4", chatList.get(i).getChatTime()));
				▶ console 결과 : {"result":[[null,null,null,null],[null,null,null,null]],"last":5} 
			*/
			
			arr.add(arr2); 
		}
		obj.put("result", arr);
		obj.put("last", chatList.get(chatList.size() - 1).getChatID());
		return obj.toJSONString();
	}

}