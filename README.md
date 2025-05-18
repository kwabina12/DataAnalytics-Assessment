# DataAnalytics-Assessment
This SQL Proficiency Assessment evaluates my ability to work with relational databases, solving business problems through SQL queries. It assesses my skills in data retrieval, aggregation, joins, subqueries, and data manipulation across multiple tables.

# Assessment_Q1
**Commented SQL Query**

-- Select owner ID of the user
SELECT 
    s.owner_id,
    
    -- Concatenate first and last name of the user as "Names"
    CONCAT(u.first_name, ' ', u.last_name) AS Names,

    -- Count unique savings account IDs as funded savings plans
    COUNT(DISTINCT s.id) AS funded_savings_plan,

    -- Count unique investment plans connected to the savings accounts
    COUNT(DISTINCT p.id) AS funded_investment_plan,

    -- Sum the new_balance field across all savings accounts as total deposits
    SUM(s.new_balance) AS total_deposits

FROM
    -- Join users table with savings accounts based on user ID
    users_customuser u
        JOIN savings_savingsaccount s ON u.id = s.owner_id

        -- Join savings accounts with plans based on plan ID
        JOIN plans_plan p ON s.plan_id = p.id

-- Group by user name and owner ID to aggregate correctly
GROUP BY Names, s.owner_id

-- Order result by total deposits in descending order
ORDER BY total_deposits DESC;

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


