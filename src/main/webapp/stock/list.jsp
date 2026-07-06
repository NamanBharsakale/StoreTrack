<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Entries — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Stock Entry" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible">
                <i class="bi bi-check-circle me-1"></i> <c:out value="${success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible">
                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-semibold mb-0">Stock Entries</h5>
            <a href="${pageContext.request.contextPath}/stock?action=add"
               class="btn btn-brand btn-sm">
                <i class="bi bi-plus-lg me-1"></i> Add Stock
            </a>
        </div>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>#</th><th>Product</th><th>Supplier</th>
                            <th>Qty Added</th><th>Added By</th><th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty entries}">
                                <tr><td colspan="6" class="text-center text-muted py-4">No stock entries yet</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="e" items="${entries}" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td class="fw-medium"><c:out value="${e.productName}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty e.supplierName}">
                                                    <c:out value="${e.supplierName}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge bg-success bg-opacity-10 text-success fw-semibold">
                                                +${e.quantityAdded}
                                            </span>
                                        </td>
                                        <td><c:out value="${e.addedByName}"/></td>
                                        <td><fmt:formatDate value="${e.addedDate}" pattern="dd MMM yyyy HH:mm"/></td>
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
