<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Stock Entry — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Add Stock Entry" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">
        <div class="d-flex align-items-center gap-2 mb-3">
            <a href="${pageContext.request.contextPath}/stock" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left"></i>
            </a>
            <h5 class="fw-semibold mb-0">Add Stock Entry</h5>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><c:out value="${error}"/></div>
        </c:if>

        <div class="card" style="max-width:520px">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/stock?action=save">
                    <div class="mb-3">
                        <label class="form-label">Product *</label>
                        <select class="form-select" name="productId" required>
                            <option value="">Select product</option>
                            <c:forEach var="p" items="${products}">
                                <option value="${p.id}">
                                    <c:out value="${p.name}"/> (${p.quantity} ${p.unit} in stock)
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Supplier</label>
                        <select class="form-select" name="supplierId">
                            <option value="">No supplier / self-purchase</option>
                            <c:forEach var="s" items="${suppliers}">
                                <option value="${s.id}"><c:out value="${s.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Quantity to Add *</label>
                        <input type="number" class="form-control" name="quantityAdded" min="1" required placeholder="e.g. 50">
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-brand">
                            <i class="bi bi-check-lg me-1"></i> Add Stock
                        </button>
                        <a href="${pageContext.request.contextPath}/stock" class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%@ include file="/includes/footer.jsp" %>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
