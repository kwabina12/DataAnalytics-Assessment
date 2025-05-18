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
