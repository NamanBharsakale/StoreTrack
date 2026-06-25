package com.storetrack.servlet;

import com.storetrack.dao.ProductDAO;
import com.storetrack.dao.SaleDAO;
import com.storetrack.model.Sale;
import com.storetrack.model.SaleItem;
import com.storetrack.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/sales/billing", "/sales/confirm", "/sales/history", "/sales/print"})
public class SaleServlet extends HttpServlet {

    private final SaleDAO    saleDAO    = new SaleDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri = req.getServletPath();
        switch (uri) {
            case "/sales/billing" -> showBilling(req, res);
            case "/sales/history" -> showHistory(req, res);
            case "/sales/print"   -> showPrint(req, res);
            default               -> res.sendRedirect(req.getContextPath() + "/sales/billing");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (!SessionUtil.isAdminOrCashier(req)) {
            res.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        processSale(req, res);
    }

    private void showBilling(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isAdminOrCashier(req)) {
            res.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        try {
            req.setAttribute("products", productDAO.getAll());
            String error = req.getParameter("error");
            if (error != null) req.setAttribute("error", error);
            req.getRequestDispatcher("/sales/billing.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load products.");
            req.getRequestDispatcher("/sales/billing.jsp").forward(req, res);
        }
    }

    private void showHistory(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            List<Sale> sales;
            if (SessionUtil.isAdmin(req)) {
                sales = saleDAO.getAll();
            } else {
                sales = saleDAO.getByCashier(SessionUtil.getUserId(req));
            }
            req.setAttribute("sales", sales);
            req.getRequestDispatcher("/sales/history.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load sales history.");
            req.getRequestDispatcher("/sales/history.jsp").forward(req, res);
        }
    }

    private void showPrint(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Sale sale = saleDAO.getById(id);
            if (sale == null) {
                res.sendRedirect(req.getContextPath() + "/sales/history");
                return;
            }
            req.setAttribute("sale", sale);
            req.getRequestDispatcher("/sales/bill-print.jsp").forward(req, res);
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/sales/history");
        }
    }

    private void processSale(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String[] productIds   = req.getParameterValues("productId");
            String[] quantities   = req.getParameterValues("qty");
            String[] unitPrices   = req.getParameterValues("unitPrice");
            String   taxStr       = req.getParameter("tax");

            if (productIds == null || productIds.length == 0) {
                res.sendRedirect(req.getContextPath() + "/sales/billing?error=No+items+in+cart");
                return;
            }

            List<SaleItem> items = new ArrayList<>();
            double subtotalSum = 0;

            for (int i = 0; i < productIds.length; i++) {
                SaleItem item = new SaleItem();
                item.setProductId(Integer.parseInt(productIds[i]));
                item.setQuantity(Integer.parseInt(quantities[i]));
                item.setUnitPrice(Double.parseDouble(unitPrices[i]));
                item.setSubtotal(item.getQuantity() * item.getUnitPrice());
                subtotalSum += item.getSubtotal();
                items.add(item);
            }

            double taxRate   = taxStr != null && !taxStr.isBlank() ? Double.parseDouble(taxStr) : 0;
            double taxAmount = subtotalSum * taxRate / 100;
            double total     = subtotalSum + taxAmount;

            Sale sale = new Sale();
            sale.setCashierId(SessionUtil.getUserId(req));
            sale.setTotalAmount(total);
            sale.setTaxAmount(taxAmount);

            int saleId = saleDAO.processSale(sale, items);
            res.sendRedirect(req.getContextPath() + "/sales/print?id=" + saleId);

        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/sales/billing?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
