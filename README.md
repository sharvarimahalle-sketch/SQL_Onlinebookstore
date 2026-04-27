# 📚 Online Bookstore Analytics — SQL Portfolio Project

## 📌 Project Overview
This project simulates a real-world analytics engagement for an online bookstore. Using transactional data across books, customers and orders, it surfaces actionable insights from identifying top selling genres and at risk inventory, to ranking high value customers and detecting seasonal trends.

---
## 🧩 Problem Statement
Without structured data analysis, critical decisions — when to restock, which customers to target, which genres to invest in get made on gut feel. This project  turns raw transactional data into clear business actions.

---
## 🎯 Objectives
- Analyse sales performance across genres, authors and time periods
- Identify high value customers
- Monitor inventory levels and surface reorder alerts before stockouts occur
- Calculate each genre's contribution to total platform revenue
- Detect bulk-buying behaviour to support wholesale pricing strategies

---
## 🗂️ Dataset Description

| Table      | Description |
|---==|------|
| `Books`    | Product catalogue — title, author, genre, published year, price, stock |
| `Customers`| User profiles — name, email, city, country |
| `Orders`   | Transactions — customer, book, quantity, amount, date |

> Simulated dataset reflecting realistic e-commerce patterns. No real customer data used.

---
## 🔗 Schema Overview

```
Customers ──< Orders >── Books
```
Three normalised tables linked by foreign keys. `Orders` is the central bridge connecting customers to the books they purchased, a standard e-commerce data model.

---
## 🔍 Key SQL Analysis

### 📦 Inventory & Catalogue
- Stock health summary (total, average, min/max units on hand)
- Top 5 reorder candidates ranked by lowest remaining stock
- Genre-level catalogue audit showing title count, avg price, and total stock

### 💰 Revenue & Financial Performance
- Platform revenue summary — total income, order count, and average order value
- High value transaction filter (orders above $200) for revenue analysis and fraud screening
- Genre revenue breakdown to identify which categories drive volume vs margin
- Author-level performance rollup to support partnership and promotion decisions

### 👤 Customer Behaviour & Segmentation
- Repeat buyer identification using `GROUP BY` + `HAVING` (≥ 2 orders)
- Bulk order detection (quantity > 1) to flag wholesale and institutional buyers
- Top spending customer ranked by lifetime value
- City level spend clustering for localised marketing campaigns

### 📈 Trends & Time-Based Analysis
- Monthly sales monitoring using index-friendly `BETWEEN` date ranges
- Most frequently ordered title (order frequency vs raw units sold)
- Recently published titles to keep the catalogue fresh and relevant

---
## 💡 Key Insights
1. Revenue concentrates in 2–3 genres - Catalogue investment should follow, not spread evenly.
2. Dormant users are an untapped revenue pool — Customers who registered but never ordered can be converted through re-engagement campaigns at a fraction of new user acquisition cost.
3. Stock risk is uneven across titles — A handful of books are near stockout while others have excess inventory, signalling that procurement decisions aren't currently data-driven.
4. Bulk buyers deserve their own pricing tier — Orders with quantity > 1 often represent schools, office or book clubs. A wholesale or institutional tier could significantly increase order value.
5. A few authors drive most revenue 
6. Premium customers cluster geographically — City level spend analysis pinpoints locations worth targeting with localised ads or events rather than broad campaigns.

---

## 🛠️ Tools & Technologies - MySQL
SQL concepts used:`INNER JOIN`, `LEFT JOIN`, `GROUP BY`, `HAVING`, aggregate functions (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`), `COALESCE`, `DISTINCT`, `BETWEEN`, `LIMIT`

---
## 📁 Project Structure

```
online-bookstore-sql/
├── OnlineBookstore.sql    # All queries with inline business-context comments
└── README.md              # This file
```
---

## 🚀 Future Improvements

- Power BI / Tableau dashboard to make insights accessible to non-technical stakeholders
- Demand forecasting using Python  on top of the monthly revenue trend data
- Customer churn model using dormant account data as a training signal

---
🔗 Connect with Me LinkedIn: www.linkedin.com/in/sharvarimahalle 
-   Email: sgmahalle23@gmail.com
