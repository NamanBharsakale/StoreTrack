package com.storetrack.servlet;

import com.storetrack.dao.UserDAO;
import com.storetrack.model.User;
import com.storetrack.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            redirectByRole((String) session.getAttribute("role"), req, res);
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        try {
            String hashed = PasswordUtil.hash(password);
            User user = userDAO.getByEmailAndPassword(email.trim(), hashed);

            if (user == null) {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/login.jsp").forward(req, res);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("userId",   user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("role",     user.getRole());
            session.setMaxInactiveInterval(30 * 60);

            redirectByRole(user.getRole(), req, res);

        } catch (Exception e) {
            req.setAttribute("error", "Login failed. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }

    private void redirectByRole(String role, HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        String ctx = req.getContextPath();
        switch (role) {
            case "CASHIER"       -> res.sendRedirect(ctx + "/sales/billing");
            case "STOCK_MANAGER" -> res.sendRedirect(ctx + "/stock");
            default              -> res.sendRedirect(ctx + "/dashboard");
        }
    }
}
