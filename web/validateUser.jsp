<%-- 
    Check if username and password match customer
--%>

<%@page import="com.montgomeryhatch.SessionVars"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
    // read username and password
    String usr = request.getParameter("usr");
    String pw = request.getParameter("pw");
    
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
            out.println("found");
        
            if (SessionVars.custID == 1)
                out.println("redirect admin");
            else
                out.println("redirect home");
        }
        
        if (!found)
            out.println("Incorrect Username and/or Password");
        
    } catch (Exception e) {
        out.println("Error: " + e);
    }
%>