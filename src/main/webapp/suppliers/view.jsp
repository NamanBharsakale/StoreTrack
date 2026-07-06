<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Detail — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Supplier Detail" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">
        <div class="d-flex align-items-center gap-2 mb-4">
            <a href="${pageContext.request.contextPath}/suppliers" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left"></i>
            </a>
            <h5 class="fw-semibold mb-0">Supplier: <c:out value="${supplier.name}"/></h5>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h6 class="fw-semibold mb-3">Contact Details</h6>
                        <p class="mb-1"><i class="bi bi-telephone me-2 text-muted"></i> <c:out value="${supplier.phone}"/></p>
                        <p class="mb-1"><i class="bi bi-envelope me-2 text-muted"></i> <c:out value="${supplier.email}"/></p>
                        <p class="mb-0"><i class="bi bi-geo-alt me-2 text-muted"></i> <c:out value="${supplier.address}"/></p>
                    </div>
                </div>
            </div>
        </div>

        <h6 class="fw-semibold mb-2">Stock Supplied by <c:out value="${supplier.name}"/></h6>
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr><th>#</th><th>Product</th><th>Qty Added</th><th>Added By</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                        <c:set var="found" value="false"/>
                        <c:forEach var="e" items="${stockEntries}" varStatus="s">
                            <c:if test="${e.supplierId == supplier.id}">
                                <c:set var="found" value="true"/>
                                <tr>
                                    <td>${s.count}</td>
                                    <td><c:out value="${e.productName}"/></td>
                                    <td>${e.quantityAdded}</td>
                                    <td><c:out value="${e.addedByName}"/></td>
                                    <td><fmt:formatDate value="${e.addedDate}" pattern="dd MMM yyyy HH:mm"/></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!found}">
                            <tr><td colspan="5" class="text-center text-muted py-4">No stock entries for this supplier</td></tr>
                        </c:if>
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
