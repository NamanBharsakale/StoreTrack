package com.storetrack.servlet;

import com.storetrack.dao.CategoryDAO;
import com.storetrack.model.Category;
import com.storetrack.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

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
            req.getRequestDispatcher("/categories/add.jsp").forward(req, res);
        } else if ("delete".equals(action)) {
            deleteCategory(req, res);
        } else {
            listCategories(req, res);
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
        if ("save".equals(action)) saveCategory(req, res);
        else listCategories(req, res);
    }

    private void listCategories(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("categories", categoryDAO.getAll());
            String success = req.getParameter("success");
            String error   = req.getParameter("error");
            if (success != null) req.setAttribute("success", success);
            if (error   != null) req.setAttribute("error",   error);
            req.getRequestDispatcher("/categories/list.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load categories.");
            req.getRequestDispatcher("/categories/list.jsp").forward(req, res);
        }
    }

    private void saveCategory(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Category c = new Category();
            c.setName(req.getParameter("name").trim());
            c.setDescription(req.getParameter("description"));
            categoryDAO.insert(c);
            res.sendRedirect(req.getContextPath() + "/categories?success=Category+added");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add category: " + e.getMessage());
            req.getRequestDispatcher("/categories/add.jsp").forward(req, res);
        }
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            if (categoryDAO.hasProducts(id)) {
                res.sendRedirect(req.getContextPath() +
                        "/categories?error=Cannot+delete%3A+products+exist+in+this+category");
                return;
            }
            categoryDAO.delete(id);
            res.sendRedirect(req.getContextPath() + "/categories?success=Category+deleted");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/categories?error=" + e.getMessage());
        }
    }
}
