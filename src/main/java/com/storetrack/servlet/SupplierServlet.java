package com.storetrack.servlet;

import com.storetrack.dao.StockDAO;
import com.storetrack.dao.SupplierDAO;
import com.storetrack.model.Supplier;
import com.storetrack.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/suppliers")
public class SupplierServlet extends HttpServlet {

    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final StockDAO    stockDAO    = new StockDAO();

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
            req.getRequestDispatcher("/suppliers/add.jsp").forward(req, res);
        } else if ("view".equals(action)) {
            viewSupplier(req, res);
        } else {
            listSuppliers(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req) || !SessionUtil.isAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if ("save".equals(req.getParameter("action"))) saveSupplier(req, res);
        else listSuppliers(req, res);
    }

    private void listSuppliers(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("suppliers", supplierDAO.getAll());
            String success = req.getParameter("success");
            if (success != null) req.setAttribute("success", success);
            req.getRequestDispatcher("/suppliers/list.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load suppliers.");
            req.getRequestDispatcher("/suppliers/list.jsp").forward(req, res);
        }
    }

    private void viewSupplier(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("supplier",      supplierDAO.getById(id));
            req.setAttribute("stockEntries",  stockDAO.getAll());
            req.getRequestDispatcher("/suppliers/view.jsp").forward(req, res);
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/suppliers");
        }
    }

    private void saveSupplier(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Supplier s = new Supplier();
            s.setName(req.getParameter("name").trim());
            s.setPhone(req.getParameter("phone"));
            s.setEmail(req.getParameter("email"));
            s.setAddress(req.getParameter("address"));
            supplierDAO.insert(s);
            res.sendRedirect(req.getContextPath() + "/suppliers?success=Supplier+added");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add supplier: " + e.getMessage());
            req.getRequestDispatcher("/suppliers/add.jsp").forward(req, res);
        }
    }
}
