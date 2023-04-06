USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


select 
		(select count(*) from names) as names_rows,
        (select count(*) from movie) as movies_rows,
        (select count(*) from genre) as genre_rows,
        (select count(*) from director_mapping) as dir_map_rows,
        (select count(*) from ratings) as rating_rows,
        (select count(*) from role_mapping) as rol_mapping_rows;






-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select 	
		sum(case when id is null then 1 else 0  end) as id_nulls,
        sum(case when title is null then 1 else 0 end) as title_nulls,
        sum(case when year is null then 1 else 0 end) as year_null,
        sum(case when date_published is null then 1 else 0 end) as date_null,
        sum(case when duration is null then 1 else 0 end) as duration_null,
        sum(case when country is null then 1 else 0 end) as country_null,
        sum(case when worlwide_gross_income is null then 1 else 0 end) as world_null,
        sum(case when languages is null then 1 else 0 end) as language_null,
        sum(case when production_company is null then 1 else 0 end) as production_null
        
	from movie;
		


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select year as year,count(id) as number_of_movies from movie
group by year
order by year;

select month(date_published) as month_num,count(id) as number_of_movies
from movie 
group by month_num
order by month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


select count(id) as number_of_movies from movie
where (country like '%USA%' or country like '%India%') and year = 2019;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

Select DISTINCT genre 
from genre;




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre as genre,count(movie_id) as number_of_movies
from genre 
group by genre
order by number_of_movies desc limit 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with genre_summary as(
select m.title,count(g.genre) as genre_count
from movie as m inner join genre as g on g.movie_id = m.id
group by title)

select count(title) as number_of_movies_with_one_genre from genre_summary
where genre_count = 1;






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre,round(avg(duration),2) as average_duration_of_movie 
from movie as m inner join 
genre as g on m.id = g.movie_id 
group by genre order by avg(duration);



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_rank_summary as (
select g.genre,count(m.title) as movie_count,
		Rank() over(order by count(m.title) desc) as genre_rank
        from movie as m inner join genre as g on g.movie_id = m.id
        group by genre
	)

select * from genre_rank_summary 
where genre = 'Thriller';



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select min(avg_rating) AS min_avg_rating , max(avg_rating) AS max_avg_rating,
 min(total_votes) AS min_total_votes, max(total_votes) AS max_total_votes,
 min(median_rating) AS min_median_rating, max(median_rating) AS max_median_rating
from ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select title,avg_rating,
		Rank() over(order by avg_rating desc) as movie_rank,
        Dense_rank() over(order by avg_rating desc) as dense_movie_rank
        from movie as m inner join ratings as r on r.movie_id = m.id
        limit 10;
        

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating,count(movie_id) as movie_count from ratings
group by median_rating
order by median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with movie_summary as(
select m.production_company,count(m.title) as movie_count,
		Rank() over(order by count(m.title) desc) as prod_company_rank
        from movie as m inner join ratings as r on r.movie_id = m.id
        where avg_rating > 8 and production_company is not null
        group by production_company
)

select * from movie_summary
where prod_company_rank = 1;



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre,count(m.title) as movie_count from movie as m inner join genre as g on g.movie_id = m.id inner join ratings as r on r.movie_id = m.id
where (m.date_published between '2017-03-01' and '2017-03-31') and (m.country = 'USA') and r.total_votes >1000
group by genre
order by movie_count desc;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select m.title,r.avg_rating,g.genre from movie as m inner join genre as g on g.movie_id = m.id inner join ratings as r on r.movie_id = m.id
where title like 'the%' and avg_rating > 8
order by avg_rating desc;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(title) as movie_count from movie as m
inner join ratings as r on r.movie_id = m.id
where (date_published between '2018-04-01' and '2019-04-01') and (median_rating = 8);





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

use imdb;

with german_votes as(
select sum(r.total_votes) as total_votes_german,
		Rank() over(order by sum(r.total_votes)) as uid
        from movie as m inner join ratings as r on m.id = r.movie_id
        where m.languages like '%German%'
        ),
italian_votes as(
SELECT SUM(r.total_votes) AS total_votes_Italian,
		RANK() OVER (ORDER BY SUM(r.total_votes)) AS uid
	FROM movie AS m
	INNER JOIN ratings AS r
	ON m.id=r.movie_id
	WHERE m.languages LIKE '%Italian%'
    )
    select *, case
					when total_votes_german > total_votes_italian then 'Yes'
                    else 'No'
                    End as 'Is german_movie gets more votes than italian moveis'
                    from german_votes as gmc inner join italian_votes as imc using(uid);
        

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


select 
		sum(case when name is null then 1 else 0 end) as name_nulls,
        sum(case when height is null then 1 else 0 end) as height_nulls,
        sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
        sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
        
        from names;




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top3_genre as (
select g.genre,count(m.id) as movie_count
from movie as m inner join genre as g on g.movie_id = m.id 
inner join ratings as r on r.movie_id = m.id
where r.avg_rating > 8
group by g.genre
order by movie_count desc limit 3
)
select n.name as director_name,count(m.id) as movie_count
from names as n inner join director_mapping as d on n.id = d.name_id 
inner join movie as m on m.id = d.movie_id inner join ratings as r on r.movie_id = m.id
inner join genre as g on g.movie_id = m.id
where r.avg_rating > 8 and genre in(select genre from top3_genre)
group by director_name
order by movie_count desc limit 3; 




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with actors as (
select * from names as n inner join role_mapping as rm on rm.name_id = n.id
where rm.category = 'Actor'
)

