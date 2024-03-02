/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */

SELECT actor_id, first_name, last_name, film_id, title, r.rank, r.revenue
FROM actor a
LEFT JOIN LATERAL (
    SELECT t.title, film_id, COALESCE(t.sum, 0.00) as revenue,
        RANK () OVER (
            ORDER BY COALESCE(t.sum, 0.00) DESC, t.title 
        ) "rank"
    FROM film
    JOIN (
        SELECT f.title, film_id, SUM(p.amount)
        FROM film f
        LEFT JOIN inventory i USING (film_id)
        LEFT JOIN rental r USING (inventory_id)
        LEFT JOIN payment p USING (rental_id)
        GROUP BY title, film_id
    ) t USING (film_id)
    JOIN film_actor USING (film_id)
    WHERE actor_id = a.actor_id
    ORDER BY revenue DESC
    LIMIT 3
) r ON true
ORDER BY actor_id, rank;
