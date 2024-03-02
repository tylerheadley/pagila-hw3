/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
LEFT JOIN LATERAL (
    SELECT
        r.customer_id,
        fc.category_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Action')
        AND r.customer_id = c.customer_id
    LIMIT 5
) AS RecentRentals ON true
GROUP BY c.customer_id
HAVING COUNT(CASE WHEN category_id = (SELECT category_id FROM category WHERE name = 'Action') THEN 1 END) >= 4
ORDER BY customer_id;
