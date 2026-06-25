<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill #${sale.id} — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .bill-container { max-width: 600px; margin: 2rem auto; }
        .bill-header { text-align: center; border-bottom: 2px solid #1e293b; padding-bottom: 1rem; margin-bottom: 1rem; }
        .bill-footer { text-align: center; border-top: 1px dashed #cbd5e1; padding-top: 1rem; margin-top: 1rem; font-size: .8rem; color: #64748b; }
        @media print {
            .no-print { display: none !important; }
            body { margin: 0; padding: 0; }
        }
    </style>
</head>
<body class="bg-light">

<%-- Print controls — hidden on actual print --%>
<div class="no-print d-flex justify-content-center gap-2 py-3 bg-white border-bottom">
    <button onclick="window.print()" class="btn btn-brand btn-sm">
        <i class="bi bi-printer me-1"></i> Print Bill
    </button>
    <a href="${pageContext.request.contextPath}/sales/history" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i> Back to History
    </a>
    <a href="${pageContext.request.contextPath}/sales/billing" class="btn btn-outline-success btn-sm">
        <i class="bi bi-plus-lg me-1"></i> New Sale
    </a>
</div>

<div class="bill-container print-area p-4 bg-white shadow-sm rounded mt-3">

    <div class="bill-header">
        <h4 class="fw-bold mb-0"><i class="bi bi-shop me-1"></i> StoreTrack</h4>
        <p class="text-muted small mb-0">Tax Invoice</p>
    </div>

    <div class="row mb-3">
        <div class="col-6">
            <small class="text-muted">Bill No.</small>
            <div class="fw-bold">#${sale.id}</div>
        </div>
        <div class="col-6 text-end">
            <small class="text-muted">Date</small>
            <div><fmt:formatDate value="${sale.saleDate}" pattern="dd MMM yyyy HH:mm"/></div>
        </div>
        <div class="col-6 mt-2">
            <small class="text-muted">Cashier</small>
            <div><c:out value="${sale.cashierName}"/></div>
        </div>
    </div>

    <table class="table table-sm table-borderless mb-0">
        <thead class="border-top border-bottom">
            <tr>
                <th>#</th><th>Item</th><th class="text-end">Qty</th>
                <th class="text-end">Rate</th><th class="text-end">Amount</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${sale.items}" varStatus="s">
                <tr>
                    <td>${s.count}</td>
                    <td><c:out value="${item.productName}"/></td>
                    <td class="text-end">${item.quantity}</td>
                    <td class="text-end">₹<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                    <td class="text-end">₹<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                </tr>
            </c:forEach>
        </tbody>
        <tfoot class="border-top">
            <tr>
                <td colspan="4" class="text-end text-muted">Subtotal</td>
                <td class="text-end">
                    ₹<fmt:formatNumber value="${sale.totalAmount - sale.taxAmount}" pattern="#,##0.00"/>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="text-end text-muted">GST / Tax</td>
                <td class="text-end">₹<fmt:formatNumber value="${sale.taxAmount}" pattern="#,##0.00"/></td>
            </tr>
            <tr class="fw-bold fs-6">
                <td colspan="4" class="text-end">Total</td>
                <td class="text-end">₹<fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0.00"/></td>
            </tr>
        </tfoot>
    </table>

    <div class="bill-footer mt-3">
        <p class="mb-0">Thank you for your purchase!</p>
        <small>This is a computer-generated bill.</small>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
