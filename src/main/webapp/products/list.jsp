<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Products" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible">
                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible">
                <i class="bi bi-check-circle me-1"></i> <c:out value="${success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible">
                <i class="bi bi-check-circle me-1"></i> <c:out value="${param.success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-semibold mb-0">All Products</h5>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/products?action=add"
                   class="btn btn-brand btn-sm">
                    <i class="bi bi-plus-lg me-1"></i> Add Product
                </a>
            </c:if>
        </div>

        <form class="d-flex gap-2 mb-3" method="get" action="${pageContext.request.contextPath}/products">
            <input type="text" class="form-control form-control-sm" style="max-width:280px"
                   name="search" placeholder="Search by name or category..."
                   value="<c:out value="${search}"/>">
            <button class="btn btn-sm btn-outline-secondary" type="submit">
                <i class="bi bi-search"></i>
            </button>
            <c:if test="${not empty search}">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-sm btn-outline-secondary">Clear</a>
            </c:if>
        </form>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Buying</th>
                            <th>Selling</th>
                            <th>Stock</th>
                            <th>Unit</th>
                            <c:if test="${sessionScope.role == 'ADMIN'}"><th>Actions</th></c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty products}">
                                <tr><td colspan="8" class="text-center text-muted py-4">No products found</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${products}" varStatus="s">
                                    <tr>
                                        <td class="text-muted">${s.count}</td>
                                        <td class="fw-medium"><c:out value="${p.name}"/></td>
                                        <td><c:out value="${p.categoryName}"/></td>
                                        <td>₹<fmt:formatNumber value="${p.buyingPrice}" pattern="#,##0.00"/></td>
                                        <td>₹<fmt:formatNumber value="${p.sellingPrice}" pattern="#,##0.00"/></td>
                                        <td>
                                            ${p.quantity}
                                            <c:if test="${p.quantity <= p.minQuantity}">
                                                <span class="badge-low-stock ms-1">Low Stock</span>
                                            </c:if>
                                        </td>
                                        <td>${p.unit}</td>
                                        <c:if test="${sessionScope.role == 'ADMIN'}">
                                            <td>
                                                <a href="${pageContext.request.contextPath}/products?action=edit&id=${p.id}"
                                                   class="btn btn-sm btn-outline-warning me-1">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/products?action=delete&id=${p.id}"
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('Delete \'${p.name}\'?')">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
    <%@ include file="/includes/footer.jsp" %>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
