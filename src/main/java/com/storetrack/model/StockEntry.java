package com.storetrack.model;

import java.sql.Timestamp;

public class StockEntry {
    private int id;
    private int productId;
    private String productName;
    private int supplierId;
    private String supplierName;
    private int quantityAdded;
    private int addedBy;
    private String addedByName;
    private Timestamp addedDate;

    public StockEntry() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public int getQuantityAdded() { return quantityAdded; }
    public void setQuantityAdded(int quantityAdded) { this.quantityAdded = quantityAdded; }

    public int getAddedBy() { return addedBy; }
    public void setAddedBy(int addedBy) { this.addedBy = addedBy; }

    public String getAddedByName() { return addedByName; }
    public void setAddedByName(String addedByName) { this.addedByName = addedByName; }

    public Timestamp getAddedDate() { return addedDate; }
    public void setAddedDate(Timestamp addedDate) { this.addedDate = addedDate; }
}
