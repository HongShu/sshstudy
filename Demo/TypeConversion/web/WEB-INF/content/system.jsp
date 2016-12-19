<%@ taglib prefix="s" uri="/struts-tags" %>
<%--
  Created by IntelliJ IDEA.
  User: hs
  Date: 2016/10/18
  Time: 16:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>System.jsp</title>
</head>
<body>
Environment:<s:property value="environment"></s:property>
<br/>
Operating System:<s:property value="operateSystem"></s:property>
</body>
</html>
