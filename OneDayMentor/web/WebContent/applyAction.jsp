<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="apply.ApplyDAO"%>
<%@ page import="apply.Apply" %>
<%@ page import="category.CategoryDAO" %>
<%@ page import="category.Category" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>

<!-- 자바 클래스 사용 -->
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8"); //set으로쓰는습관들이세오.
%>

<!-- 한명의 회원정보를 담는 bbs클래스를 자바 빈즈로 사용 / scope:페이지 현재의 페이지에서만 사용-->
<jsp:useBean id="apply" class="apply.Apply" scope="page" />
<jsp:setProperty name="apply" property="applyID" />
<jsp:setProperty name="apply" property="bbsID" />
<jsp:setProperty name="apply" property="categoryID" />
<jsp:setProperty name="apply" property="menteeID" />
<jsp:setProperty name="apply" property="mentorID" />
<jsp:setProperty name="apply" property="writingTitle" />
<jsp:setProperty name="apply" property="writingContent" />
<jsp:setProperty name="apply" property="applyAvailable" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {//유저아이디이름으로 세션이 존재하는 회원들은 
			userID = (String) session.getAttribute("userID");//유저아이디에 해당 세션값을 넣어준다.
		}

		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");

		} else { //로그인 되어있을 때
			
			
			if (apply.getWritingTitle() == null || apply.getWritingContent() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다')");
				script.println("history.back()");
				script.println("</script>");

			} else {
				ApplyDAO ApplyDAO = new ApplyDAO();
				Bbs bbs = new BbsDAO().getBbs(apply.getBbsID());
				CategoryDAO CategoryDAO = new CategoryDAO();
				
				String menteeID = request.getParameter("menteeID");
				int result = ApplyDAO.apply(apply.getBbsID(), bbs.getCategoryID(), menteeID, (String)session.getAttribute("userID"), apply.getWritingTitle(),
						apply.getWritingContent(), apply.getApplyAvailable());
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");

				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('지원이 완료되었습니다.')");
					script.println("location.href='bbs_"+CategoryDAO.getCategoryName(bbs.getCategoryID())+".jsp'");
					script.println("</script>"); 

				}
			}
		}
	%>
</body>
</html>