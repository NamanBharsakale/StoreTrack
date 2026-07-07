# StoreTrack

A web-based inventory management system for small retail shops. Manage products, track stock, handle billing, and keep an eye on sales — all from the browser.

Built with plain Java (Servlets + JSP + JDBC) on purpose. No Spring, no Hibernate — just the core stack, which makes it easy to read, learn from, and extend.

## Features

- **Dashboard** — today's revenue, low stock alerts, top selling products, recent transactions, monthly revenue
- **Products** — add/edit/delete products with categories, prices, and a low-stock threshold. Products running low get a red badge
- **Billing** — search products, build a cart, auto-calculated GST and total. Stock is deducted inside a JDBC transaction, so a failed sale never leaves half-updated data. Printable bill included
- **Stock entries** — log every restock with product, supplier, quantity, and who added it. Product quantity updates automatically
- **Suppliers** — manage suppliers and see the full purchase history for each one
- **Users & roles** — Admin, Cashier, and Stock Manager, each with their own access. Admin can add users, deactivate them, and reset passwords

### Roles at a glance

| | Admin | Stock Manager | Cashier |
|---|---|---|---|
| Dashboard | ✅ | Stock only | Sales only |
| Products | Full CRUD | View | View |
| Suppliers | Full CRUD | View | — |
| Stock entry | ✅ | ✅ | — |
| Billing | ✅ | — | ✅ |
| Sales history | All | — | Own sales |
| User management | ✅ | — | — |

## Tech Stack

| Layer | Tech |
|---|---|
| Backend | Java 17, Servlets (Jakarta) |
| View | JSP + JSTL, Bootstrap 5 |
| Database | MySQL 8, plain JDBC with PreparedStatement |
| Build | Maven (WAR packaging) |
| Server | Apache Tomcat 10.1 |
| Deployment | Docker → Railway.app |

## Getting Started

### Quickest — Docker (one command)

The only requirement is Docker:

```bash
git clone https://github.com/NamanBharsakale/StoreTrack.git
cd StoreTrack
docker compose up -d
```

This builds the app, starts MySQL, seeds the schema and demo data automatically,
and serves at http://localhost:8080. Optional env vars: `DB_PASSWORD` (MySQL root
password, default `storetrack`) and `APP_PORT` (host port, default `8080`).

Stop with `docker compose down` (add `-v` to also wipe the database).

### Manual — JDK + Maven + Tomcat

You'll need JDK 17, Maven, MySQL 8, and Tomcat 10.1. Full step-by-step instructions are in [setup.md](setup.md), but the short version:

```bash
# 1. Create the database (tables + seed data)
mysql -u root -p < schema.sql

# 2. Set your DB credentials as environment variables
export DB_URL="jdbc:mysql://localhost:3306/storetrack?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
export DB_USER="root"
export DB_PASSWORD="yourpassword"

# 3. Build
mvn clean package

# 4. Deploy target/StoreTrack-1.0.0.war to Tomcat and open
#    http://localhost:8080/StoreTrack-1.0.0/
```

Default login after seeding:

```
Email:    admin@storetrack.com
Password: admin123
```

Change it after first login.

## Project Structure

```
src/main/java/com/storetrack/
├── model/      ← POJOs (User, Product, Sale, ...)
├── dao/        ← all SQL lives here, one DAO per table
├── servlet/    ← HTTP controllers, one per module
└── util/       ← DBConnection, SessionUtil, PasswordUtil

src/main/webapp/
├── includes/   ← shared sidebar, header, footer
├── products/, categories/, suppliers/, stock/, sales/, users/
├── login.jsp, dashboard.jsp
└── WEB-INF/web.xml
```

The flow is the same everywhere: **Servlet → DAO → MySQL**, with JSP handling display only. No SQL in servlets, no logic in JSPs.

## Deployment

The included `Dockerfile` packages the WAR into a Tomcat 10.1 image, ready for Railway (or any Docker host):

```bash
mvn clean package
docker build -t storetrack .
docker run -p 8080:8080 -e DB_URL=... -e DB_USER=... -e DB_PASSWORD=... storetrack
```

See [docs/deployment.md](docs/deployment.md) for the full Railway walkthrough and [docs/architecture.md](docs/architecture.md) for design details.

## License

Free to use for learning and personal projects.
