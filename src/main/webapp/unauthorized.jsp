<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Unauthorized — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <%@ include file="/includes/header.jsp" %>
    <div class="container-fluid p-4">
        <div class="text-center py-5">
            <i class="bi bi-shield-x" style="font-size:4rem;color:#ef4444"></i>
            <h3 class="mt-3 fw-bold">Access Denied</h3>
            <p class="text-muted">You don't have permission to view this page.</p>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-brand mt-2">
                <i class="bi bi-house me-1"></i> Go to Dashboard
            </a>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
