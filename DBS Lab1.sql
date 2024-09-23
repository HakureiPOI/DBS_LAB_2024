-- DBS Lab1. --

-- Q1. -- 

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.address,
    a.district,
    ci.city,
    co.country
FROM 
    customer c
LEFT JOIN address a 
    ON c.address_id = a.address_id
LEFT JOIN city ci
    ON a.city_id = ci.city_id
LEFT JOIN country co
    ON ci.country_id = co.country_id
WHERE 
    co.country = 'France';
    

-- Q2. --

SELECT 
f.title
FROM 
    film f
LEFT JOIN film_category fc 
    ON f.film_id = fc.film_id
LEFT JOIN category c 
    ON fc.category_id = c.category_id
WHERE 
    c.name = 'Children'
AND 
    f.title REGEXP '^(J|j).*';
    

-- Q3. --

SELECT 
    c.first_name,
    c.last_name,
    cp.total_amount AS expense
FROM 
    (SELECT 
        p.customer_id,
        SUM(p.amount) AS total_amount
    FROM 
        payment p
    GROUP BY 
        p.customer_id) cp
LEFT JOIN customer c 
    ON cp.customer_id = c.customer_id
WHERE 
    cp.total_amount > 180 AND cp.total_amount < 200;


-- Q4. --

select
    f.film_id,
    f.title,
    fp.total_amount AS rental
FROM 
    (select 
        i.film_id,
        SUM(p.amount) AS total_amount
    FROM 
        rental r
    LEFT JOIN payment p
        ON r.rental_id = p.rental_id 
    LEFT JOIN inventory i 
        ON r.inventory_id = i.inventory_id
    GROUP BY 
        i.film_id) fp
LEFT JOIN film f 
    ON f.film_id = fp.film_id;


-- Q5. --

SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    f.film_count
FROM 
    (SELECT 
        fa.actor_id,
        COUNT(*) AS film_count
    FROM 
        film_actor fa
    GROUP BY 
        fa.actor_id) f
RIGHT JOIN actor a
    ON a.actor_id = f.actor_id;


-- Q6. --

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_filtered
FROM 
    (SELECT
        i.film_id,
        r.customer_id
    FROM 
        rental r 
    LEFT JOIN inventory i 
        ON r.inventory_id = i.inventory_id) fc 
LEFT JOIN film f 
    ON f.film_id = fc.film_id
LEFT JOIN customer c 
    ON c.customer_id = fc.customer_id
WHERE
    f.title != 'NATURAL STOCK';


-- Q7. --

SELECT 
    fa_.actor_id, 
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
	GROUP_CONCAT(fa_.title) AS titles
FROM 
    (SELECT 
        fa.actor_id, 
        f.title
    FROM 
        film_actor fa
    LEFT JOIN film f 
        ON fa.film_id = f.film_id) fa_
LEFT JOIN actor a 
    ON fa_.actor_id = a.actor_id
WHERE 
    fa_.title IN ('ELEPHANT TROJAN', 'DOGMA FAMILY')
GROUP BY fa_.actor_id
HAVING COUNT(DISTINCT fa_.title) = 2;


-- Q8. --

SELECT
    fc_.category_id,
    fc_.category_name,
    COUNT(*) AS film_count
FROM 
    (SELECT 
        c.category_id, 
        c.name as category_name,
        fc.film_id
    FROM 
        category c 
    LEFT JOIN film_category fc 
        ON c.category_id = fc.category_id) fc_
GROUP BY fc_.category_id;


-- Q9. --

SELECT
    i.film_id, 
    f.title,
    COUNT(DISTINCT r.customer_id) AS rental_count_duplicated
FROM 
    rental r 
LEFT JOIN inventory i 
    ON r.inventory_id = i.inventory_id
LEFT JOIN film f 
    ON i.film_id = f.film_id
GROUP BY i.film_id
ORDER BY rental_count_duplicated DESC
LIMIT 1;


-- Q10. --

SELECT
    r.customer_id,
    CONCAT(c.first_name, ' ', last_name) AS customer_name,
    (r.return_date - r.rental_date) AS duration_second
FROM 
    rental r 
LEFT JOIN customer c    
    ON r.customer_id = c.customer_id
ORDER BY duration_second DESC
LIMIT 6;


-- Q11. --

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date, last_update)
SELECT 
    MIN(store_id),
    'Hakurei',
    'POI',
    'hakureipoi@qq.com',
    MIN(address_id),
    MIN(active),
    MIN(create_date),
    MIN(last_update)
FROM customer;


-- Q12. --

UPDATE customer
SET email = 'poihakurei@qq.com'
WHERE customer_id = 600;


-- Q13. --

DELETE FROM customer
WHERE customer_id = 600;







