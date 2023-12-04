use sakila;
show tables;

/* Challenge 1.
*/
-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
select min(length) as 'min_duration', max(length) as 'max_duration' 
from film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
select concat(floor(avg(length)/60),':',round(avg(length)%60,0)) as 'avg film length in hh:mm' 
from film;

-- 2.1 Calculate the number of days that the company has been operating.
select datediff(max(rental_date),min(rental_date)) as 'company_operation_days' from rental;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
-- formula comment: 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday.
select *, month(rental_date) as 'month', weekday(rental_date) as 'weekday' from rental limit 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
select *, month(rental_date) as 'month', weekday(rental_date) as 'weekday',
CASE
WHEN weekday(rental_date) in (5,6) then 'weekend'
ELSE 'workday'
END as 'week/work_day'
from rental;

/*
3. You need to ensure that customers can easily access information about the movie collection. 
To achieve this, retrieve the film titles and their rental duration.
 If any rental duration value is NULL, replace it with the string 'Not Available'. 
 Sort the results of the film title in ascending order.
*/
-- solution 1
SELECT 
title,
 rental_duration,
 IFNULL(rental_duration, 'Not Available') AS rental_duration_b -- or COALESCE also works
 FROM film
 ORDER BY title;

-- solution 2
select 
title, 
rental_duration,
CASE
WHEN rental_duration IS NULL THEN 'Not Available'
ELSE rental_duration
END as rental_duration_b
from film
ORDER BY title;

/*
4 . Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for
 customers. To achieve this, you need to retrieve the concatenated first and last names of customers, along with
 the first 3 characters of their email address, so that you can address them by their first name and use their email 
 address to send personalized recommendations. The results should be ordered by last name in ascending order to make 
 it easier to use the data.
*/

select * from customer;
SELECT CONCAT(first_name,' ',last_name,' ',left(email,3)) from customer;

/*Challenge 2
Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
This will help you to better understand the popularity of different film ratings and adjust purchasing 
decisions accordingly.
*/
-- 1.1 The total number of films that have been released.
select count(distinct(title)) from film;

-- 1.2 The number of films for each rating.
select rating, count(distinct(title)) as film_count from film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
select rating, count(distinct(title)) as film_count 
from film
GROUP BY rating
ORDER BY film_count Desc;

-- 2. Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
-- Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
select rating, round(avg(length),2) as mean_duration 
from film
GROUP BY rating
ORDER BY mean_duration Desc;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers 
-- who prefer longer movies.
select rating, round(avg(length),2) as mean_duration 
from film
GROUP BY rating
HAVING mean_duration>120
ORDER BY mean_duration Desc;

-- 2.Bonus: determine which last names are not repeated in the table actor.
select last_name, count(last_name) 
OVER (PARTITION BY last_name) as last_name_count
from actor
GROUP BY last_name
HAVING count(last_name)<1000;

-- to confirm the # of distinct last names: select count(distinct(last_name)) from actor;
