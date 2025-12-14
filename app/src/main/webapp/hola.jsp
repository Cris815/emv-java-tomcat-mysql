<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Prueba Hola Mundo</title>
</head>
<body>
<h1>🚀 Hola Mundo JSP con Docker!</h1>

<%
    String dbUrl = "jdbc:mysql://bd-mysql:3306/appdb";
    String dbUser = "appuser";
    String dbPass = "apppass";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM prueba");

        out.println("<h2>Datos desde MySQL:</h2><ul>");
        while(rs.next()) {
            out.println("<li>" + rs.getInt("id") + " - " + rs.getString("mensaje") + "</li>");
        }
        out.println("</ul>");

        rs.close();
        stmt.close();
        conn.close();
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error de conexión: " + e.getMessage() + "</p>");
    }
%>

</body>
</html>