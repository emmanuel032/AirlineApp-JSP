<%-- 
    Return results of flight search (searchflights.html)
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.Connection"%>
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
            String db = "jdbc:oracle:thin:@localhost:1521:orcl";
            String user = "airline_user";
            String password = "password";
            Connection conn = null;
            Statement sqlStatement = null;
            //CallableStatement myStmt = null;
            ResultSet result = null;

            // form vars
            String inputDate = request.getParameter("traveldate");

            try {
                // load driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // connect to db
                conn = DriverManager.getConnection(db, user, password);

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
                boolean found = false;
                NumberFormat f = NumberFormat.getCurrencyInstance();
                while (result.next()) {
                    found = true;
                    allRecords = allRecords + "<tr>";
                    allRecords = allRecords + "<td>" + result.getInt(1) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(2) + " ";
                    allRecords = allRecords + result.getString(3) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(7) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(8) + "</td>";
                    allRecords = allRecords + "<td>" + inputDate + "</td>";
                    allRecords = allRecords + "<td>"+ result.getString(9) + "</td>";
                    allRecords = allRecords + "<td>" + result.getString(10) + "</td>";
                    allRecords = allRecords + "<td>" + f.format(result.getDouble(13)) + "</td>";
                    allRecords = allRecords + "</tr>";
                }
                if (found == false) {
                    out.println("No flights found");
                } else {
                    out.println(tableHeader + allRecords + "</table>");
                    out.println("<a href=''>Make reservation</a>");
                }   

                /*
                // prepare statement
                myStmt = conn.prepareCall("{call search_flights(?)}");
                
                // set parameters
                myStmt.setString(1, inputDate);
                
                // execute statement
                myStmt.execute();
                result = myStmt.getResultSet();
                
                // display results 
                out.println("<p>hello</p>");
                
                out.println(result);
                String allRecords = "";
                boolean found = false;
                while (result.next()) {
                    found = true;
                    String zip = result.getString(1);
                    allRecords = allRecords + zip + "<br>";
                }
                if (found == false) {
                    out.println("No flights found");
                } else {
                    out.println(allRecords);
                }   
                 */
            } catch (Exception e) {
                out.println("Error: " + e);
            }
        %>
    </body>
</html>
