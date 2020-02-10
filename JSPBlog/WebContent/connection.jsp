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
			String url = "jdbc:mariadb://localhost/pym7857?serverTimezone=UTC";
			String dbUser = "pym7857";
			String dbPass = "pym7857!";
			Class.forName("org.mariadb.jdbc.Driver");
			conn = DriverManager.getConnection(url, dbUser, dbPass);
			String sql = "SELECT VERSION();";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				out.println("MariaDB Version: " + rs.getString("version()"));
			}
	 	} catch (Exception e) {
			System.out.println(e);
		}
	%>
</body>
</html>