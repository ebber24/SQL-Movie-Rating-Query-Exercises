-- Q01 Find the names of all reviewers who rated Gone with the Wind.

SELECT DISTINCT name
FROM   movie,
       rating,
       reviewer
WHERE  movie.mID = rating.mID
       AND reviewer.rID = rating.rID
       AND ( rating.mID = 101 ); 
  
-- Q02 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
  
SELECT name,
       title,
       stars
FROM   movie,
       rating,
       reviewer
WHERE  movie.mID = rating.mID
       AND reviewer.rID = rating.rID
       AND director = name; 

-- Q03 Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)

SELECT name
FROM   reviewer
UNION
SELECT title
FROM   movie
ORDER  BY NAME; 

-- Q04 Find the titles of all movies not reviewed by Chris Jackson.

SELECT title
FROM   movie
WHERE  mID NOT IN (SELECT mID
                   FROM   rating
                          INNER JOIN reviewer using (rID)
                   WHERE  NAME = "Chris Jackson"); 
        
-- Q05 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
  
SELECT DISTINCT RE1.name,
                RE2.name
FROM   rating R1,
       rating R2,
       reviewer RE1,
       reviewer RE2
WHERE  R1.mID = R2.mID
       AND R1.rID = RE1.rID
       AND R2.rID = RE2.rID
       AND RE1.name < RE2.name
ORDER  BY RE1.name,
          RE2.name; 
          
-- Q06 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

SELECT name,
       title,
       stars
FROM   movie M,
       rating Ra,
       reviewer Re
WHERE  M.mID = Ra.mID
       AND Re.rID = Ra.rID
       AND stars = (SELECT Min(stars)
                    FROM   rating); 
        
-- Q07 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
  
SELECT title,
       Avg(stars) AS avg
FROM   movie
       INNER JOIN rating using (mID)
GROUP  BY mID
ORDER  BY avg DESC,
          title; 

-- Q08 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)

SELECT name
FROM   reviewer
WHERE  rID IN (SELECT rID
               FROM   rating
               GROUP  BY rID
               HAVING Count(*) >= 3); 

-- Q09 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)

SELECT title,
       director
FROM   movie
WHERE  director IN (SELECT director
                    FROM   movie M
                    GROUP  BY director
                    HAVING Count(*) >= 2)
ORDER  BY director,
          title; 

-- Q10 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)

SELECT title,
       Max(avgstars)
FROM  (
                  SELECT     mID,
                             Avg(stars) AS avgstars
                  FROM       movie M
                  INNER JOIN rating R
                  using      (mID)
                  GROUP BY   mID),
       movie
using  (mID);

-- Q11 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)

SELECT title,
       Avg(stars)
FROM   rating
       INNER JOIN movie using (mID)
GROUP  BY mID
HAVING Avg(stars) = (SELECT Min(avgstars) AS minavg
                     FROM   (SELECT mID,
                                    Avg(stars) AS avgstars
                             FROM   movie M
                                    INNER JOIN rating R using (mID)
                             GROUP  BY mID)); 
              
-- Q12 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
  
SELECT director,
       title,
       stars
FROM   rating
       INNER JOIN movie using (mID)
GROUP  BY director
HAVING Max(stars)
       AND director IS NOT NULL; 
       
