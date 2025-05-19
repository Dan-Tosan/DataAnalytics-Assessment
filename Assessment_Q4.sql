SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    ROUND((
        (COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) 
        * 12 
        * 0.001 
        * AVG(sa.confirmed_amount)
    ), 2) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount sa ON sa.owner_id = u.id
GROUP BY u.id, u.name, u.date_joined
ORDER BY estimated_clv DESC;