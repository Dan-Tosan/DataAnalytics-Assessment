# DataAnalytics-Assessment
This repository contains SQL scripts to solve various business-related data analysis scenarios using MySQL. Each query is structured to meet specific requirements outlined in the problem statements.
## Introduction

This assessment's purpose is to develop SQL queries that address various business scenarios in customer data analysis. Given the complexities of data structures and relationships, the focus is on optimizing data retrieval and ensuring accurate results.

---

## Problem Statements and Approaches

### 1. High-Value Customers with Multiple Products
**Scenario:** Identify customers who have both a savings and an investment plan (cross-selling opportunity).

**Approach:**
- Join the `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables.
- Use conditions to filter funded savings and investment plans.
- Aggregate data to calculate:
  - Number of funded savings plans.
  - Number of funded investment plans.
  - Total deposits.
- Sort results by the total deposits in descending order.
---

### 2. Transaction Frequency Analysis
**Scenario:** Analyze customer transaction frequency to segment them into "High Frequency", "Medium Frequency", and "Low Frequency" users.

**Approach:**
- Calculate the average number of transactions per month per customer.
- Categorize customers based on their transaction frequency:
  - **High Frequency:** ≥ 10 transactions/month
  - **Medium Frequency:** 3-9 transactions/month
  - **Low Frequency:** ≤ 2 transactions/month
- Aggregate and count customers for each category.

---

### 3. Account Inactivity Alert
**Scenario:** Identify active accounts (savings or investments) with no inflow transactions for over one year.

**Approach:**
- Identify the last transaction date from the `savings_savingsaccount` and `plans_plan` tables.
- Calculate inactivity days using the `DATEDIFF()` function.
- Filter results to include accounts where inactivity is greater than 365 days.

---
### 4. Customer Lifetime Value (CLV) Estimation
**Scenario:** Calculate the estimated CLV for each customer based on account tenure and transaction volume.

**Approach:**
- **Calculating Tenure:**
   - Use the `TIMESTAMPDIFF()` function to compute the number of months since the customer joined.
   - The difference between `u.date_joined` and the current date (`CURDATE()`) gives the tenure in months.
-  **Counting Transactions:**
   - Use `COUNT(sa.id)` to calculate the total number of transactions made by each customer.
-  **Calculating Estimated CLV:**
   - Apply the CLV formula as specified:
     \[
     CLV = \left(\frac{Total\ Transactions}{Tenure\ (months)}\right) \times 12 \times 0.1\% \times Avg\_Transaction\_Amount
     \
   - To prevent division by zero, use `NULLIF()` within the tenure calculation.
-  **Sorting Results:**
   - Order the output by `estimated_clv` in descending order.
---
### Challenges Encountered

#### 1. Incorrect Assumption about Data Structure  
Initially, I assumed that the field `is_regular_savings` was located in the `savings_savingsaccount` table. This led to confusion when identifying savings and investment plans. 

**Solution:**  
After thoroughly reviewing the database schema, I discovered that both `is_regular_savings` and `is_a_fund` were located in the `plans_plan` table instead. The query was updated accordingly to use the correct table and fields.

#### 2. Performance Optimization  
The initial query execution took a significant amount of time due to the complex calculations and the large volume of transaction data, resulting in a "Lost connection to MySQL server" error.

**Solution:** 
The following optimizations were made:
- Applied filtering conditions directly within the join clauses to minimize the data processed.  
- Reduced the use of complex nested functions, which significantly improved the query execution speed.  
---
## Conclusion

These queries provide actionable insights for business decisions, such as identifying high-value customers, categorizing customer transaction frequency, flagging inactive accounts, and estimating CLV. By optimizing data joins and using efficient SQL functions, I minimized processing time and ensured accurate results.

For more details on each query, check the respective SQL files in the repository.
