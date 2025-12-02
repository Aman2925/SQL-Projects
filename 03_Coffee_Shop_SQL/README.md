# ☕ CoffeeShop SQL Analytics Project

A hands-on SQL project that models the daily operations of a modern coffee shop.
This case study highlights how relational databases can be used to understand sales trends, manage staff scheduling, and monitor ingredient consumption using MySQLWorkBench.

---

## 🗂️ Database Structure & Table Overview

* **coffeeshop** – Mapping between store locations and operational metadata
* **rota** – Daily staff rotations indicating who works which shift
* **shift** – Master list of shift timings (weekday, start/end times)
* **staff** – Employee roster with roles, wages, and personal details
* **menu_items** – Complete menu catalog with product type, size variants, and pricing
* **orders** – Transaction log capturing each order timestamp, item, and quantity sold
* **ingredients** – List of raw materials used in menu preparation with units and cost
* **inventory** – Real-time stock tracking of all ingredients currently available
* **recipe** – Recipe breakdown showing ingredients required for each menu item

---

## 🎯 Insights & Analytical Outputs

1. **Revenue & Sales Insights**

   * Identification of top revenue-driving beverages and food items
   * Items with consistently low movement for potential removal or promotional focus
   * Time-of-day analysis to find peak customer traffic windows

2. **Menu Optimization & Pricing Evaluation**

   * Price-value comparison based on item demand
   * Recommendations on upselling or bundling opportunities
   * Dynamic suggestions for adjusting prices during high-demand periods

3. **Inventory Monitoring & Usage Patterns**

   * Alerts for ingredients nearing depletion
   * Average consumption rates derived from recipe & order logs
   * Forecasting of stock longevity and reorder requirements
   * Simulation-based restocking strategy for efficient inventory control

---

## 🚀 SQL Concepts & Techniques Demonstrated

* Multi-table joins using **INNER**, **LEFT**, and **RIGHT** joins
* Analytical queries with **GROUP BY**, **HAVING**, and window functions
* **CTEs (Common Table Expressions)** for readable query design
* **Recursive SQL** used for forward inventory prediction
* Data validation and transformation techniques (type conversions, deduplication)
* Business logic implementation using **CASE**, conditional filters, and calculated fields

---


