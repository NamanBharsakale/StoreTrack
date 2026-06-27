# StoreTrack — Deployment Guide

## Local Development

### Prerequisites

| Tool        | Version  |
|-------------|----------|
| JDK         | 17 LTS   |
| Maven       | 3.9+     |
| MySQL       | 8.x      |
| Tomcat      | 10.1.x   |

### Step 1 — Database setup

```bash
mysql -u root -p < schema.sql
```

This creates the `storetrack` database, all tables, indexes, and seed data
including the default admin account.

Default credentials:
- Email: `admin@storetrack.com`
- Password: `admin123`

### Step 2 — Environment variables

Create a `.env` file in the project root (gitignored):

```
DB_URL=jdbc:mysql://localhost:3306/storetrack?useSSL=false&serverTimezone=UTC
DB_USER=root
DB_PASSWORD=yourpassword
```

Export before running Tomcat (or set in Tomcat's `setenv.sh`):

```bash
export DB_URL="jdbc:mysql://localhost:3306/storetrack?useSSL=false&serverTimezone=UTC"
export DB_USER="root"
export DB_PASSWORD="yourpassword"
```

### Step 3 — Build

```bash
mvn clean package
```

Output: `target/StoreTrack-1.0.0.war`

### Step 4 — Deploy to local Tomcat

```bash
cp target/StoreTrack-1.0.0.war $CATALINA_HOME/webapps/StoreTrack.war
$CATALINA_HOME/bin/startup.sh
```

Access: `http://localhost:8080/StoreTrack`

---

## Railway.app Production Deployment

### 1. Connect GitHub repository

- Go to Railway dashboard → New Project → Deploy from GitHub
- Select the `StoreTrack` repository

### 2. Add MySQL plugin

- Inside the Railway project → New → Database → MySQL
- Railway creates a MySQL instance and exposes connection variables

### 3. Set environment variables

In Railway → Variables, add:

```
DB_URL      = jdbc:mysql://<host>:<port>/railway?useSSL=false&serverTimezone=UTC
DB_USER     = root
DB_PASSWORD = <railway-provided-password>
```

Get the host/port/password from the Railway MySQL plugin's "Connect" tab.

### 4. Initialise the database

Connect to Railway MySQL and run `schema.sql`:

```bash
mysql -h <railway-host> -P <port> -u root -p < schema.sql
```

Or use the Railway shell inside the MySQL plugin.

### 5. Deploy

Railway detects the `Dockerfile` and builds automatically on every push to `main`.

Build command (Railway runs this automatically):
```bash
mvn clean package
```

The Dockerfile then copies `target/StoreTrack-1.0.0.war` into Tomcat as `ROOT.war`,
so the app serves at `/` on the Railway-provided domain.

---

## Dockerfile

```dockerfile
FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/StoreTrack-1.0.0.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

---

## Build Troubleshooting

| Problem | Fix |
|---------|-----|
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | `mysql-connector-j` not in classpath — check pom.xml |
| `jakarta.servlet` import errors | Wrong Tomcat version; use Tomcat 10+ |
| JSP 500 on JSTL tags | Missing JSTL runtime jar; check glassfish dependency in pom.xml |
| DB connection refused | Check DB_URL, DB_USER, DB_PASSWORD env vars |
| Negative stock on billing | Stock guard in SaleDAO.processSale triggers; restock the product |

---

## Default Login

| Email | Password | Role |
|-------|----------|------|
| admin@storetrack.com | admin123 | ADMIN |

Change the password after first login by resetting via admin → Users panel.
