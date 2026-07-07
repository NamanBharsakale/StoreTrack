<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users — StoreTrack</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/includes/sidebar.jsp" %>
<main class="main-content">
    <c:set var="pageTitle" value="User Management" scope="request"/>
    <%@ include file="/includes/header.jsp" %>

    <div class="container-fluid p-4">

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible">
                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible">
                <i class="bi bi-check-circle me-1"></i> <c:out value="${success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-semibold mb-0">System Users</h5>
            <a href="${pageContext.request.contextPath}/users?action=add" class="btn btn-brand btn-sm">
                <i class="bi bi-person-plus me-1"></i> Add User
            </a>
        </div>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr><th>#</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Joined</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}" varStatus="s">
                            <tr>
                                <td>${s.count}</td>
                                <td class="fw-medium"><c:out value="${u.name}"/></td>
                                <td><c:out value="${u.email}"/></td>
                                <td>
                                    <span class="badge-role
                                        <c:choose>
                                            <c:when test="${u.role == 'ADMIN'}">bg-primary text-white</c:when>
                                            <c:when test="${u.role == 'CASHIER'}">bg-success text-white</c:when>
                                            <c:otherwise>bg-warning text-dark</c:otherwise>
                                        </c:choose>">
                                        ${u.role}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.isActive == 1}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy"/></td>
                                <td>
                                    <c:if test="${u.id != sessionScope.userId}">
                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                data-bs-toggle="modal" data-bs-target="#resetModal${u.id}"
                                                title="Reset password">
                                            <i class="bi bi-key"></i>
                                        </button>
                                        <c:choose>
                                            <c:when test="${u.isActive == 1}">
                                                <a href="${pageContext.request.contextPath}/users?action=toggle&id=${u.id}&active=0"
                                                   class="btn btn-sm btn-outline-warning"
                                                   onclick="return confirm('Deactivate ${u.name}?')">
                                                    <i class="bi bi-person-slash"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/users?action=toggle&id=${u.id}&active=1"
                                                   class="btn btn-sm btn-outline-success">
                                                    <i class="bi bi-person-check"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="modal fade" id="resetModal${u.id}" tabindex="-1">
                                            <div class="modal-dialog modal-sm">
                                                <form class="modal-content" method="post"
                                                      action="${pageContext.request.contextPath}/users?action=reset">
                                                    <input type="hidden" name="id" value="${u.id}">
                                                    <div class="modal-header">
                                                        <h6 class="modal-title">Reset Password — <c:out value="${u.name}"/></h6>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <label class="form-label" for="password${u.id}">New Password</label>
                                                        <input type="password" class="form-control" id="password${u.id}"
                                                               name="password" minlength="6" required>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-sm btn-brand">Reset</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
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
