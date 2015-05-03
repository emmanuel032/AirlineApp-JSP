<%-- 
    Check if username and password match customer
--%>

<%@page import="com.montgomeryhatch.SessionVars"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/styles.css" type="text/css" rel="stylesheet" />
        <title>Validate</title>
    </head>
    <body>
        <%
            // read username and password
            String usr = request.getParameter("usrname");
            String pw = request.getParameter("passwrd");
            
            // db vars
            Connection conn = null;
            Statement validateStmt = null;
            ResultSet result = null;

            try {
                // load driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // connect to db
                conn = DriverManager.getConnection(SessionVars.db, 
                        SessionVars.user, SessionVars.password);

                // prepare statement
                String sql = "select custid from customers where username = '"
                        + usr + "' and password = '" + pw + "'";
                validateStmt = conn.createStatement();

                // execute statement
                result = validateStmt.executeQuery(sql);

                // return admin dashboard, customer home, or error message
                boolean found = false;
                while (result.next()) {
                    found = true;
                    SessionVars.custID = result.getInt(1);

                    if (SessionVars.custID == 1)
                        response.sendRedirect("staticpages/dashboard.html");
                    else
                        response.sendRedirect("home.jsp");
                }

                if (!found)
                    out.println("<h3 class='validation'>Incorrect Username/Password. Please try again.</h3>");

            } catch (Exception e) {
                out.println("Error: " + e);
            }
        %>
        <br>
        <a href="index.html">Back</a>
    </body>
</html>
