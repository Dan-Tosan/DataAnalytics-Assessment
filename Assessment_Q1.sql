SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(p.investment_count, 0) AS investment_count,
    FORMAT(COALESCE(s.total_deposits, 0) + COALESCE(p.total_deposits, 0), 2) AS total_deposits
FROM 
    adashi_staging.users_customuser u

-- Aggregate savings data from savings_savingsaccount table
LEFT JOIN (
    SELECT 
        owner_id,
        COUNT(id) AS savings_count,
        SUM(confirmed_amount) / 100 AS total_deposits
    FROM 
        adashi_staging.savings_savingsaccount
    WHERE 
        confirmed_amount > 0
    GROUP BY 
        owner_id
) s ON u.id = s.owner_id

-- Aggregate investment data from plans_plan table
LEFT JOIN (
    SELECT 
        owner_id,
        SUM(CASE WHEN is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
        SUM(CASE WHEN is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,
        SUM(amount) / 100 AS total_deposits
    FROM 
        adashi_staging.plans_plan
    GROUP BY 
        owner_id
) p ON u.id = p.owner_id

-- Filter to include only customers with at least one funded savings and investment plan
WHERE 
    COALESCE(s.savings_count, 0) > 0 
    AND COALESCE(p.investment_count, 0) > 0

-- Order by total deposits in descending order
ORDER BY 
    total_deposits DESC;
