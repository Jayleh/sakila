-- Use sakila database
USE sakila;

-- 1a. Display first and last names of all actors
SELECT first_name, last_name FROM actor;

-- 1b. Display first and last name in a single column
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- 2a. Find ID number, first name, and last name of an actor, of whom you know only the first name, 'Joe'
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI, order by last name, then first name
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of Afghanistan, Bangladesh, and China
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add middle_name column to table actor and position between first_name and last_name
ALTER TABLE actor
ADD middle_name VARCHAR(30)
AFTER first_name;

-- 3b. Change the data type of the middle_name column to blobs
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- 3c. Delete the middle_name column
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors that have that last name
SELECT last_name, COUNT(*) AS count FROM actor
GROUP BY last_name;

-- 4b. List last names & the number of actors who have that last name, but only those w/ at least two actors
SELECT last_name, COUNT(*) AS count FROM actor
GROUP BY last_name
HAVING count > 1;

-- 4c. Change actor GROUCHO WILLIAMS to HARPO WILLIAMS
UPDATE actor SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Change back to HARPO, if already GROUCHO then MUCHO GROUCHO
UPDATE actor 
SET 
    first_name = CASE
        WHEN first_name = 'HARPO' THEN 'GROUCHO'
        WHEN first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'
        ELSE first_name
    END
WHERE
    actor_id = 172;

-- 5a. Query to show how to recreate address table from sakila database
SHOW CREATE TABLE sakila.address;

-- 6a. Display staff members' addresses
SELECT s.first_name, s.last_name, a.address
FROM staff s
	JOIN address a USING (address_id);

-- 6b. Display the total amount rung up by each staff member in August of 2005
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'total_amount'
FROM staff s
	JOIN payment p USING (staff_id)
WHERE p.payment_date LIKE '2005-08%'
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film
SELECT f.title, COUNT(fa.film_id) AS 'Number of actors'
FROM film f
	JOIN film_actor fa USING (film_id)
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) FROM inventory
WHERE film_id IN (
	SELECT film_id FROM film
	WHERE title = 'HUNCHBACK IMPOSSIBLE'
);

-- 6e. List the total paid by each customer. List the customers alphabetically by last name
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total Amount Paid'
FROM customer c
	JOIN payment p USING (customer_id)
GROUP BY customer_id
ORDER BY last_name;

-- 7a. Display the titles of movies starting with the letters K and Q whose language is English
SELECT title FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id IN (
	SELECT language_id FROM language
    WHERE name = 'English'
);

-- 7b. Display all actors who appear in the film Alone Trip
SELECT first_name, last_name FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor
    WHERE film_id IN (
		SELECT film_id FROM film
        WHERE title = 'Alone Trip'
    )
);

-- 7c. Display the names and email addresses of all Canadian customers
SELECT cust.first_name, cust.last_name, cust.email
FROM customer cust
	JOIN address USING (address_id)
    JOIN city USING (city_id)
    JOIN country USING (country_id)
WHERE country = 'Canada';

-- 7d. Identify all movies categorized as family films
SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category
    WHERE category_id IN (
		SELECT category_id FROM category
        WHERE name = 'Family'
	)
);

-- 7e. Display the most frequently rented movies in descending order
SELECT f.title, COUNT(p.rental_id) AS 'Number of Times Rented'
FROM film f
	JOIN inventory USING (film_id)
    JOIN rental USING (inventory_id)
    JOIN payment p USING (rental_id)
GROUP BY f.title
ORDER BY `Number of Times Rented` DESC;

-- 7f. Display how much business, in dollars, each store brought in
SELECT staff.store_id, SUM(payment.amount) AS 'Total Revenue'
FROM staff
	JOIN rental USING (staff_id)
    JOIN payment USING (rental_id)
GROUP BY staff.store_id;

-- 7g. Display for each store its store ID, city, and country
SELECT s.store_id, city.city, country.country
FROM store s
	JOIN address USING (address_id)
    JOIN city USING (city_id)
    JOIN country USING (country_id);

-- 7h. List the top five genres in gross revenue in descending order
SELECT cat.name, SUM(p.amount) AS 'Gross Revenue'
FROM category cat
	JOIN film_category USING (category_id)
    JOIN inventory USING (film_id)
    JOIN rental USING (inventory_id)
    JOIN payment p USING (rental_id)
GROUP BY cat.name
ORDER BY `Gross Revenue` DESC
LIMIT 5;

-- 8a. Create a view of the top five genres by gross revenue
CREATE VIEW top_five_genres AS
SELECT cat.name, SUM(p.amount) AS 'Gross Revenue'
FROM category cat
	JOIN film_category USING (category_id)
    JOIN inventory USING (film_id)
    JOIN rental USING (inventory_id)
    JOIN payment p USING (rental_id)
GROUP BY cat.name
ORDER BY `Gross Revenue` DESC
LIMIT 5;

-- 8b. Display top_five_genres view
SELECT * FROM top_five_genres;

-- 8c. Delete top_five_genres view
DROP VIEW IF EXISTS top_five_genres;
