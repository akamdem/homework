
USE Sakila
------1a
SELECT first_name, last_name 
FROM actor
------1b
SELECT CONCAT(first_name, ' ', last_name) AS ' Actor Name'
FROM actor
-------2a "Joe Swank"
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "JOE"; 
-----2b
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE '%GEN%'
------2c
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;
------2d
SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
****------3a
SELECT * FROM actor;
ALTER TABLE actor
ADD COLUMN description BLOB(50) AFTER last_name;
--------3b
ALTER TABLE actor;
ADD COLUMN description BLOB(25) AFTER first_name;

ALTER TABLE actor;
MODIFY COLUMN description BLOB;
------3c
ALTER TABLE actor
DROP COLUMN description 
--------4a
SELECT last_name, COUNT(*) AS 'number of actors'
FROM actor GROUP BY last_name;
--------4b

SELECT last_name, COUNT(*) AS 'Number of Actors' 
FROM actor GROUP BY last_name HAVING count(*) >=2;
---------4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'Groucho' AND last_name = 'WIlliams' ;

-------4d
UPDATE actor
SET first_name = 'Groucho'
WHERE first_name = 'HARPO' AND last_name = 'WIlliams' ;
--------5a
DESCRIBE sakila.address;
-------6a

SELECT first_name, last_name, address
FROM staff s 
JOIN address a
ON s.address_id = a.address_id;



 --------6b
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'TOTAL'
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.first_name, s.last_name;

--------6c
SELECT f.title AS 'Film Title', COUNT(fa.actor_id) AS `Number of Actors`
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id= f.film_id
GROUP BY f.title; 
6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.	
	-- 
	SELECT f.title, COUNT(a.actor_id) AS 'TOTAL'
	FROM film f LEFT JOIN film_actor a ON f.film_id = a.film_id
	GROUP BY f.title;
	-
	SELECT c.first_name, c.last_name, SUM(p.amount) AS 'TOTAL'
	FROM customer c LEFT JOIN payment p ON c.customer_id = p.customer_id
	GROUP BY c.first_name, c.last_name
	ORDER BY c.last_name
	-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
	-- 
	Use sakila
	SELECT title
	FROM film
	WHERE (title LIKE 'K%' OR title LIKE 'Q%') 
	AND language_id=(SELECT language_id FROM language where name='English')
	-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
	SELECT first_name, last_name
	FROM actor
	WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
	IN (SELECT film_id from film where title='ALONE TRIP'))
	-- 
	-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
	SELECT first_name, last_name, email 
	FROM customer cu
	JOIN address a ON (cu.address_id = a.address_id)
	JOIN city cit ON (a.city_id=cit.city_id)
	JOIN country cntry ON (cit.country_id=cntry.country_id)
	-- 
	-- 
	SELECT title from film f
	JOIN film_category fcat on (f.film_id=fcat.film_id)
	JOIN category c on (fcat.category_id=c.category_id);

	SELECT title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
	FROM film f
	JOIN inventory i ON (f.film_id= i.film_id)
	JOIN rental r ON (i.inventory_id=r.inventory_id)
	GROUP BY title ORDER BY Count_of_Rented_Movies DESC;
	-- 
	SELECT s.store_id, SUM(p.amount) 
	FROM payment p
	JOIN staff s ON (p.staff_id=s.staff_id)
	GROUP BY store_id;
	-- 
	SELECT store_id, city, country FROM store s
	JOIN address a ON (s.address_id=a.address_id)
	JOIN city c ON (a.city_id=c.city_id)
	JOIN country cntry ON (c.country_id=cntry.country_id);
	-- 
	SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
	FROM category c
	JOIN film_category fc ON (c.category_id=fc.category_id)
	JOIN inventory i ON (fc.film_id=i.film_id)
	JOIN rental r ON (i.inventory_id=r.inventory_id)
	JOIN payment p ON (r.rental_id=p.rental_id)
	GROUP BY c.name ORDER BY Gross LIMIT 5;
	-- 
	SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
	FROM category c
	JOIN film_category fc ON (c.category_id=fc.category_id)
	JOIN inventory i ON (fc.film_id=i.film_id)
	JOIN rental r ON (i.inventory_id=r.inventory_id)
	JOIN payment p ON (r.rental_id=p.rental_id)
	GROUP BY c.name ORDER BY Gross LIMIT 5;
	SELECT* FROM TopFive
	-- 
	-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
	-- 
	DROP VIEW TopFive
