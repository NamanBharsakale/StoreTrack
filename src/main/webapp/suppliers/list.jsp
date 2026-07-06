<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Suppliers — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Suppliers" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible">
                <i class="bi bi-check-circle me-1"></i> <c:out value="${success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-semibold mb-0">Suppliers</h5>
            <a href="${pageContext.request.contextPath}/suppliers?action=add"
               class="btn btn-brand btn-sm">
                <i class="bi bi-plus-lg me-1"></i> Add Supplier
            </a>
        </div>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr><th>#</th><th>Name</th><th>Phone</th><th>Email</th><th>Address</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty suppliers}">
                                <tr><td colspan="6" class="text-center text-muted py-4">No suppliers added yet</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${suppliers}" varStatus="i">
                                    <tr>
                                        <td>${i.count}</td>
                                        <td class="fw-medium"><c:out value="${s.name}"/></td>
                                        <td><c:out value="${s.phone}"/></td>
                                        <td><c:out value="${s.email}"/></td>
                                        <td><c:out value="${s.address}"/></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/suppliers?action=view&id=${s.id}"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
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
