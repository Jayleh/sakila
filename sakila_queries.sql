USE sakila;

-- 1a. Display first and last names of all actors
SELECT first_name, last_name FROM actor;

-- 1b. Display first and last name in a single column
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor ;

-- 2a. Find the ID number, first name, and last name of an actor, of whom you know only the first name, 'Joe'
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
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

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS count FROM actor
GROUP BY last_name
HAVING count > 1;

-- 4c. Change actor GROUCHO WILLIAMS to HARPO WILLIAMS
UPDATE actor SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Change back to HARPO, if already GROUCHO then MUCHO GROUCHO
UPDATE actor 
SET first_name = CASE 
	WHEN first_name = 'HARPO' THEN 'GROUCHO'
	WHEN first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'
    ELSE first_name
END
WHERE actor_id = 172;

-- 5a. Query to show how to recreate address table from sakila database
SHOW CREATE TABLE sakila.address;

-- 6a. Display staff members' addresses
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
USING (address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment





