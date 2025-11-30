-- Q1. Total revenue by gender
SELECT gender, 
       SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;


-- Q2. Customers who used a discount and spent above average
SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount > (SELECT AVG(purchase_amount) FROM customer);


-- Q3. Top 5 products by highest average review rating
SELECT item_purchased, 
       ROUND(AVG(review_rating), 2) AS avg_rating
FROM customer
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;


-- Q4. Average purchase amount by shipping type
SELECT shipping_type, 
       ROUND(AVG(purchase_amount), 2) AS avg_purchase
FROM customer
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type;


-- Q5. Subscriber vs non-subscriber comparison
SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount),2) AS avg_spend,
       ROUND(SUM(purchase_amount),2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC, avg_spend DESC;


-- Q6. Products with highest discount usage percentage
SELECT item_purchased,
       ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


-- Q7. Customer segmentation into New, Returning, Loyal
WITH customer_type AS (
    SELECT customer_id,
           CASE
                WHEN previous_purchases = 1 THEN 'New'
                WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
                ELSE 'Loyal'
           END AS customer_segment
    FROM customer
)
SELECT customer_segment, 
       COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;


-- Q8. Top 3 most purchased products per category
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(*) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;


-- Q9. Repeat buyers and subscription status
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;


-- Q10. Revenue contribution by age group
SELECT age_group,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;
