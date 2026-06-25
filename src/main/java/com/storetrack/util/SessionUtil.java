package com.storetrack.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    public static boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }

    public static String getRole(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (String) session.getAttribute("role");
    }

    public static boolean isAdmin(HttpServletRequest req) {
        return "ADMIN".equals(getRole(req));
    }

    public static boolean isCashier(HttpServletRequest req) {
        return "CASHIER".equals(getRole(req));
    }

    public static boolean isStockManager(HttpServletRequest req) {
        return "STOCK_MANAGER".equals(getRole(req));
    }

    public static boolean isAdminOrStockManager(HttpServletRequest req) {
        String role = getRole(req);
        return "ADMIN".equals(role) || "STOCK_MANAGER".equals(role);
    }

    public static boolean isAdminOrCashier(HttpServletRequest req) {
        String role = getRole(req);
        return "ADMIN".equals(role) || "CASHIER".equals(role);
    }

    public static int getUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return -1;
        Object id = session.getAttribute("userId");
        return id == null ? -1 : (int) id;
    }

    public static String getUserName(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (String) session.getAttribute("userName");
    }
}
