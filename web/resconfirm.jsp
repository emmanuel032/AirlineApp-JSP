<%-- 
    insert reservation data into 
    Reservations, Passengers, and Reservation_Lines tables
--%>

<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
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
        <title>Confirmation</title>
    </head>
    <body>
        <!-- JSP code -->
        <%
            // db vars
            Connection conn = null;
            CallableStatement resStmt = null;
            CallableStatement lineStmt = null;
            CallableStatement passStmt = null;
            
            // reservation vars
            int flightID = Integer.parseInt(request.getParameter("fid"));
            String inCl = request.getParameter("clss");
            int numPass = Integer.parseInt(request.getParameter("numpass"));
            int resID = -1;

            try {
                // load driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // connect to db
                conn = DriverManager.getConnection(SessionVars.db, 
                        SessionVars.user, SessionVars.password);
                
            } catch (Exception e) {
                out.println("Error: " + e);
            }
            
            // insert reservation
            try {
                resStmt = conn.prepareCall("{"
                        + "call insert_reservation(?,?)}");
                resStmt.setInt(1,SessionVars.custID);
                resStmt.registerOutParameter(2, java.sql.Types.NUMERIC);
                
                // execute statement
                resStmt.execute();
                resID = resStmt.getInt(2);
                
            } catch (Exception e) {
                out.println("Error: " + e);
            }
            
            // insert passengers/reservation lines
            String[] inputName = {"fname", "lname", "gender", "dob", "phone", 
                "email", "seat"};
            String[] params = new String[inputName.length];
            int passID;
            DateFormat df = new SimpleDateFormat("MM-dd-YYYY");
            java.util.Date javaDate;
            java.sql.Date inputDOB;
            
            for (int i = 1; i < numPass+1; i++) {
                // set input variables
                for (int j = 0; j < inputName.length; j++) {
                        params[j] = inputName[j] + i;
                }
 
                passID = -1;
                javaDate = df.parse(request.getParameter(params[3]));
                inputDOB = new Date(javaDate.getTime());
                
                // insert passenger row
                try {
                    passStmt = conn.prepareCall("{"
                            + "call insert_passenger(?,?,?,?,?,?,?)}");
                    passStmt.setString(1,request.getParameter(params[0]));
                    passStmt.setString(2,request.getParameter(params[1]));
                    passStmt.setString(3,request.getParameter(params[2]));
                    passStmt.setDate(4, inputDOB);
                    passStmt.setString(5,request.getParameter(params[4]));
                    passStmt.setString(6,request.getParameter(params[5]));
                    passStmt.registerOutParameter(7, java.sql.Types.NUMERIC);

                    // execute statement
                    passStmt.execute();
                    passID = passStmt.getInt(7);

                } catch (Exception e) {
                    out.println("Error: " + e);
                }

                // insert reservation line row
                try {
                    lineStmt = conn.prepareCall("{"
                            + "call insert_res_line(?,?,?,?,?)}");
                    lineStmt.setInt(1, resID);
                    lineStmt.setInt(2, passID);
                    lineStmt.setInt(3, flightID);
                    lineStmt.setString(4,inCl);
                    lineStmt.setString(5,request.getParameter(params[6]));

                    // execute statement
                    lineStmt.execute();

                } catch (Exception e) {
                    out.println("Error: " + e);
                }    
            } // end for loop
        %>
        
        <h2>Your reservation has been confirmed!</h2>
        <ul>
            <li><a href="searchflights.html">New search</a></li>
            <li><a href="home.jsp">View reservations</a></li>
        </ul>
    </body>
</html>
