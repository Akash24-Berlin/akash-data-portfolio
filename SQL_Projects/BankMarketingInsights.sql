-- Dataset Context:
--This dataset contains information on a direct marketing campaign by a Portuguese bank. The campaign aimed to get customers to subscribe to a term deposit. 
--Each row represents a customer and includes features such as age, job, marital status, contact method, previous interactions, and whether the customer subscribed (y column).
--Question 1: What’s the overall subscription rate?
--Explanation:
--We want to understand how successful the marketing campaign was by finding out what percentage of customers subscribed (y = 'yes') compared to the total population.
Use BankMarketingDB
SELECT 
    y,
    COUNT(*) AS total,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM bank_data), 2) AS percentage
FROM 
    bank_data
GROUP BY 
    y;

--Question 2: What’s the average age of customers who subscribed vs. those who didn’t?
--Explanation:
--Here we’re comparing the average age between subscribers and non-subscribers to understand if age plays a role in decision-making.

SELECT 
    y,
    ROUND(AVG(age), 1) AS average_age
FROM 
    bank_data
GROUP BY 
    y;

--Question 3: Which job titles had the highest subscription rates?
--Explanation:
--We break down subscription behavior by job category to identify which profession responded most positively to the campaign. This could help tailor future targeting.

SELECT 
    job,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM 
    bank_data
GROUP BY 
    job
ORDER BY 
    subscription_rate DESC;

--Question 4: What is the average balance for subscribed vs. non-subscribed customers?
--Explanation:
--Financial standing might influence the decision to subscribe. Comparing average balance between subscribers and non-subscribers can reveal this insight.


SELECT 
    y,
    ROUND(AVG(balance), 2) AS average_balance
FROM 
    bank_data
GROUP BY 
    y;


--Question 5: How does marital status influence subscription rates?
--Explanation:
--Marital status might affect financial priorities and risk-taking behavior. This query shows which group was most likely to subscribe.

SELECT 
    marital,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM 
    bank_data
GROUP BY 
    marital
ORDER BY 
    subscription_rate DESC;

	
--Question 6: How does housing loan status impact subscription behavior?
--Explanation:
--People with existing financial commitments like housing loans may respond differently to offers. This query compares how likely people are to subscribe based on their housing loan status.

SELECT 
    housing,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM 
    bank_data
GROUP BY 
    housing
ORDER BY 
    subscription_rate DESC;

--Question 7: What’s the impact of contact communication type (cellular vs. telephone) on subscription rate?
--Explanation:
--Different communication channels may affect campaign success. We’ll analyze which type was more effective in converting users.

SELECT 
    contact,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM 
    bank_data
GROUP BY 
    contact
ORDER BY 
    subscription_rate DESC;


--Question 8: How does call duration influence subscription rate?
--Explanation:
--Longer calls might indicate more interest or better engagement. We’ll bucket the duration into ranges and analyze subscription behavior by range.
SELECT 
    CASE 
        WHEN duration < 100 THEN 'Under 100s'
        WHEN duration BETWEEN 100 AND 300 THEN '100-300s'
        WHEN duration BETWEEN 301 AND 600 THEN '301-600s'
        ELSE 'Over 600s'
    END AS duration_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM 
    bank_data
GROUP BY 
    CASE 
        WHEN duration < 100 THEN 'Under 100s'
        WHEN duration BETWEEN 100 AND 300 THEN '100-300s'
        WHEN duration BETWEEN 301 AND 600 THEN '301-600s'
        ELSE 'Over 600s'
    END
ORDER BY 
    subscription_rate DESC;

--Question 9: How does education level affect subscription behavior?
--Explanation:
--Education might influence awareness, trust in financial products, and decision-making. This query shows how likely people are to subscribe based on their education level
SELECT 
    education,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM 
    bank_data
GROUP BY 
    education
ORDER BY 
    subscription_rate DESC;

--Question 10: Does the type of contact method affect subscription rates?
--Explanation:
--Some communication channels might be more persuasive than others. This question explores whether customers contacted via cellphone vs. telephone were more likely to subscribe.
SELECT 
    contact,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM 
    bank_data
GROUP BY 
    contact
ORDER BY 
    subscription_rate DESC;

--Question 11: Does education level impact subscription rate?
-- Explanation:
-- Higher or lower education might influence financial decision-making. Let’s see which education group subscribed the most.

SELECT 
    education,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY education
ORDER BY subscription_rate DESC;



