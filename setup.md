# StoreTrack — Local Setup Guide

Step-by-step instructions to get StoreTrack running on your machine.

---

## Prerequisites

Install these before starting:

| Tool | Version | Download |
|------|---------|----------|
| JDK | 17 LTS | https://adoptium.net |
| Maven | 3.9+ | https://maven.apache.org/download.cgi |
| MySQL | 8.x | https://dev.mysql.com/downloads/mysql/ |
| Apache Tomcat | 10.1.x | https://tomcat.apache.org/download-10.cgi |

### Installing on Ubuntu / Debian

With sudo access:

```bash
sudo apt update
sudo apt install openjdk-17-jdk maven mysql-server
```

Tomcat is easiest as a plain download (the apt package changes paths and permissions):

```bash
curl -sSL -o /tmp/tomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz
mkdir -p ~/tools && tar xzf /tmp/tomcat.tar.gz -C ~/tools
```

### Installing without sudo (user-level)

Both Maven and Tomcat are just tarballs — no root needed:

```bash
mkdir -p ~/tools
curl -sSL https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz | tar xz -C ~/tools
curl -sSL https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz | tar xz -C ~/tools
```

Then add them to your shell profile (`~/.bashrc`):

```bash
export MAVEN_HOME="$HOME/tools/apache-maven-3.9.9"
export CATALINA_HOME="$HOME/tools/apache-tomcat-10.1.34"
export PATH="$MAVEN_HOME/bin:$PATH"
```

Reload with `source ~/.bashrc`.

Verify installations:
```bash
java -version      # should say openjdk 17...
mvn -version       # should say Apache Maven 3.9...
mysql --version    # should say 8.x...
$CATALINA_HOME/bin/version.sh   # should say Apache Tomcat/10.1.x
```

---

## Step 1 — Clone the repository

```bash
git clone https://github.com/NamanBharsakale/StoreTrack.git
cd StoreTrack
```

---

## Step 2 — Create the database

Start MySQL and run the schema script:

```bash
mysql -u root -p < schema.sql
```

This creates the `storetrack` database with all 7 tables, indexes, and seed data.

To verify:
```bash
mysql -u root -p -e "USE storetrack; SHOW TABLES;"
```

Expected output:
```
+----------------------+
| Tables_in_storetrack |
+----------------------+
| categories           |
| products             |
| sale_items           |
| sales                |
| stock_entries        |
| suppliers            |
| users                |
+----------------------+
```

---

## Step 3 — Set environment variables

StoreTrack reads DB credentials from environment variables. Set them in your terminal session:

**Linux / macOS:**
```bash
export DB_URL="jdbc:mysql://localhost:3306/storetrack?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
export DB_USER="root"
export DB_PASSWORD="your_mysql_password"
```

**Windows (Command Prompt):**
```cmd
set DB_URL=jdbc:mysql://localhost:3306/storetrack?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
set DB_USER=root
set DB_PASSWORD=your_mysql_password
```

**Windows (PowerShell):**
```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/storetrack?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
$env:DB_USER="root"
$env:DB_PASSWORD="your_mysql_password"
```

> These env vars must be set in the same terminal session where you start Tomcat.
> For a permanent setup, add them to Tomcat's `bin/setenv.sh` (Linux/macOS) or
> `bin/setenv.bat` (Windows) — create the file if it doesn't exist.

**setenv.sh example:**
```bash
#!/bin/bash
export DB_URL="jdbc:mysql://localhost:3306/storetrack?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
export DB_USER="root"
export DB_PASSWORD="your_mysql_password"
```

---

## Step 4 — Build the project

```bash
mvn clean package
```

This compiles all Java files and packages everything into:
```
target/StoreTrack-1.0.0.war
```

If the build fails, check:
- JDK 17 is active (`java -version`)
- You're inside the `StoreTrack/` directory (where `pom.xml` is)

---

## Step 5 — Deploy to Tomcat

Copy the WAR file into Tomcat's webapps folder:

```bash
cp target/StoreTrack-1.0.0.war /path/to/tomcat/webapps/
```

Replace `/path/to/tomcat` with your actual Tomcat installation path, e.g.:
- Linux: `/opt/tomcat` or `~/tools/apache-tomcat-10.1.34` (if installed as above)
- macOS: `~/apache-tomcat-10.1.x`
- Windows: `C:\tomcat`

---

## Step 6 — Start Tomcat

**Linux / macOS:**
```bash
/path/to/tomcat/bin/startup.sh
```

**Windows:**
```cmd
C:\tomcat\bin\startup.bat
```

Watch the logs to confirm startup:
```bash
tail -f /path/to/tomcat/logs/catalina.out
```

You should see something like:
```
INFO: Deployment of web application archive [.../StoreTrack-1.0.0.war] has finished in 1,234 ms
INFO: Server startup in [2345] milliseconds
```

---

## Step 7 — Open in browser

```
http://localhost:8080/StoreTrack
```

You will be redirected to the login page.

---

## Default Login

| Email | Password | Role |
|-------|----------|------|
| admin@storetrack.com | admin123 | Admin |

After login:
- **Admin** → Dashboard
- **Cashier** → Billing page
- **Stock Manager** → Stock entry page

---

## Add Test Users

After logging in as Admin, go to **Users → Add User** to create:
- A Cashier account to test the billing flow
- A Stock Manager account to test stock entry

---

## Common Errors and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Communications link failure` | MySQL not running or wrong port | Start MySQL: `sudo systemctl start mysql` |
| `Access denied for user 'root'` | Wrong DB_PASSWORD | Re-check the env var value |
| `Public Key Retrieval is not allowed` | MySQL 8 `caching_sha2_password` over non-SSL | Add `allowPublicKeyRetrieval=true` to DB_URL (already in the examples above) |
| `java.lang.ClassNotFoundException: com.mysql.cj.jdbc.Driver` | mysql-connector JAR missing | Run `mvn clean package` again |
| `HTTP 404` on `/StoreTrack` | WAR not deployed or Tomcat not restarted | Check `webapps/` folder, restart Tomcat |
| JSP shows raw tags (`${variable}`) | JSTL runtime missing | Ensure `glassfish` dependency is in pom.xml — it should be |
| `javax.servlet` import error | Wrong Tomcat version | Must use **Tomcat 10.1**, not 9.x |
| Blank page after login | Session not created | Check Tomcat logs for stack trace |

---

## Stopping Tomcat

**Linux / macOS:**
```bash
/path/to/tomcat/bin/shutdown.sh
```

**Windows:**
```cmd
C:\tomcat\bin\shutdown.bat
```

---

## Project Structure Quick Reference

```
StoreTrack/
├── src/main/java/com/storetrack/
│   ├── model/      ← POJOs (User, Product, Sale, ...)
│   ├── dao/        ← All SQL / JDBC
│   ├── servlet/    ← HTTP controllers
│   └── util/       ← DBConnection, SessionUtil, PasswordUtil
├── src/main/webapp/
│   ├── WEB-INF/web.xml
│   ├── assets/css/style.css
│   ├── assets/js/main.js
│   ├── includes/   ← sidebar.jsp, header.jsp, footer.jsp
│   ├── login.jsp, dashboard.jsp, ...
│   ├── products/   ← list.jsp, add.jsp, edit.jsp
│   ├── sales/      ← billing.jsp, history.jsp, bill-print.jsp
│   └── ...
├── pom.xml         ← Maven build + dependencies
├── schema.sql      ← Database creation script
└── Dockerfile      ← For Railway.app deployment
```
