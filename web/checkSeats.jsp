<%@page import="com.montgomeryhatch.SessionVars"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
    // read flightID, ClassCode, number of seats
    int flightID = Integer.parseInt(request.getParameter("fid"));
    String classCode = request.getParameter("cl");
    int numSeats = Integer.parseInt(request.getParameter("num"));
    
    // db vars
    Connection conn = null;
    Statement sqlStatement = null;
    ResultSet result = null;

    try {
        // load driver
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // connect to db
        conn = DriverManager.getConnection(SessionVars.db, 
                SessionVars.user, SessionVars.password);

        // prepare statement
        String sql = "select economyseats, firstclassseats from flights "
                + "where flightid = " + flightID;
        sqlStatement = conn.createStatement();

        // execute statement
        result = sqlStatement.executeQuery(sql);
        result.next();

        // get num of seats on flight
        int avail;
        if (classCode.equalsIgnoreCase("ECO"))
            avail = result.getInt("EconomySeats");
        else
            avail = result.getInt("FirstClassSeats");
        
        // check if requested seats available
        if (numSeats <= avail)
            out.println("");
        else
            out.println("The seats you have requested are not available");
            
    } catch (Exception e) {
        out.println("Error: " + e);
    }
%>
