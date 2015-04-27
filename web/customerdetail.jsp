<%-- 
    Insert customer into Customers table
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.montgomeryhatch.SessionVars"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/styles.css" type="text/css" rel="stylesheet" />
        <title>Customer details</title>
    </head>
    <body>
        <h1>Customer details</h1>
        <!-- JSP code -->
        <%
            // db vars
            Connection conn = null;
            CallableStatement myStmt = null;

            // form vars
            String inputUser = request.getParameter("username");
            String inputPw = request.getParameter("password");
            String inputFirst = request.getParameter("fname");
            String inputLast = request.getParameter("lname");
            String inputFather = request.getParameter("father");
            String inputGender = request.getParameter("gender");
            String inputDOB = request.getParameter("dob");
            String inputAddr1 = request.getParameter("addr1");
            String inputAddr2 = request.getParameter("addr2");
            String inputCity = request.getParameter("city");
            String inputState = request.getParameter("state");
            String inputZip = request.getParameter("zip");
            String inputPhone = request.getParameter("phone");
            String inputEmail = request.getParameter("email");
            String inputProf = request.getParameter("prof");
            String inputSecurity = request.getParameter("security");
            String inputConc = request.getParameter("conc");

            try {
                // load driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // connect to db
                conn = DriverManager.getConnection(SessionVars.db, 
                        SessionVars.user, SessionVars.password);

                // prepare statement
                myStmt = conn.prepareCall("{"
                        + "call insert_cust(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");

                // set parameters
                myStmt.setString(1, inputUser);
                myStmt.setString(2, inputPw);
                myStmt.setString(3, inputFirst);
                myStmt.setString(4, inputLast);
                myStmt.setString(5, inputFather);
                myStmt.setString(6, inputGender);
                myStmt.setString(7, inputDOB);
                myStmt.setString(8, inputAddr1);
                myStmt.setString(9, inputAddr2);
                myStmt.setString(10, inputCity);
                myStmt.setString(11, inputState);
                myStmt.setString(12, inputZip);
                myStmt.setString(13, inputPhone);
                myStmt.setString(14, inputEmail);
                myStmt.setString(15, inputProf);
                myStmt.setString(16, inputSecurity);
                myStmt.setString(17, inputConc);

                // execute statement
                myStmt.execute();
                //int id = myStmt.getInt(1);
                int id = 5;
                SessionVars.custID = id;
                
                // display results 
                String custDetail = "<h3>Your account has been created!</h3>"
                        + "<span>Username:</span>" + inputUser + "<br>"
                        + "<span>Password:</span>" + inputPw + "<br>"
                        + "<span>First Name:</span>" + inputFirst + "<br>"
                        + "<span>Last Name:</span>" + inputLast + "<br>"
                        + "<span>Father's Name:</span>" + inputFather + "<br>"
                        + "<span>Gender:</span>" + inputGender + "<br>"
                        + "<span>DOB:</span>" + inputDOB + "<br>"
                        + "<span>Address Line 1:</span>" + inputAddr1 + "<br>"
                        + "<span>Address Line 2:</span>" + inputAddr2 + "<br>"
                        + "<span>City:</span>" + inputCity + "<br>"
                        + "<span>State:</span>" + inputState + "<br>"
                        + "<span>Zip:</span>" + inputZip + "<br>"
                        + "<span>Phone:</span>" + inputPhone + "<br>"
                        + "<span>Email:</span>" + inputEmail + "<br>"
                        + "<span>Profession:</span>" + inputProf + "<br>"
                        + "<span>Security:</span>" + inputSecurity + "<br>";
                String search = "<a href='searchflights.html'>"
                        + "Search for flights</a>";
                out.println("Session id is: "+SessionVars.custID);
                out.println(custDetail);
                out.println(search);

                
            } catch (Exception e) {
                out.println("Error: " + e);
            }
        %>
    </body>
</html>
