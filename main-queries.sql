-- Q01 Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM   movie
WHERE  director = "Steven Spielberg"; 

-- Q02 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

SELECT DISTINCT year
FROM   movie M
       INNER JOIN rating R
               ON M.mID = R.mID
WHERE  stars = 4
        OR stars = 5
ORDER  BY year; 

-- Q03 Find the titles of all movies that have no ratings.

SELECT title
FROM   movie M
WHERE  M.mID NOT IN (SELECT R.mID
                     FROM   rating R); 

-- Q04 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

SELECT Re.name
FROM   movie M,
       reviewer Re,
       rating Ra
WHERE  M.mID = Ra.mID
       AND Re.rID = Ra.rID
       AND ( ratingdate IS NULL ); 

-- Q05 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

SELECT Re.name,
       title,
       stars,
       ratingdate
FROM   movie M,
       reviewer Re,
       rating Ra
WHERE  M.mID = Ra.mID
       AND Re.rID = Ra.riID
ORDER  BY Re.NAME,
          title,
          stars; 

-- Q06 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

SELECT name,
       title
FROM   movie
       INNER JOIN rating R1 using(mID)
       INNER JOIN rating R2 using(rID)
       INNER JOIN reviewer using(rID)
WHERE  R1.mID = R2.mID
       AND R1.ratingdate < R2.ratingdate
       AND R1.stars < R2.stars; 

-- Q07 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

SELECT title,
       Max(stars)
FROM   movie M,
       rating Ra
WHERE  M.mID = Ra.mID
GROUP  BY title
ORDER  BY title; 

-- Q08 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

SELECT M.title,
       Max(stars) - Min(stars) AS ratingspread
FROM   movie M,
       rating Ra
WHERE  M.mID = Ra.mID
GROUP  BY M.title
ORDER  BY ratingspread DESC,
          M.title; 

-- Q09 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

SELECT pre1980 - post1980
FROM  (SELECT Avg(stars) AS pre1980
       FROM   (SELECT title,
                      Avg(stars) AS stars,
                      year
               FROM   movie M,
                      reviewer Re,
                      rating Ra
               WHERE  M.mID = Ra.mID
                      AND Re.rID = Ra.rID
                      AND ( year < 1980 )
               GROUP  BY title)),
      (SELECT Avg(newstars) AS post1980
       FROM   (SELECT title,
                      Avg(stars) AS newstars,
                      year
               FROM   movie M,
                      reviewer Re,
                      rating Ra
               WHERE  M.mID = Ra.mID
                      AND Re.rID = Ra.rID
                      AND ( year > 1980 )
               GROUP  BY title)); 
