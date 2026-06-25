package com.storetrack.servlet;

import com.storetrack.dao.CategoryDAO;
import com.storetrack.dao.ProductDAO;
import com.storetrack.model.Product;
import com.storetrack.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add"    -> showAddForm(req, res);
            case "edit"   -> showEditForm(req, res);
            case "delete" -> deleteProduct(req, res);
            default       -> listProducts(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
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
        if ("save".equals(action))   saveProduct(req, res);
        else if ("update".equals(action)) updateProduct(req, res);
        else listProducts(req, res);
    }

    private void listProducts(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String keyword = req.getParameter("search");
            if (keyword != null && !keyword.isBlank()) {
                req.setAttribute("products", productDAO.search(keyword.trim()));
                req.setAttribute("search", keyword);
            } else {
                req.setAttribute("products", productDAO.getAll());
            }
            req.getRequestDispatcher("/products/list.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load products: " + e.getMessage());
            req.getRequestDispatcher("/products/list.jsp").forward(req, res);
        }
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        try {
            req.setAttribute("categories", categoryDAO.getAll());
            req.getRequestDispatcher("/products/add.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/products/add.jsp").forward(req, res);
        }
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("product",    productDAO.getById(id));
            req.setAttribute("categories", categoryDAO.getAll());
            req.getRequestDispatcher("/products/edit.jsp").forward(req, res);
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/products");
        }
    }

    private void saveProduct(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Product p = buildFromRequest(req);
            productDAO.insert(p);
            res.sendRedirect(req.getContextPath() + "/products?success=Product+added+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add product: " + e.getMessage());
            req.setAttribute("categories", categoryDAO.getAll());
            req.getRequestDispatcher("/products/add.jsp").forward(req, res);
        }
    }

    private void updateProduct(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Product p = buildFromRequest(req);
            p.setId(Integer.parseInt(req.getParameter("id")));
            productDAO.update(p);
            res.sendRedirect(req.getContextPath() + "/products?success=Product+updated");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to update product: " + e.getMessage());
            req.setAttribute("categories", categoryDAO.getAll());
            req.getRequestDispatcher("/products/edit.jsp").forward(req, res);
        }
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        if (!SessionUtil.isAdmin(req)) {
            res.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            productDAO.delete(id);
            res.sendRedirect(req.getContextPath() + "/products?success=Product+deleted");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/products?error=" + e.getMessage());
        }
    }

    private Product buildFromRequest(HttpServletRequest req) {
        Product p = new Product();
        p.setName(req.getParameter("name").trim());
        p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        p.setBuyingPrice(Double.parseDouble(req.getParameter("buyingPrice")));
        p.setSellingPrice(Double.parseDouble(req.getParameter("sellingPrice")));
        p.setQuantity(Integer.parseInt(req.getParameter("quantity")));
        p.setMinQuantity(Integer.parseInt(req.getParameter("minQuantity")));
        p.setUnit(req.getParameter("unit").trim());
        return p;
    }
}
