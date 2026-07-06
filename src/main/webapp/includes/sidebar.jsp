<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="sidebar">
    <div class="sidebar-brand">
        <h5><i class="bi bi-shop me-2"></i>StoreTrack</h5>
        <small>Inventory Manager</small>
    </div>

    <nav class="sidebar-nav">

        <c:if test="${sessionScope.role == 'ADMIN'}">
            <div class="nav-section">Overview</div>
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </c:if>

        <div class="nav-section">Inventory</div>

        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'STOCK_MANAGER'}">
            <a href="${pageContext.request.contextPath}/products">
                <i class="bi bi-box-seam"></i> Products
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/categories">
                <i class="bi bi-tags"></i> Categories
            </a>
            <a href="${pageContext.request.contextPath}/suppliers">
                <i class="bi bi-truck"></i> Suppliers
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'STOCK_MANAGER'}">
            <a href="${pageContext.request.contextPath}/stock">
                <i class="bi bi-arrow-bar-up"></i> Stock Entry
            </a>
        </c:if>

        <div class="nav-section">Sales</div>

        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'CASHIER'}">
            <a href="${pageContext.request.contextPath}/sales/billing">
                <i class="bi bi-receipt"></i> Billing
            </a>
            <a href="${pageContext.request.contextPath}/sales/history">
                <i class="bi bi-clock-history"></i> Sales History
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN'}">
            <div class="nav-section">Administration</div>
            <a href="${pageContext.request.contextPath}/users">
                <i class="bi bi-people"></i> Users
            </a>
        </c:if>

    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </div>
</aside>
