SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM (
    -- Savings Accounts Inactivity
    SELECT 
        s.id AS plan_id,
        s.owner_id,
        'Savings' AS type,
        s.transaction_date AS last_transaction_date,
        DATEDIFF(CURRENT_DATE, s.transaction_date) AS inactivity_days
    FROM 
        adashi_staging.savings_savingsaccount s
    WHERE 
        DATEDIFF(CURRENT_DATE, s.transaction_date) > 365

    UNION ALL

    -- Investment Accounts Inactivity
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        p.last_charge_date AS last_transaction_date,
        DATEDIFF(CURRENT_DATE, p.last_charge_date) AS inactivity_days
    FROM 
        adashi_staging.plans_plan p
    WHERE 
        DATEDIFF(CURRENT_DATE, p.last_charge_date) > 365
) AS inactive_accounts
ORDER BY 
    inactivity_days DESC;
