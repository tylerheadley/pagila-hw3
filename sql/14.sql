/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

SELECT name, title, r."total rentals"
FROM category c
LEFT JOIN LATERAL (
    SELECT t.title, film_id, COALESCE(t.count, 0.00) as "total rentals"
    FROM film
    JOIN (
        SELECT f.title, film_id, count(rental_id)
        FROM film f
        LEFT JOIN inventory i USING (film_id)
        LEFT JOIN rental r USING (inventory_id)
        GROUP BY title, film_id
    ) t USING (film_id)
    JOIN film_category USING (film_id)
    WHERE category_id = c.category_id
    ORDER BY "total rentals" DESC, title DESC
    LIMIT 5
) r ON true
ORDER BY name, "total rentals" DESC, title;
