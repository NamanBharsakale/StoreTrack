# StoreTrack — Architecture

## High-Level Overview

```
Browser (HTML + Bootstrap 5)
        │
        │ HTTP GET / POST
        ▼
Apache Tomcat 10.1  (Servlet Container)
        │
   ┌────┴────────────────┐
   │  Servlet (Controller)│  ← routes requests, calls DAO, sets attributes
   └────┬────────────────┘
        │
   ┌────┴────────────────┐
   │    DAO (JDBC)        │  ← ALL SQL lives here only
   └────┬────────────────┘
        │ JDBC
        ▼
    MySQL 8.x
```

## Request-Response Lifecycle

```
1. Browser → HTTP request → Tomcat
2. Tomcat URL pattern match → correct Servlet
3. Servlet checks HttpSession (SessionUtil.isLoggedIn)
4. Servlet reads ?action= parameter, dispatches to private method
5. Private method calls DAO → DAO returns model object or List
6. Servlet sets req.setAttribute("key", value)
7. Servlet forwards to JSP → JSP renders HTML with JSTL/EL
8. HTML response sent to browser
```

## Layer Responsibilities

| Layer    | Package                   | Rule                                   |
|----------|---------------------------|----------------------------------------|
| Model    | `com.storetrack.model`    | Fields + getters/setters only. No logic |
| DAO      | `com.storetrack.dao`      | All JDBC. No HTTP, no session          |
| Servlet  | `com.storetrack.servlet`  | Routing + DAO calls. No SQL, no HTML   |
| JSP      | `webapp/**/*.jsp`         | Display only. JSTL + EL, no scriptlets |
| Util     | `com.storetrack.util`     | DBConnection, SessionUtil, PasswordUtil |

## Package Map

```
com.storetrack/
├── model/
│   ├── User.java
│   ├── Category.java
│   ├── Product.java          ← has isLowStock() helper
│   ├── Supplier.java
│   ├── StockEntry.java
│   ├── Sale.java             ← holds List<SaleItem> for bill print
│   └── SaleItem.java
│
├── dao/
│   ├── UserDAO.java          ← getByEmailAndPassword, getAll, insert, toggleActive
│   ├── CategoryDAO.java      ← getAll, insert, delete, hasProducts (guard)
│   ├── ProductDAO.java       ← getAll, search, getById, getLowStock, insert, update, delete
│   ├── SupplierDAO.java      ← getAll, getById, insert, update, delete
│   ├── StockDAO.java         ← getAll, insert (runs inside transaction)
│   └── SaleDAO.java          ← processSale (transaction), getAll, getByCashier, getById,
│                                 getTodayStats, getTopProducts, getMonthlyRevenue, getRecent
│
├── servlet/
│   ├── LoginServlet.java     → /login
│   ├── LogoutServlet.java    → /logout
│   ├── DashboardServlet.java → /dashboard
│   ├── ProductServlet.java   → /products
│   ├── CategoryServlet.java  → /categories
│   ├── SupplierServlet.java  → /suppliers
│   ├── StockServlet.java     → /stock
│   ├── SaleServlet.java      → /sales/billing, /sales/confirm, /sales/history, /sales/print
│   └── UserServlet.java      → /users
│
└── util/
    ├── DBConnection.java     ← reads DB_URL / DB_USER / DB_PASSWORD from env
    ├── SessionUtil.java      ← isLoggedIn, isAdmin, isCashier, isStockManager
    └── PasswordUtil.java     ← SHA-256 hash + verify
```

## Database Schema

```
users          → id, name, email, password(SHA-256), role, is_active
categories     → id, name, description
products       → id, name, category_id(FK), buying_price, selling_price,
                 quantity, min_quantity, unit
suppliers      → id, name, phone, email, address
stock_entries  → id, product_id(FK), supplier_id(FK), quantity_added,
                 added_by(FK→users), added_date
sales          → id, cashier_id(FK→users), total_amount, tax_amount, sale_date
sale_items     → id, sale_id(FK), product_id(FK), quantity, unit_price, subtotal
```

## Transaction Points

Two operations use explicit JDBC transaction control (`setAutoCommit(false)`):

**StockDAO.insert** — atomically inserts a stock_entries row AND increments
`products.quantity`. If either fails, both roll back.

**SaleDAO.processSale** — inserts the sales header, then for each item:
inserts sale_items row AND decrements `products.quantity` (with a
`quantity >= ?` guard to prevent negative stock). Any failure rolls back
the entire sale.

## Role-Based Access

| Role          | Session value   | Permitted areas                                  |
|---------------|-----------------|--------------------------------------------------|
| Admin         | `ADMIN`         | Everything                                       |
| Cashier       | `CASHIER`       | /sales/billing, /sales/history (own sales only)  |
| Stock Manager | `STOCK_MANAGER` | /products (view), /stock                         |

Role is stored in `HttpSession` at login. Every servlet reads it via
`SessionUtil.getRole(req)` before taking any action.

## URL Routing

| URL                  | Servlet          | Notes                                |
|----------------------|------------------|--------------------------------------|
| /login               | LoginServlet     | GET=form, POST=authenticate          |
| /logout              | LogoutServlet    | invalidates session                  |
| /dashboard           | DashboardServlet | Admin only                           |
| /products            | ProductServlet   | ?action=add/edit/delete              |
| /categories          | CategoryServlet  | ?action=add/delete                   |
| /suppliers           | SupplierServlet  | ?action=add/view                     |
| /stock               | StockServlet     | ?action=add                          |
| /sales/billing       | SaleServlet      | Cashier + Admin                      |
| /sales/confirm       | SaleServlet      | POST — processes and redirects       |
| /sales/history       | SaleServlet      | Admin sees all; Cashier sees own     |
| /sales/print?id=X    | SaleServlet      | Print-ready bill                     |
| /users               | UserServlet      | Admin only                           |

## Security

- Passwords hashed with SHA-256 via `PasswordUtil.hash()`
- All DB queries use `PreparedStatement` — no string concatenation
- Session checked at the top of every servlet method
- `<c:out value="..."/>` used for user-generated content to prevent XSS
- Session timeout: 30 minutes (set in web.xml)
- No `javax.*` imports — all `jakarta.*` (Tomcat 10 requirement)
