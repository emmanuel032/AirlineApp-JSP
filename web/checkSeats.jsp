<%
    // read flightID, ClassCode, number of seats
    int flightID = Integer.parseInt(request.getParameter("fid"));
    String classCode = request.getParameter("cl");
    int numSeats = Integer.parseInt(request.getParameter("num"));
    
    if (numSeats < 3)
        out.println("available");
    else
        out.println("The seats you have requested are not available");
%>
