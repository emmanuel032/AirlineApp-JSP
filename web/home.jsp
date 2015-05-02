<%-- 
    Display customer reservations
--%>

<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
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
        <title>Customer Home</title>
    </head>
    <body>
        <%
            // db vars
            Connection conn = null;
            Statement selectName = null;
            Statement selectRes = null;
            ResultSet resultName = null;
            ResultSet resultRes = null;

            try {
                // load driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // connect to db
                conn = DriverManager.getConnection(SessionVars.db, 
                        SessionVars.user, SessionVars.password);
                
                // get customer name
                String qName = "select custfname from customers "
                        + "where custid = " + SessionVars.custID;
                selectName = conn.createStatement();
                
                // execute statement
                resultName = selectName.executeQuery(qName);

                // display name
                resultName.next();
                String name = resultName.getString(1);
                out.println("<h1>Welcome &nbsp;" + name + "!</h1>");
                
            } catch (Exception e) {
                out.println("Error: " + e);
            }
            
            try {
                // get customer reservations
                String qReservations = "select r.resid, f.departuredate, "
                        + "f.flightname, f.flightcode, f.origin, f.destination, "
                        + "p.passfname, p.passlname, r.resdate, f.fare "
                        + "from reservations r, reservation_lines n, "
                        + "flights f, passengers p "
                        + "where r.resid = n.resid and n.flightid = f.flightid "
                        + "and n.passid = p.passid and r.custid = " 
                        + SessionVars.custID + " order by r.resid";
                selectRes = conn.createStatement();
                
                // execute statement
                resultRes = selectRes.executeQuery(qReservations);

                // display reservations
                out.println("<h3>Reservations</h3>");
                String tableHeader = "<table><tr>"
                        + "<th>Reservation No.</th>"
                        + "<th>Flight Date</th>"
                        + "<th>Flight No.</th>"
                        + "<th>Origin</th>"
                        + "<th>Destination</th>"
                        + "<th>Passenger</th>"
                        + "<th>Reservation Date</th>"
                        + "<th>Fare</th>"
                        + "</tr>";
                String allRecords = "";
                NumberFormat cf = NumberFormat.getCurrencyInstance();
                DateFormat df = new SimpleDateFormat("MM-dd-YYYY");
                boolean found = false;
                while (resultRes.next()) {
                    found = true;
                    allRecords = allRecords + "<tr>";
                    allRecords = allRecords + "<td>" + resultRes.getInt(1) + "</td>";
                    allRecords = allRecords + "<td>" + df.format(resultRes.getDate(2)) + "</td>";
                    allRecords = allRecords + "<td>" + resultRes.getString(3) + " ";
                    allRecords = allRecords + resultRes.getString(4) + "</td>";
                    allRecords = allRecords + "<td>" + resultRes.getString(5) + "</td>";
                    allRecords = allRecords + "<td>" + resultRes.getString(6) + "</td>";
                    allRecords = allRecords + "<td>" + resultRes.getString(7) + " ";
                    allRecords = allRecords + resultRes.getString(8) + "</td>";
                    allRecords = allRecords + "<td>" + df.format(resultRes.getDate(9)) + "</td>";
                    allRecords = allRecords + "<td>" + cf.format(resultRes.getDouble(10)) + "</td>";
                    allRecords = allRecords + "</tr>";
                }
                if (found == false) {
                    out.println("No reservations found<br><br>");
                } else {
                    out.println(tableHeader + allRecords + "</table>");
                }  
                
            } catch (Exception e) {
                out.println("Error: " + e);
            }
        %>
        <div id="cancel">
            <form name="cancel" action="cancellation.jsp">
                <input type="submit" value="Cancel reservation">
                &nbsp;Reservation No.&nbsp;
                <input type="text" name="resid" size="2" required>
            </form>
        </div>
        <a href="searchflights.html">Search for flights</a>
    </body>
</html>
