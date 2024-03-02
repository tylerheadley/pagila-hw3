/*
 * Find every documentary film that is rated PG.
 * Report the title and the actors.
 *
 * HINT:
 * Getting the formatting right on this query can be tricky.
 * You are welcome to try to manually get the correct formatting.
 * But there is also a view in the database that contains the correct formatting,
 * and you can SELECT from that VIEW instead of constructing the entire query manually.
 */

 
SELECT t.title, STRING_AGG(t.name, ', ') AS actors 
FROM (
    SELECT title, INITCAP(first_name) || INITCAP(last_name) AS name
    FROM actor a
    JOIN film_actor fa USING (actor_id)
    JOIN film f USING (film_id)
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
    WHERE f.rating='G' AND c.name='Documentary'
) t
GROUP BY t.title
ORDER BY title;

