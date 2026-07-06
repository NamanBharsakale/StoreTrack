<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="Billing" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible">
                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-3">

            <%-- Product search --%>
            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-body">
                        <h6 class="fw-semibold mb-3">Search & Add Products</h6>
                        <div class="position-relative">
                            <input type="text" class="form-control" id="productSearch"
                                   placeholder="Type product name to search..."
                                   oninput="searchProduct()" autocomplete="off">
                            <div id="searchResults" class="product-search-result"></div>
                        </div>
                    </div>
                </div>

                <%-- Cart --%>
                <div class="card">
                    <div class="card-header bg-white pt-3 pb-2 border-bottom-0">
                        <h6 class="fw-semibold mb-0"><i class="bi bi-cart me-1"></i> Cart</h6>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-sm mb-0" id="cart-table">
                            <thead>
                                <tr><th>Product</th><th>Qty</th><th>Unit Price</th><th>Subtotal</th><th></th></tr>
                            </thead>
                            <tbody id="cartBody">
                                <tr><td colspan="5" class="text-center text-muted py-4">No items added yet</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- Bill summary --%>
            <div class="col-lg-5">
                <div class="card sticky-top" style="top:1rem">
                    <div class="card-body">
                        <h6 class="fw-semibold mb-3">Bill Summary</h6>

                        <div class="mb-3">
                            <label class="form-label">GST / Tax (%)</label>
                            <input type="number" class="form-control" id="taxRate"
                                   value="18" min="0" max="100" step="0.1"
                                   onchange="renderCart()">
                        </div>

                        <hr>
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted">Subtotal</span>
                            <span id="subtotalAmt">₹0.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted">Tax</span>
                            <span id="taxAmt">₹0.00</span>
                        </div>
                        <div class="d-flex justify-content-between fw-bold fs-5 mt-2">
                            <span>Total</span>
                            <span id="totalAmt">₹0.00</span>
                        </div>
                        <hr>

                        <form id="saleForm" method="post"
                              action="${pageContext.request.contextPath}/sales/confirm">
                            <input type="hidden" name="tax" id="taxHidden">
                            <div id="cartHidden"></div>
                            <button type="button" class="btn btn-brand w-100 mt-2"
                                    onclick="document.getElementById('taxHidden').value=document.getElementById('taxRate').value; submitSale()">
                                <i class="bi bi-check-circle me-1"></i> Confirm Sale
                            </button>
                        </form>

                        <a href="${pageContext.request.contextPath}/sales/history"
                           class="btn btn-outline-secondary w-100 mt-2">
                            <i class="bi bi-clock-history me-1"></i> Sales History
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <%@ include file="/includes/footer.jsp" %>
</main>

<%-- Expose product list to JS --%>
<script>
window.allProducts = [
    <c:forEach var="p" items="${products}" varStatus="s">
    {
        id: ${p.id},
        name: "<c:out value="${p.name}" escapeXml="false"/>".replace(/"/g, '\\"'),
        sellingPrice: ${p.sellingPrice},
        quantity: ${p.quantity},
        unit: "<c:out value="${p.unit}"/>"
    }<c:if test="${!s.last}">,</c:if>
    </c:forEach>
];
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
