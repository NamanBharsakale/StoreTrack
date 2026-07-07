package com.storetrack.servlet;

import com.storetrack.dao.ProductDAO;
import com.storetrack.dao.StockDAO;
import com.storetrack.dao.SupplierDAO;
import com.storetrack.model.StockEntry;
import com.storetrack.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/stock")
public class StockServlet extends HttpServlet {

    private final StockDAO    stockDAO    = new StockDAO();
    private final ProductDAO  productDAO  = new ProductDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (!SessionUtil.isAdminOrStockManager(req)) {
            res.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            showAddForm(req, res);
        } else {
            listEntries(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req) || !SessionUtil.isAdminOrStockManager(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if ("save".equals(req.getParameter("action"))) saveEntry(req, res);
        else listEntries(req, res);
    }

    private void listEntries(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("entries", stockDAO.getAll());
            String success = req.getParameter("success");
            if (success != null) req.setAttribute("success", success);
            req.getRequestDispatcher("/stock/list.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load stock entries.");
            req.getRequestDispatcher("/stock/list.jsp").forward(req, res);
        }
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("products",  productDAO.getAll());
            req.setAttribute("suppliers", supplierDAO.getAll());
            req.getRequestDispatcher("/stock/add.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/stock/add.jsp").forward(req, res);
        }
    }

    private void saveEntry(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            StockEntry entry = new StockEntry();
            entry.setProductId(Integer.parseInt(req.getParameter("productId")));
            String suppId = req.getParameter("supplierId");
            entry.setSupplierId(suppId != null && !suppId.isBlank() ? Integer.parseInt(suppId) : 0);
            entry.setQuantityAdded(Integer.parseInt(req.getParameter("quantityAdded")));
            entry.setAddedBy(SessionUtil.getUserId(req));
            stockDAO.insert(entry);
            res.sendRedirect(req.getContextPath() + "/stock?success=Stock+entry+added");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add stock: " + e.getMessage());
            try {
                req.setAttribute("products",  productDAO.getAll());
                req.setAttribute("suppliers", supplierDAO.getAll());
            } catch (Exception ex) {
                req.setAttribute("products",  java.util.Collections.emptyList());
                req.setAttribute("suppliers", java.util.Collections.emptyList());
            }
            req.getRequestDispatcher("/stock/add.jsp").forward(req, res);
        }
    }
}
