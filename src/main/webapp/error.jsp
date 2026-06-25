<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error — StoreTrack</title>
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
            <i class="bi bi-bug" style="font-size:4rem;color:#f59e0b"></i>
            <h3 class="mt-3 fw-bold">Something went wrong</h3>
            <p class="text-muted">An unexpected error occurred. Please try again.</p>
            <a href="javascript:history.back()" class="btn btn-outline-secondary mt-2">
                <i class="bi bi-arrow-left me-1"></i> Go Back
            </a>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
