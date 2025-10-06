# Car-Sales-After-Sales-Management-System-MySQL-Project-
a complete relational database project featuring normalized schema design, sample data, analytical SQL queries, views, indexing, and performance optimization.

### 📘 Overview

This project implements a **Car Sales and After-Sales Management System** using **MySQL**.
It was developed as part of the *Enterprise Database Management Systems (EWDBMS)* assignment and demonstrates full-cycle database design — from conceptual modeling to optimization and analytics.

The system manages **new and used car sales**, **customer service orders**, **appointments**, **technicians**, **parts**, **suppliers**, **insurance policies**, and **invoices**, providing an end-to-end relational solution.

---

### 🧩 Features

* Fully **normalized relational schema** (up to 3NF)
* **15+ relational tables** including multiple **junction (bridge) tables** for M:N relationships
* **Data integrity** via primary, foreign, and unique key constraints
* **Indexes** for performance optimization
* **Views** for aggregated business insights
* **Advanced SQL analytics** with joins, subqueries, window functions, and CASE logic
* **query performance optimization** documentation

---

### 🏗️ Database Design

The schema includes the following core entities:

* `customer`, `brand`, `model`, `vehicle`, `sale`
* `salesperson`, `appointment`, `serviceorder`
* `technician`, `service_technicians`, `part`, `service_parts`
* `supplier`, `part_suppliers`, `insurancepolicy`, `vehicle_insurance`
* `invoice`

**Junction Tables (M:N Relationships):**

* `service_technicians` – links technicians to service orders
* `service_parts` – links parts used in each service
* `part_suppliers` – connects parts with multiple suppliers

---

### 💾 Implementation

All database objects are created using **MySQL DDL and DML statements**.
Each table includes constraints such as `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, and `CHECK`.
Performance was enhanced by adding **composite indexes** and **unique indexes** on key attributes.

To set up:

```sql
CREATE DATABASE Cars_Management_System;
USE Cars_Management_System;
```

---

### 📊 Views Created

#### 1️⃣ Sales Summary by Brand

Summarizes total sales and revenue per car brand.

```sql
CREATE VIEW vw_sales_summary_by_brand AS
SELECT 
    b.name AS brand_name,
    COUNT(s.sale_id) AS total_sales,
    SUM(s.sale_price) AS total_revenue,
    ROUND(AVG(s.sale_price),2) AS average_sale_price
FROM sale s
JOIN vehicle v ON s.vehicle_id = v.vehicle_id
JOIN model m ON v.model_id = m.model_id
JOIN brand b ON m.brand_id = b.brand_id
GROUP BY b.name
ORDER BY total_revenue DESC;
```

#### 2️⃣ Monthly Sales Trend

Shows total sales and average sale value per month.

```sql
CREATE VIEW vw_monthly_sales_trend AS
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    COUNT(sale_id) AS total_sales,
    SUM(sale_price) AS monthly_revenue,
    ROUND(AVG(sale_price),2) AS avg_sale_value
FROM sale
GROUP BY sale_month
ORDER BY sale_month;
```

---

### 📈 Advanced Analytical Queries

Examples include:

* Top-performing salespersons
* Brand-wise total sales and revenue
* Monthly service costs using window functions
* Customer segmentation by purchase frequency
* Revenue comparison using subqueries and CASE

---

### ⚙️ Optimization Techniques

* Added **composite indexes** on `sale(customer_id, sale_date)` and `serviceorder(vehicle_id, received_date)`
* Rewrote complex join queries using **pre-aggregated views**
* Resulted in **~70–80% faster query performance**

---

### 🧠 Learning Reflection

This project provided hands-on experience in:

* Logical database design and normalization
* Implementing real-world relationships in SQL
* Query tuning, indexing, and optimization
* Applying theoretical concepts (CAP theorem) to practice
* Structuring a scalable, data-driven system in MySQL

---

### 👨‍💻 Author

**[Muhammad Fauzan]**
MSc Data Analytics
*(Berlin School of Business and Innovation BSBI)*

---
