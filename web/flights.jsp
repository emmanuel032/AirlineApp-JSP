<%-- 
    Return results of flight search (searchflights.html)
--%>

<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.montgomeryhatch.SessionVars"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/styles.css" type="text/css" rel="stylesheet" />
        <title>Flights</title>
    </head>
    <body>
        <h1>Search results</h1>
        <!-- JSP code -->
        <%
            // db vars
            Connection conn = null;
            Statement sqlStatement = null;
            ResultSet result = null;

            // form vars
            String inputDate = request.getParameter("traveldate");

            try {
                // load driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // connect to db
                conn = DriverManager.getConnection(SessionVars.db, 
                        SessionVars.user, SessionVars.password);

                // prepare statement
                String sql = "select * from flights where departuredate = " 
                        + "'" + inputDate + "'";
                sqlStatement = conn.createStatement();
                
                // execute statement
                result = sqlStatement.executeQuery(sql);

                // display records
                String tableHeader = "<table><tr>"
                        + "<th>Flight ID</th>"
                        + "<th>Flight Code</th>"
                        + "<th>Origin</th>"
                        + "<th>Destination</th>"
                        + "<th>Date</th>"
                        + "<th>Departure</th>"
                        + "<th>Arrival</th>"
                        + "<th>Fare</th>"
                        + "</tr>";
                String allRecords = "";
                NumberFormat cf = NumberFormat.getCurrencyInstance();
                DateFormat df = new SimpleDateFormat("MM-dd-YYYY");
                boolean found = false;
                while (result.next()) {
                    found = true;
                    allRecords = allRecords + "<tr>";
                    allRecords = allRecords + "<td>" + result.getInt(1) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(2) + " ";
                    allRecords = allRecords + result.getString(3) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(7) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(8) + "</td>";
                    allRecords = allRecords + "<td>" + df.format(result.getDate(11)) + "</td>";
                    allRecords = allRecords + "<td>"+ result.getString(9) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(10) + "</td>";
                    allRecords = allRecords + "<td>" + cf.format(result.getDouble(13)) + "</td>";
                    allRecords = allRecords + "</tr>";
                }
                if (found == false) {
                    out.println("No flights found");
                } else {
                    out.println(tableHeader + allRecords + "</table>");
                }   

            } catch (Exception e) {
                out.println("Error: " + e);
            }
        %>
        <br>
        <a href='staticpages/reservations.html'>Make reservation</a>
    </body>
</html>