select a.name as actor_name,count(m.id) as movie_count
from actors as a inner join movie as m on m.id = a.movie_id
inner join ratings as r on m.id = r.movie_id
where r.median_rating >= 8
group by actor_name
order by movie_count
desc limit 2;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


select m.production_company,sum(r.total_votes) as vote_count,
Rank() over(order by sum(r.total_votes) desc) as prod_comp_rank
from movie as m inner join ratings as r on r.movie_id = m.id
group by m.production_company
limit 3;
            




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actor_name, SUM(r.total_votes) AS total_votes,COUNT(m.id) AS movie_count,
	ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating,
	RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) DESC) AS actor_rank
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id=rm.name_id
INNER JOIN movie AS m
ON rm.movie_id=m.id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE rm.category='actor' AND m.country='India'
GROUP BY actor_name
HAVING COUNT(m.country='India')>=5
LIMIT 1;







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actress_name,sum(r.total_votes) as total_votes,count(m.id) as movie_count,
 round(sum(r.avg_rating*total_votes)/sum(r.total_votes),2) actress_avg_rating,
 Rank() Over(order by round(sum(r.avg_rating*total_votes)/sum(r.total_votes),2) desc) as actress_rank
 from names as n inner join role_mapping as rm
 on n.id = rm.name_id
 inner join movie as m 
 on rm.movie_id = m.id
 inner join ratings as r 
 on r.movie_id = m.id
 where rm.category = 'actress' and m.country = 'India' and m.languages like '%Hindi%'
 group by actress_name
 having count(m.country = 'India') >= 3
 limit 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select m.title,case 
					when avg_rating > 8 then 'Superhit movies'
                    when avg_rating between 7 and 8  then 'Hit movies'
                    when avg_rating between 5 and 7 then 'One-time-watch movies'
                    when avg_rating < 5 then 'Flop movies'
                    end as 'Movie Category'
from movie as m inner join ratings as r on m.id = r.movie_id
inner join genre as g on g.movie_id = m.id
where genre = 'Thriller'
order by avg_rating desc;



n



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
use imdb;

select g.genre,round(avg(m.duration)) as avg_duration,
	Round(Sum(Avg(m.duration)) over(order by g.genre rows unbounded preceding),2) as running_total_duration,
    Round(avg(avg(m.duration)) over(order by g.genre rows 12 preceding),2) as moving_avg_duration
from movie as m inner join genre as g on m.id = g.movie_id
group by genre 
order by genre;









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top3_genre as (
select g.genre,count(m.id) as movie_count
from movie as m inner join genre as g on m.id = g.movie_id
group by genre
order by movie_count desc
limit 3
),

top5_movies as(
select genre,year,title as movie_name,worlwide_gross_income,
Dense_Rank() over(partition by m.year order by worlwide_gross_income desc) as movie_rank
from movie as m inner join genre as g on g.movie_id = m.id
where genre in (select genre from top3_genre)
)
select * from top5_movies
where movie_rank <= 5
order by genre;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company as production_company,count(m.id) as movie_count,
dense_rank() over(order by count(id) desc) as prod_comp_rank
from movie as m inner join ratings as r on m.id = r.movie_id
where r.median_rating > 8 and position(',' In m.languages) > 0 and m.production_company is not null
group by production_company
limit 2;









-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actress_name,sum(r.total_votes) as total_votes,count(m.id) as movie_count,
r.avg_rating as actress_avg_rating,
ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS actress_rank 
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id=rm.name_id
INNER JOIN movie AS m
ON rm.movie_id=m.id
INNER JOIN ratings AS r
ON m.id=r.movie_id
INNER JOIN genre AS g
ON m.id=g.movie_id
WHERE r.avg_rating>8 AND g.genre='Drama' AND rm.category='Actress'
GROUP BY actress_name
LIMIT 3;







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_date_info AS
(
	SELECT d.name_id, name, d.movie_id, m.date_published, 
		LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
	FROM director_mapping AS d
	JOIN names AS n 
	ON d.name_id=n.id 
	JOIN movie AS m 
	ON d.movie_id=m.id
),
date_difference AS
(
	SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	FROM movie_date_info
 ),
 avg_inter_days AS
(
	SELECT name_id, AVG(diff) AS avg_inter_movie_days
	FROM date_difference
	GROUP BY name_id
),
 final_result AS
(
	SELECT d.name_id AS director_id,name AS director_name,
		COUNT(d.movie_id) AS number_of_movies,
		ROUND(avg_inter_movie_days) AS inter_movie_days,
		ROUND(AVG(avg_rating),2) AS avg_rating,
		SUM(total_votes) AS total_votes,
		MIN(avg_rating) AS min_rating,
		MAX(avg_rating) AS max_rating,
		SUM(duration) AS total_duration,
		ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	FROM names AS n 
	JOIN director_mapping AS d 
	ON n.id=d.name_id
	JOIN ratings AS r 
	ON d.movie_id=r.movie_id
	JOIN movie AS m 
	ON m.id=r.movie_id
	JOIN avg_inter_days AS a 
	ON a.name_id=d.name_id
	GROUP BY director_id
)
SELECT * FROM final_result
LIMIT 9;






