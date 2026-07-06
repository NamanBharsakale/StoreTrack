package com.storetrack.dao;

import com.storetrack.model.Product;
import com.storetrack.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAll() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name " +
                     "FROM products p JOIN categories c ON p.category_id = c.id " +
                     "ORDER BY p.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Product> search(String keyword) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name " +
                     "FROM products p JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.name LIKE ? OR c.name LIKE ? ORDER BY p.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public Product getById(int id) throws SQLException {
        String sql = "SELECT p.*, c.name AS category_name " +
                     "FROM products p JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public List<Product> getLowStock() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name " +
                     "FROM products p JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.quantity <= p.min_quantity ORDER BY p.quantity ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public boolean insert(Product p) throws SQLException {
        String sql = "INSERT INTO products (name, category_id, buying_price, selling_price, " +
                     "quantity, min_quantity, unit) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getCategoryId());
            ps.setDouble(3, p.getBuyingPrice());
            ps.setDouble(4, p.getSellingPrice());
            ps.setInt(5, p.getQuantity());
            ps.setInt(6, p.getMinQuantity());
            ps.setString(7, p.getUnit());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Product p) throws SQLException {
        String sql = "UPDATE products SET name=?, category_id=?, buying_price=?, " +
                     "selling_price=?, min_quantity=?, unit=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getCategoryId());
            ps.setDouble(3, p.getBuyingPrice());
            ps.setDouble(4, p.getSellingPrice());
            ps.setInt(5, p.getMinQuantity());
            ps.setString(6, p.getUnit());
            ps.setInt(7, p.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public int getTotalCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setBuyingPrice(rs.getDouble("buying_price"));
        p.setSellingPrice(rs.getDouble("selling_price"));
        p.setQuantity(rs.getInt("quantity"));
        p.setMinQuantity(rs.getInt("min_quantity"));
        p.setUnit(rs.getString("unit"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        try { p.setCategoryName(rs.getString("category_name")); } catch (SQLException ignored) {}
        return p;
    }
}
