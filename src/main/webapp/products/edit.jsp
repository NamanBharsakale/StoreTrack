<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Edit Product" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">
        <div class="d-flex align-items-center gap-2 mb-3">
            <a href="${pageContext.request.contextPath}/products" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left"></i>
            </a>
            <h5 class="fw-semibold mb-0">Edit Product</h5>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${error}"/></div>
        </c:if>

        <div class="card" style="max-width:640px">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/products?action=update">
                    <input type="hidden" name="id" value="${product.id}">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Product Name *</label>
                            <input type="text" class="form-control" name="name"
                                   value="<c:out value="${product.name}"/>" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Category *</label>
                            <select class="form-select" name="categoryId" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${cat.id == product.categoryId ? 'selected' : ''}>
                                        <c:out value="${cat.name}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label">Buying Price (₹) *</label>
                            <input type="number" class="form-control" name="buyingPrice"
                                   step="0.01" min="0" value="${product.buyingPrice}" required>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label">Selling Price (₹) *</label>
                            <input type="number" class="form-control" name="sellingPrice"
                                   step="0.01" min="0" value="${product.sellingPrice}" required>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label">Min Quantity *</label>
                            <input type="number" class="form-control" name="minQuantity"
                                   min="1" value="${product.minQuantity}" required>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label">Unit *</label>
                            <input type="text" class="form-control" name="unit"
                                   value="<c:out value="${product.unit}"/>" required>
                        </div>
                        <%-- quantity is not editable here — use stock entry to restock --%>
                        <input type="hidden" name="quantity" value="${product.quantity}">
                        <div class="col-12 d-flex gap-2 mt-2">
                            <button type="submit" class="btn btn-brand">
                                <i class="bi bi-check-lg me-1"></i> Update Product
                            </button>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">Cancel</a>
                        </div>
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
