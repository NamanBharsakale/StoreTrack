package com.storetrack.servlet;

import com.storetrack.dao.CategoryDAO;
import com.storetrack.dao.ProductDAO;
import com.storetrack.dao.SaleDAO;
import com.storetrack.dao.SupplierDAO;
import com.storetrack.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final SaleDAO     saleDAO     = new SaleDAO();

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

        try {
            Map<String, Object> todayStats = saleDAO.getTodayStats();
            req.setAttribute("totalProducts",   productDAO.getTotalCount());
            req.setAttribute("totalCategories", categoryDAO.getTotalCount());
            req.setAttribute("totalSuppliers",  supplierDAO.getTotalCount());
            req.setAttribute("todaySalesCount", todayStats.get("totalSales"));
            req.setAttribute("todayRevenue",    todayStats.get("revenue"));
            req.setAttribute("lowStockList",    productDAO.getLowStock());
            req.setAttribute("topProducts",     saleDAO.getTopProducts(5));
            req.setAttribute("recentSales",     saleDAO.getRecent(10));
            req.setAttribute("monthlyRevenue",  saleDAO.getMonthlyRevenue(6));

            req.getRequestDispatcher("/dashboard.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load dashboard: " + e.getMessage());
            req.getRequestDispatcher("/dashboard.jsp").forward(req, res);
        }
    }
}
