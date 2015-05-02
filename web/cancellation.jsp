<%-- 
    Delete reservation from Reservations, Passengers, and Reservation_Lines
    Return available seats
--%>

<%@page import="com.montgomeryhatch.SessionVars"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/styles.css" type="text/css" rel="stylesheet" />
        <title>Cancellation</title>
    </head>
    <body>
        <!-- JSP code -->
        <%
            // db vars
            Connection conn = null;
            CallableStatement cancelStmt = null;
            int resID = Integer.parseInt(request.getParameter("resid"));

            try {
                // load driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // connect to db
                conn = DriverManager.getConnection(SessionVars.db, 
                        SessionVars.user, SessionVars.password);

                // prepare statement
                cancelStmt = conn.prepareCall("{call delete_reservation(?)}");
                cancelStmt.setInt(1, resID);
                
                // execute statement
                cancelStmt.execute();
                
            } catch (Exception e) {
                out.println("Error: " + e);
            }
        %>
        <h2>Your reservation has been canceled.</h2>
        <ul>
            <li><a href="home.jsp">Return Home</a></li>
            <li><a href="searchflights.html">New search</a></li>
        </ul>
    </body>
</html>
