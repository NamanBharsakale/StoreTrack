package com.storetrack.servlet;

import com.storetrack.dao.UserDAO;
import com.storetrack.model.User;
import com.storetrack.util.PasswordUtil;
import com.storetrack.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (!SessionUtil.isAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            req.getRequestDispatcher("/users/add.jsp").forward(req, res);
        } else if ("toggle".equals(action)) {
            toggleUser(req, res);
        } else {
            listUsers(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req) || !SessionUtil.isAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String action = req.getParameter("action");
        if ("save".equals(action)) saveUser(req, res);
        else if ("reset".equals(action)) resetPassword(req, res);
        else listUsers(req, res);
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("users", userDAO.getAll());
            String success = req.getParameter("success");
            String error   = req.getParameter("error");
            if (success != null) req.setAttribute("success", success);
            if (error   != null) req.setAttribute("error",   error);
            req.getRequestDispatcher("/users/list.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load users.");
            req.getRequestDispatcher("/users/list.jsp").forward(req, res);
        }
    }

    private void saveUser(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String email = req.getParameter("email").trim();
            if (userDAO.emailExists(email)) {
                req.setAttribute("error", "A user with this email already exists.");
                req.getRequestDispatcher("/users/add.jsp").forward(req, res);
                return;
            }
            User u = new User();
            u.setName(req.getParameter("name").trim());
            u.setEmail(email);
            u.setPassword(PasswordUtil.hash(req.getParameter("password")));
            u.setRole(req.getParameter("role"));
            userDAO.insert(u);
            res.sendRedirect(req.getContextPath() + "/users?success=User+added+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add user: " + e.getMessage());
            req.getRequestDispatcher("/users/add.jsp").forward(req, res);
        }
    }

    private void resetPassword(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String password = req.getParameter("password");
            if (password == null || password.trim().length() < 6) {
                res.sendRedirect(req.getContextPath() + "/users?error=Password+must+be+at+least+6+characters");
                return;
            }
            userDAO.resetPassword(id, PasswordUtil.hash(password));
            res.sendRedirect(req.getContextPath() + "/users?success=Password+reset+successfully");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/users?error=Failed+to+reset+password");
        }
    }

    private void toggleUser(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id       = Integer.parseInt(req.getParameter("id"));
            int isActive = Integer.parseInt(req.getParameter("active"));
            userDAO.toggleActive(id, isActive);
            res.sendRedirect(req.getContextPath() + "/users?success=User+status+updated");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/users?error=" + e.getMessage());
        }
    }
}
