# DataAnalytics-Assessment
This SQL Proficiency Assessment evaluates my ability to work with relational databases, solving business problems through SQL queries. It assesses my skills in data retrieval, aggregation, joins, subqueries, and data manipulation across multiple tables.

# Assessment_Q1
 **Per-Question Explanations**

1. **What is the purpose of this query?**
   The query retrieves aggregated information about users who have funded savings accounts, linking these accounts to investment plans, and calculates how much has been deposited in total.

2. **Why use `CONCAT(u.first_name, ' ', u.last_name)`?**
   To present a user-friendly full name of each account owner.

3. **Why use `COUNT(DISTINCT s.id)` and `COUNT(DISTINCT p.id)`?**
   Using `DISTINCT` ensures that duplicate account or plan entries are not double-counted when calculating the number of funded savings and investment plans.

4. **Why use `SUM(s.new_balance)`?**
   It provides the total amount deposited across all savings accounts for each user.

5. **Why group by both `Names` and `s.owner_id`?**
   Grouping by both ensures each result row is unique per user, even if two users share the same full name.

6. **Why sort with `ORDER BY total_deposits DESC`?**
   To rank users from the highest to the lowest total deposits, which is useful for prioritizing or analyzing top contributors.

 **Challenges Encountered and Resolutions**

1. **Duplicate Counting of Plans or Accounts:**
   Initially, using `COUNT(p.id)` or `COUNT(s.id)` could result in duplicates due to the joins.
   **Resolution:** Used `COUNT(DISTINCT ...)` to avoid counting the same plan/account multiple times.

2. **Ambiguity in Grouping:**
   Grouping only by `Names` caused errors or incorrect results if multiple users shared the same name.
   **Resolution:** Added `s.owner_id` to the `GROUP BY` clause to uniquely identify each user.

3. **Join Confusion Between Tables:**
   Understanding the exact relationship between `savings_savingsaccount` and `plans_plan` required clarity.
   **Resolution:** Verified that each savings account has a `plan_id` linking it to the plans table.

4. **Field Selection for Deposits:**
   Choosing the right field (`new_balance`) to represent deposits was a design choice.
   **Resolution:** Assumed `new_balance` reflects actual deposit amount — if not, further clarification on schema is needed.

# Assessment_Q2

**Per-Question Explanations**

1. **Why break it into multiple CTEs?**
   Using Common Table Expressions (CTEs) helps modularize the logic, making the query easier to read, debug, and extend.

2. **Step 1 (monthly\_transactions):**

   * Purpose: To count how many transactions each customer performs every month.
   * Key Logic: Grouped by both `owner_id` and `txn_month`.

3. **Step 2 (average\_transactions):**

   * Purpose: To compute the average number of transactions each customer performs per month.
   * Key Logic: Using `AVG(monthly_txn_count)` on the result of Step 1.

4. **Step 3 (categorized\_customers):**

   * Purpose: To classify each customer based on their average monthly transaction count.
   * Key Logic: Applied a `CASE` statement for categorization:

     * `High Frequency` ≥ 10
     * `Medium Frequency` between 3 and 9
     * `Low Frequency` < 3

5. **Step 4 (final SELECT):**

   * Purpose: Summarize the number of customers in each frequency category.
   * Key Logic: Used COUNT(*) and AVG() to aggregate, then sorted results logically using `FIELD().

 **Challenges Encountered and Resolutions**

1. **Date Grouping Complexity**

**Challenge:** Grouping transactions by month required a clean way to extract the year and month.
**Resolution:** Used `DATE_FORMAT(transaction_date, '%Y-%m') for uniform grouping.

2. **Inconsistent or NULL Transaction Dates**

**Challenge:** Some records may not have `transaction_date`, leading to skewed results.
**Resolution:** Filtered with `WHERE s.transaction_date IS NOT NULL` to avoid noise.

3. **Boundary Logic for Categorization**

**Challenge:** Ensuring the boundaries (like exactly 3 or 10) are included correctly in the desired categories.
**Resolution:** Used `BETWEEN` and `>=`/`<` carefully to make categorization unambiguous.

4. **Ordering Categories Logically**

**Challenge:** Alphabetical sorting (`ORDER BY frequency_category`) would put Low before Medium or High.
**Resolution:** Used `ORDER BY FIELD(...)` to define a custom sort order.

