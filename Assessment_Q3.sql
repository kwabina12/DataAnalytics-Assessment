-- Get today's date
SET @today = CURDATE();

-- Query to find inactive accounts
SELECT 
    s.plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(@today, MAX(s.transaction_date)) AS inactivity_days
FROM savings_savingsaccount s
WHERE s.transaction_date IS NOT NULL
GROUP BY s.plan_id, s.owner_id
HAVING inactivity_days > 365;
