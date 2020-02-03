<html>
<head>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, javax.naming.InitialContext, javax.naming.Context" %>
</head>
<body>
	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
	 	try {
			String url = "jdbc:mysql://localhost:3306/JSPBlog?serverTimezone=UTC";
			String dbUser = "root";
			String dbPass = "1562";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(url, dbUser, dbPass);
			String sql = "SELECT VERSION();";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				out.println("MySQL Version: " + rs.getString("version()"));
			}
	 	} catch (Exception e) {
			System.out.println(e);
		}
	%>
</body>
</html>