package com.storetrack.dao;

import com.storetrack.model.StockEntry;
import com.storetrack.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StockDAO {

    public List<StockEntry> getAll() throws SQLException {
        List<StockEntry> list = new ArrayList<>();
        String sql = "SELECT se.*, p.name AS product_name, " +
                     "s.name AS supplier_name, u.name AS added_by_name " +
                     "FROM stock_entries se " +
                     "JOIN products p ON se.product_id = p.id " +
                     "LEFT JOIN suppliers s ON se.supplier_id = s.id " +
                     "JOIN users u ON se.added_by = u.id " +
                     "ORDER BY se.added_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public boolean insert(StockEntry entry) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String insertSql = "INSERT INTO stock_entries (product_id, supplier_id, quantity_added, added_by) " +
                               "VALUES (?,?,?,?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, entry.getProductId());
                if (entry.getSupplierId() > 0) ps.setInt(2, entry.getSupplierId());
                else ps.setNull(2, Types.INTEGER);
                ps.setInt(3, entry.getQuantityAdded());
                ps.setInt(4, entry.getAddedBy());
                ps.executeUpdate();
            }

            String updateSql = "UPDATE products SET quantity = quantity + ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, entry.getQuantityAdded());
                ps.setInt(2, entry.getProductId());
                ps.executeUpdate();
            }

            conn.commit();
            return true;
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

    private StockEntry mapRow(ResultSet rs) throws SQLException {
        StockEntry e = new StockEntry();
        e.setId(rs.getInt("id"));
        e.setProductId(rs.getInt("product_id"));
        e.setProductName(rs.getString("product_name"));
        e.setSupplierId(rs.getInt("supplier_id"));
        e.setSupplierName(rs.getString("supplier_name"));
        e.setQuantityAdded(rs.getInt("quantity_added"));
        e.setAddedBy(rs.getInt("added_by"));
        e.setAddedByName(rs.getString("added_by_name"));
        e.setAddedDate(rs.getTimestamp("added_date"));
        return e;
    }
}
