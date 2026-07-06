package com.storetrack.dao;

import com.storetrack.model.Sale;
import com.storetrack.model.SaleItem;
import com.storetrack.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SaleDAO {

    public int processSale(Sale sale, List<SaleItem> items) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert sale header
            String saleSql = "INSERT INTO sales (cashier_id, total_amount, tax_amount) VALUES (?,?,?)";
            int saleId;
            try (PreparedStatement ps = conn.prepareStatement(saleSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, sale.getCashierId());
                ps.setDouble(2, sale.getTotalAmount());
                ps.setDouble(3, sale.getTaxAmount());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    keys.next();
                    saleId = keys.getInt(1);
                }
            }

            // Insert line items and deduct stock
            String itemSql = "INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal) " +
                             "VALUES (?,?,?,?,?)";
            String stockSql = "UPDATE products SET quantity = quantity - ? " +
                              "WHERE id = ? AND quantity >= ?";

            for (SaleItem item : items) {
                try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                    ps.setInt(1, saleId);
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    ps.setDouble(4, item.getUnitPrice());
                    ps.setDouble(5, item.getSubtotal());
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(stockSql)) {
                    ps.setInt(1, item.getQuantity());
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    int rows = ps.executeUpdate();
                    if (rows == 0) {
                        throw new SQLException("Insufficient stock for product id: " + item.getProductId());
                    }
                }
            }

            conn.commit();
            return saleId;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public List<Sale> getAll() throws SQLException {
        List<Sale> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS cashier_name " +
                     "FROM sales s JOIN users u ON s.cashier_id = u.id " +
                     "ORDER BY s.sale_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapSaleRow(rs));
        }
        return list;
    }

    public List<Sale> getByCashier(int cashierId) throws SQLException {
        List<Sale> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS cashier_name " +
                     "FROM sales s JOIN users u ON s.cashier_id = u.id " +
                     "WHERE s.cashier_id = ? ORDER BY s.sale_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cashierId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSaleRow(rs));
            }
        }
        return list;
    }

    public Sale getById(int id) throws SQLException {
        Sale sale = null;
        String saleSql = "SELECT s.*, u.name AS cashier_name " +
                         "FROM sales s JOIN users u ON s.cashier_id = u.id WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(saleSql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) sale = mapSaleRow(rs);
            }
        }
        if (sale != null) {
            sale.setItems(getItemsBySaleId(id));
        }
        return sale;
    }

    public List<SaleItem> getItemsBySaleId(int saleId) throws SQLException {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.*, p.name AS product_name " +
                     "FROM sale_items si JOIN products p ON si.product_id = p.id " +
                     "WHERE si.sale_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, saleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SaleItem item = new SaleItem();
                    item.setId(rs.getInt("id"));
                    item.setSaleId(rs.getInt("sale_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));
                    item.setSubtotal(rs.getDouble("subtotal"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public Map<String, Object> getTodayStats() throws SQLException {
        Map<String, Object> stats = new LinkedHashMap<>();
        String sql = "SELECT COUNT(*) AS total_sales, COALESCE(SUM(total_amount), 0) AS revenue " +
                     "FROM sales WHERE DATE(sale_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalSales", rs.getInt("total_sales"));
                stats.put("revenue", rs.getDouble("revenue"));
            }
        }
        return stats;
    }

    public List<Map<String, Object>> getTopProducts(int limit) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.name, SUM(si.quantity) AS total_sold " +
                     "FROM sale_items si JOIN products p ON si.product_id = p.id " +
                     "GROUP BY p.id, p.name ORDER BY total_sold DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("name", rs.getString("name"));
                    row.put("totalSold", rs.getInt("total_sold"));
                    list.add(row);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getMonthlyRevenue(int months) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month, " +
                     "SUM(total_amount) AS revenue, COUNT(*) AS total_sales " +
                     "FROM sales WHERE sale_date >= DATE_SUB(NOW(), INTERVAL ? MONTH) " +
                     "GROUP BY month ORDER BY month ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, months);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("month", rs.getString("month"));
                    row.put("revenue", rs.getDouble("revenue"));
                    row.put("totalSales", rs.getInt("total_sales"));
                    list.add(row);
                }
            }
        }
        return list;
    }

    public List<Sale> getRecent(int limit) throws SQLException {
        List<Sale> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS cashier_name " +
                     "FROM sales s JOIN users u ON s.cashier_id = u.id " +
                     "ORDER BY s.sale_date DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSaleRow(rs));
            }
        }
        return list;
    }

    private Sale mapSaleRow(ResultSet rs) throws SQLException {
        Sale s = new Sale();
        s.setId(rs.getInt("id"));
        s.setCashierId(rs.getInt("cashier_id"));
        s.setCashierName(rs.getString("cashier_name"));
        s.setTotalAmount(rs.getDouble("total_amount"));
        s.setTaxAmount(rs.getDouble("tax_amount"));
        s.setSaleDate(rs.getTimestamp("sale_date"));
        return s;
    }
}
