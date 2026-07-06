<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"   prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<%@ include file="/includes/sidebar.jsp" %>

<main class="main-content">
    <c:set var="pageTitle" value="Dashboard" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible">
                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Stat cards row --%>
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="card stat-card">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-box-seam"></i>
                        </div>
                        <div>
                            <div class="stat-label">Total Products</div>
                            <div class="stat-value">${totalProducts}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card stat-card">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-currency-rupee"></i>
                        </div>
                        <div>
                            <div class="stat-label">Today's Revenue</div>
                            <div class="stat-value">
                                ₹<fmt:formatNumber value="${todayRevenue}" pattern="#,##0.00"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card stat-card">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                        <div>
                            <div class="stat-label">Low Stock Items</div>
                            <div class="stat-value">${lowStockList.size()}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="card stat-card">
                    <div class="card-body d-flex align-items-center gap-3">
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-truck"></i>
                        </div>
                        <div>
                            <div class="stat-label">Total Suppliers</div>
                            <div class="stat-value">${totalSuppliers}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-4">

            <%-- Low stock alerts --%>
            <div class="col-lg-5">
                <div class="card h-100">
                    <div class="card-header bg-white border-bottom-0 pt-3">
                        <h6 class="mb-0 fw-semibold text-danger">
                            <i class="bi bi-exclamation-triangle me-1"></i> Low Stock Alerts
                        </h6>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty lowStockList}">
                                <p class="text-muted text-center py-4">All products are well-stocked</p>
                            </c:when>
                            <c:otherwise>
                                <ul class="list-group list-group-flush">
                                    <c:forEach var="p" items="${lowStockList}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center py-2 px-3">
                                            <div>
                                                <div class="fw-medium" style="font-size:.875rem">
                                                    <c:out value="${p.name}"/>
                                                </div>
                                                <small class="text-muted">${p.categoryName}</small>
                                            </div>
                                            <span class="badge-low-stock">
                                                ${p.quantity} / ${p.minQuantity} ${p.unit}
                                            </span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <%-- Top 5 products --%>
            <div class="col-lg-7">
                <div class="card h-100">
                    <div class="card-header bg-white border-bottom-0 pt-3">
                        <h6 class="mb-0 fw-semibold">
                            <i class="bi bi-bar-chart me-1"></i> Top Selling Products
                        </h6>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty topProducts}">
                                <p class="text-muted text-center py-4">No sales data yet</p>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-sm mb-0">
                                    <thead><tr><th>#</th><th>Product</th><th>Units Sold</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="p" items="${topProducts}" varStatus="s">
                                            <tr>
                                                <td>${s.count}</td>
                                                <td><c:out value="${p.name}"/></td>
                                                <td>${p.totalSold}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <%-- Recent transactions --%>
        <div class="card mb-4">
            <div class="card-header bg-white border-bottom-0 pt-3">
                <h6 class="mb-0 fw-semibold">
                    <i class="bi bi-clock-history me-1"></i> Recent Transactions
                </h6>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty recentSales}">
                        <p class="text-muted text-center py-4">No transactions yet</p>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr><th>#</th><th>Date</th><th>Cashier</th><th>Tax</th><th>Total</th><th>Bill</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${recentSales}">
                                    <tr>
                                        <td>${s.id}</td>
                                        <td><fmt:formatDate value="${s.saleDate}" pattern="dd MMM yyyy HH:mm"/></td>
                                        <td><c:out value="${s.cashierName}"/></td>
                                        <td>₹<fmt:formatNumber value="${s.taxAmount}" pattern="#,##0.00"/></td>
                                        <td class="fw-semibold">
                                            ₹<fmt:formatNumber value="${s.totalAmount}" pattern="#,##0.00"/>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/sales/print?id=${s.id}"
                                               class="btn btn-sm btn-outline-secondary" target="_blank">
                                                <i class="bi bi-printer"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- Monthly revenue --%>
        <c:if test="${not empty monthlyRevenue}">
        <div class="card">
            <div class="card-header bg-white border-bottom-0 pt-3">
                <h6 class="mb-0 fw-semibold">
                    <i class="bi bi-calendar3 me-1"></i> Monthly Revenue (Last 6 Months)
                </h6>
            </div>
            <div class="card-body p-0">
                <table class="table table-sm mb-0">
                    <thead><tr><th>Month</th><th>Total Sales</th><th>Revenue</th></tr></thead>
                    <tbody>
                        <c:forEach var="m" items="${monthlyRevenue}">
                            <tr>
                                <td>${m.month}</td>
                                <td>${m.totalSales}</td>
                                <td class="fw-semibold">
                                    ₹<fmt:formatNumber value="${m.revenue}" pattern="#,##0.00"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        </c:if>

    </div>
    <%@ include file="/includes/footer.jsp" %>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
