# 🍎 Apple iTunes Music Store Sales Analysis

> **Project Objective:** An end-to-end data analysis project using **SQL** and **Power BI** to explore user behavior, purchase patterns, and global sales trends for the Apple iTunes music service.

---

## 📋 Table of Contents

* [Project Overview](https://www.google.com/search?q=%23-project-overview)
* [Data Model & Schema](https://www.google.com/search?q=%23-data-model--schema)
* [Technical Skills Demonstrated](https://www.google.com/search?q=%23-technical-skills-demonstrated)
* [Key Business Insights](https://www.google.com/search?q=%23-key-business-insights)
* [Geographic & Sales Trends](https://www.google.com/search?q=%23-geographic--sales-trends)
* [Operational Efficiency](https://www.google.com/search?q=%23-operational-efficiency)
* [Strategic Recommendations](https://www.google.com/search?q=%23-strategic-recommendations)
* <a href="#dashboard">Dashboard</a>


---

## 🔍 Project Overview

This project analyzes a relational database containing 11 tables (Invoices, Customers, Tracks, etc.) to uncover growth opportunities for a digital music store. The study focuses on identifying high-value customers, analyzing genre-based revenue concentration, and evaluating sales representative performance.

---

## 🗄 Data Model & Schema

The project links multiple datasets to create a comprehensive view of the business:

* **Core Sales:** `Invoice`, `Invoice Line`, `Track`.
* **Customer Data:** `Customer`, `Employee`.
* **Content Catalog:** `Genre`, `Artist`, `Album`, `Playlist`.

---

## 🛠 Technical Skills Demonstrated

* **Advanced Aggregations:** Calculating Customer Lifetime Value (CLV) and monthly revenue growth.
* **Date-Time Analysis:** Identifying churned customers using inactivity thresholds (6-month windows).
* **Correlation Analysis:** Evaluating the relationship between catalog size (number of tracks) and total revenue.
* **Normalization & Joins:** Connecting 5+ tables to map country-wise genre preferences.

---

## 💡 Key Business Insights

### 1. Customer Analytics & Retention

* **Retention:** 100% of the 59 customers are **repeat purchasers**, indicating high engagement.
* **CLV:** The average **Customer Lifetime Value** is **$79.82**.
* **Churn Risk:** Identified specific customers who haven't purchased since June 2020 for targeted re-engagement.

### 2. Product & Genre Performance

* **The Rock Dominance:** **Rock** is the globally dominant genre, generating over **$2,608** in revenue (nearly 4x its closest competitor, Metal).
* **Catalog Correlation:** There is a strong positive correlation between the number of tracks available and total sales.
* **Underperforming Content:** **27.7% of albums** have never been purchased, suggesting a need for a catalog review or promotional pricing.

### 3. Pricing Strategy

* **Tiered Pricing:** The store uses a fixed two-tier system:
* **Standard ($0.99):** All Music Genres.
* **Premium ($1.99):** TV Shows, Sci-Fi, and Drama.



---

## 🌎 Geographic & Sales Trends

* **Top Market:** The **USA** is the largest market, contributing **$1,040** in revenue (22% of the customer base).
* **Underserved Region:** **Canada** has the 2nd highest customer count but lower-than-average spending per customer ($67 vs $80 in the USA), signaling a major opportunity for upselling.
* **Global Rock Culture:** Rock is the #1 genre in almost every country, while **Alternative & Punk** show specific regional strength in the USA and Brazil.

---

## 📈 Operational Efficiency

* **Sales Leaders:** **Jane Peacock** is the top-performing Sales Support Agent ($1,731 in revenue).
* **High-Value Management:** Jane and Steve manage the majority of the "Top 10 High-Spenders."
* **Workload:** Each agent manages an average of **19 customers**.

---

## 🚀 Strategic Recommendations

1. **Upsell the Canadian Market:** Since Canada has many users but lower spending, introduce bundled "Album Credits" or exclusive content to increase the average invoice value from $7.67.
2. **Promote the "Silent Catalog":** Use the 27.7% of unpurchased albums to create "Flash Sales" or "Discovery Playlists" to monetize dead inventory.
3. **Incentivize Mid-Tier Agents:** Introduce performance rewards for agents to bridge the gap between Jane Peacock and the rest of the sales team.
4. **Q1 Marketing Focus:** Capitalize on the strong purchasing trends in **January–April** with "New Year, New Music" campaigns.

---

<h2><a class="anchor" id="#Dashboard"></a>Dashboard</h2>

<img width="1127" height="731" alt="image" src="https://github.com/user-attachments/assets/96116775-68a6-4b9f-bd42-3b66d1b27969" />


