<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales History — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Sales History" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-semibold mb-0">Sales History</h5>
            <a href="${pageContext.request.contextPath}/sales/billing" class="btn btn-brand btn-sm">
                <i class="bi bi-plus-lg me-1"></i> New Sale
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><c:out value="${error}"/></div>
        </c:if>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>#</th><th>Date</th><th>Cashier</th>
                            <th>Tax</th><th>Total</th><th>Bill</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty sales}">
                                <tr><td colspan="6" class="text-center text-muted py-4">No sales recorded yet</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${sales}">
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
