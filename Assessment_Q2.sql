SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT 
        CASE 
            WHEN (COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), CURRENT_DATE), 1)) >= 10 THEN 'High Frequency'
            WHEN (COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), CURRENT_DATE), 1)) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), CURRENT_DATE), 1) AS avg_transactions_per_month
    FROM 
        adashi_staging.users_customuser u
    LEFT JOIN 
        adashi_staging.savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY 
        u.id
) AS subquery
GROUP BY 
    frequency_category;
