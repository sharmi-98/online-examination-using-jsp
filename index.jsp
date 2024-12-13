<%@ page language="java" import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    Connection connect = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String SeatNum, Name;
    String ans1, ans2, ans3, ans4, ans5;
    int a1 = 0, a2 = 0, a3 = 0, a4 = 0, a5 = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/OnlineExam", "root", "password");

        if (request.getParameter("action") != null) {
            SeatNum = request.getParameter("Seat_no");
            Name = request.getParameter("Name");

            ans1 = request.getParameter("group1");
            ans2 = request.getParameter("group2");
            ans3 = request.getParameter("group3");
            ans4 = request.getParameter("group4");
            ans5 = request.getParameter("group5");

            // Award marks for correct answers
            a1 = ans1.equals("True") ? 5 : 0;
            a2 = ans2.equals("False") ? 5 : 0;
            a3 = ans3.equals("False") ? 5 : 0;
            a4 = ans4.equals("True") ? 5 : 0;
            a5 = ans5.equals("True") ? 5 : 0;

            int Total = a1 + a2 + a3 + a4 + a5;

            // Insert student record into the database
            String query = "INSERT INTO StudentTable (Seat_no, Name, Marks) VALUES (?, ?, ?)";
            pstmt = connect.prepareStatement(query);
            pstmt.setString(1, SeatNum);
            pstmt.setString(2, Name);
            pstmt.setInt(3, Total);
            pstmt.executeUpdate();

            // Retrieve the student record
            query = "SELECT * FROM StudentTable WHERE Name = ?";
            pstmt = connect.prepareStatement(query);
            pstmt.setString(1, Name);
            rs = pstmt.executeQuery();
%>
<html>
<head>
    <title>Student Mark List</title>
</head>
<body bgcolor="khaki">
    <center>
        <h1>Students Marksheet</h1>
        <h2>JAI SHRIRAM ENGINEERING COLLEGE</h2>
        <table border="1" cellspacing="0" cellpadding="10">
            <tr>
                <th>Seat Number</th>
                <th>Name</th>
                <th>Marks</th>
            </tr>
            <% while (rs.next()) { %>
            <tr>
                <td><%= rs.getString("Seat_no") %></td>
                <td><%= rs.getString("Name") %></td>
                <td><%= rs.getInt("Marks") %></td>
            </tr>
            <% } %>
        </table>
        <p>Date: <%= new Date().toString() %></p>
        <p>Signature: X.Y.Z.</p>
        <a href="OnlineExam.jsp">Click here to go back</a>
    </center>
</body>
</html>
<%
        }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (connect != null) connect.close();
        } catch (Exception ex) {
            out.println("<h3>Error Closing Resources: " + ex.getMessage() + "</h3>");
        }
    }
%>
<% } else { %>
<html>
<head>
    <title>Online Examination</title>
    <script>
        function validation(Form_obj) {
            if (Form_obj.Seat_no.value.length == 0) {
                alert("Please, fill up the Seat Number");
                Form_obj.Seat_no.focus();
                return false;
            }
            if (Form_obj.Name.value.length == 0) {
                alert("Please, fill up the Name");
                Form_obj.Name.focus();
                return false;
            }
            return true;
        }
    </script>
</head>
<body bgcolor="lightgreen">
    <center>
        <h1>Online Examination</h1>
        <form action="OnlineExam.jsp" method="post" name="entry" onsubmit="return validation(this)">
            <input type="hidden" value="list" name="action">
            <hr>
            <table>
                <tr>
                    <td>Seat Number:</td>
                    <td><input type="text" name="Seat_no"></td>
                </tr>
                <tr>
                    <td>Name:</td>
                    <td><input type="text" name="Name"></td>
                </tr>
            </table>
            <hr>
            <b>1. XML enables you to collect information once and reuse it in a variety of ways.</b><br>
            <input type="radio" name="group1" value="True">True
            <input type="radio" name="group1" value="False">False<br><br>

            <b>2. In Modern PCs, there is no cache memory.</b><br>
            <input type="radio" name="group2" value="True">True
            <input type="radio" name="group2" value="False">False<br><br>

            <b>3. JavaScript functions cannot be used to create reusable script fragments.</b><br>
            <input type="radio" name="group3" value="True">True
            <input type="radio" name="group3" value="False">False<br><br>

            <b>4. The DriverManager class is used to open a connection to a database via a JDBC driver.</b><br>
            <input type="radio" name="group4" value="True">True
            <input type="radio" name="group4" value="False">False<br><br>

            <b>5. The JDBC and ODBC do not share a common parent.</b><br>
            <input type="radio" name="group5" value="True">True
            <input type="radio" name="group5" value="False">False<br><br>

            <center>
                <input type="submit" value="Submit">
                <input type="reset" value="Clear">
            </center>
        </form>
    </center>
</body>
</html>
<% } %>