--Question 12: Subscription rate by default status (credit in default)?
-- Explanation:
-- People with financial defaults might behave differently with new financial products.

SELECT 
    [default],
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY [default]
ORDER BY subscription_rate DESC;



--Question 13: Subscription rate by loan status
-- Explanation:
-- Personal loan holders may or may not be open to more investment offers.
SELECT 
    loan,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY loan
ORDER BY subscription_rate DESC;



--Question 14: Does contact method (cellular vs. telephone) affect outcome?
-- Explanation:
-- Some methods may convert better (e.g. mobile might have better response).

SELECT 
    contact,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY contact
ORDER BY subscription_rate DESC;



--Question 15: Month-wise campaign performance
-- Explanation:
-- See which months had the highest conversion to optimize timing of future campaigns.

SELECT 
    month,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY month
ORDER BY subscription_rate DESC;



--Question 16: Day of the week performance
-- Explanation:
-- Are people more likely to say “yes” on certain weekdays?

SELECT 
    day,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY day
ORDER BY subscription_rate DESC;


--Question 17: Average duration of contact for subscribers vs. non-subscribers
-- Explanation:
-- Longer conversations may indicate higher conversion chances.

SELECT 
    y,
    ROUND(AVG(duration), 2) AS avg_duration_seconds
FROM bank_data
GROUP BY y;

--Question 18: Is there a duration threshold for higher conversion?
-- Explanation:
-- Segment durations to see if longer calls lead to more “yes” responses.

SELECT 
    CASE 
        WHEN duration < 100 THEN '<100 sec'
        WHEN duration BETWEEN 100 AND 300 THEN '100-300 sec'
        WHEN duration BETWEEN 301 AND 600 THEN '301-600 sec'
        ELSE '600+ sec'
    END AS duration_range,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY 
    CASE 
        WHEN duration < 100 THEN '<100 sec'
        WHEN duration BETWEEN 100 AND 300 THEN '100-300 sec'
        WHEN duration BETWEEN 301 AND 600 THEN '301-600 sec'
        ELSE '600+ sec'
    END
ORDER BY subscription_rate DESC;



--Question 19: Which age groups subscribed the most?
-- Explanation:
-- Binning age to see which generation converts best.

SELECT 
    CASE 
        WHEN age < 25 THEN '<25'
        WHEN age BETWEEN 25 AND 35 THEN '25-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY 
    CASE 
        WHEN age < 25 THEN '<25'
        WHEN age BETWEEN 25 AND 35 THEN '25-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END
ORDER BY subscription_rate DESC;



--Question 20: Did previous campaign success impact new subscription?
-- Explanation:
-- Let’s see if people who responded in a previous campaign said yes again.

SELECT 
    poutcome,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY poutcome
ORDER BY subscription_rate DESC;



--Question 21: Is number of previous contacts (campaign touches) effective?
-- Explanation:
-- Let’s check if more contact attempts result in more success.

SELECT 
    previous,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY previous
ORDER BY subscription_rate DESC;



--Question 22: Which job type has the highest avg. balance?
-- Explanation:
-- Could help find high-value clients even if they didn’t convert.

SELECT 
    job,
    ROUND(AVG(balance), 2) AS avg_balance
FROM bank_data
GROUP BY job
ORDER BY avg_balance DESC;



--Question 23: Subscription rate by job & education combined
-- Explanation:
-- A combo filter to reveal overlap between profession and education.

SELECT 
    job,
    education,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY job, education
ORDER BY subscription_rate DESC;



--Question 24: Who has the highest avg. duration per job type?
-- Explanation:
-- Maybe some jobs just take more time to convert.

SELECT 
    job,
    ROUND(AVG(duration), 2) AS avg_call_duration
FROM bank_data
GROUP BY job
ORDER BY avg_call_duration DESC;



--Question 25: Final: Top 10 job/age group combos by subscription rate
-- Explanation:
-- Granular segmentation by job + age bucket to identify prime target personas.

SELECT 
    job,
    CASE 
        WHEN age < 25 THEN '<25'
        WHEN age BETWEEN 25 AND 35 THEN '25-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) AS subscribers,
    ROUND(100.0 * SUM(CASE WHEN y = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_rate
FROM bank_data
GROUP BY 
    job,
    CASE 
        WHEN age < 25 THEN '<25'
        WHEN age BETWEEN 25 AND 35 THEN '25-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END
ORDER BY subscription_rate DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

