package com.storetrack.model;

import java.sql.Timestamp;
import java.util.List;

public class Sale {
    private int id;
    private int cashierId;
    private String cashierName;
    private double totalAmount;
    private double taxAmount;
    private Timestamp saleDate;
    private List<SaleItem> items;

    public Sale() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCashierId() { return cashierId; }
    public void setCashierId(int cashierId) { this.cashierId = cashierId; }

    public String getCashierName() { return cashierName; }
    public void setCashierName(String cashierName) { this.cashierName = cashierName; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(double taxAmount) { this.taxAmount = taxAmount; }

    public Timestamp getSaleDate() { return saleDate; }
    public void setSaleDate(Timestamp saleDate) { this.saleDate = saleDate; }

    public List<SaleItem> getItems() { return items; }
    public void setItems(List<SaleItem> items) { this.items = items; }
}