# Assessment_Q3
 **Per-Question Explanations**

1. **Why use `SET @today = CURDATE();`?**
   This stores today's date in a variable to ensure consistency across the query and allow potential reuse.

2. **Why use `MAX(s.transaction_date)`?**
   To find the last activity on the account. `MAX()` gives the most recent transaction date per user-plan combination.

3. **Why use `DATEDIFF(@today, MAX(...))`?**
   This calculates how many days have passed since the last transaction — a direct measure of inactivity.

4. **Why group by `s.plan_id, s.owner_id`?**
   The grouping ensures that the aggregation (like `MAX(transaction_date)`) is done per unique account (by owner and plan).

5. **Why use `HAVING inactivity_days > 365` instead of `WHERE`?**
   `HAVING` is used because `inactivity_days` is derived from an aggregate function. `WHERE` cannot filter on aggregates directly.

6. **Why label type as `'Savings'`?**
   This is a hardcoded identifier to tag the result. Useful if combined with other queries (e.g., for investments).

 **Challenges Encountered and Resolutions**

1. **Inconsistent use of aggregate filtering (`HAVING` vs. `WHERE`)**

**Challenge:** Beginners may incorrectly use `WHERE inactivity_days > 365`.
**Resolution:** Recognized that `HAVING` must be used to filter based on the result of aggregate functions.

2. **Null or Missing `transaction_date` values**

**Challenge:** Records without a transaction date can skew results or cause NULL errors.
**Resolution:** Explicitly filtered with `WHERE s.transaction_date IS NOT NULL`.

3. **Misinterpretation of inactivity logic**

**Challenge:** Clarifying whether inactivity is by customer or account.
**Resolution:** Decided to group by both `owner_id` and `plan_id` for granularity — i.e., each savings account is independently tracked.

4. **Date computation inconsistency**

**Challenge:** Using `CURDATE()` multiple times can lead to minor inconsistencies in large scripts.
**Resolution:** Used `SET @today = CURDATE();` to standardize reference date across calculations.

# Assessment_Q4
**Per-Question Explanations**

1. **Purpose of the Query**
   To estimate the **Customer Lifetime Value (CLV)** based on their savings activity and transaction frequency over time.

2. **Why use `TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())`?**
   To calculate how many months a customer has been active. This is essential for estimating their average monthly value contribution.

3. **What is the CLV Formula Here?**
   It's an approximation:
> (Total Confirmed Amount / 100) × 0.001 = monthly margin
> Divide by months of tenure to get monthly value, then annualize by multiplying by 12.

4. **Why divide by `NULLIF(..., 0)`?**
   To **prevent division by zero** when a customer joined in the current month (0 months of tenure).

5. **Why is confirmed\_amount divided by 100 and multiplied by 0.001?**
   This simulates a **conversion rate or fee structure**, e.g., converting cents to dollars and applying a 0.1% margin (platform fee or interest).

6. **Why use `COUNT(s.id)`?**
   To track how frequently each customer transacts — useful context alongside their CLV.

 **Challenges Encountered and How They Were Resolved**

1. **Divide by Zero Error**
   A major issue was calculating CLV for customers who joined in the current month, resulting in a tenure of zero. This would cause a division by zero error.
*Resolution:* Used `NULLIF(..., 0)` to safely handle such cases, ensuring the query doesn't break and returns `NULL` for CLV when tenure is zero.

2. **Inflated CLV for Recent Customers**
   Customers who recently joined but made large deposits could appear highly valuable due to short tenure, artificially boosting their CLV.
  *Resolution:* CLV was normalized by tenure to balance value over time and reduce the skew from recent big transactions.

3. **Inclusion of Invalid Transactions**
   Some transactions had `NULL` or zero `confirmed_amount` values, which could distort the total deposits and CLV estimates.
   *Resolution:* Applied strict filters to exclude such transactions using `WHERE confirmed_amount IS NOT NULL AND confirmed_amount > 0`.

4. **Assumed Platform Fee or Margin**
   The use of `0.001` as a multiplier for estimating value is a hypothetical platform margin, which may not apply to all use cases.
    *Resolution:* Clearly documented this assumption in the query comments so it can be easily adjusted based on actual business logic.





