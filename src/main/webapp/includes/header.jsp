<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header class="topbar">
    <h4>${pageTitle != null ? pageTitle : 'StoreTrack'}</h4>
    <div class="user-info">
        <i class="bi bi-person-circle"></i>
        <span>${sessionScope.userName}</span>
        <span class="badge
            <c:choose>
                <c:when test="${sessionScope.role == 'ADMIN'}">bg-primary</c:when>
                <c:when test="${sessionScope.role == 'CASHIER'}">bg-success</c:when>
                <c:otherwise>bg-warning text-dark</c:otherwise>
            </c:choose>">
            ${sessionScope.role}
        </span>
    </div>
</header>
