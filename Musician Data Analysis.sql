USE musicians;

SELECT * FROM artists;
SELECT * FROM albums;
SELECT * FROM annualsales;

# Q1 How many artists have an ‘L’ as the third character of their last name?
SELECT COUNT(DISTINCT artid)
FROM artists
WHERE lname LIKE '__L%';

# Q2 How many albums are associated with the Pop genre and released in 2017?
SELECT COUNT(DISTINCT albid)
FROM albums
WHERE genre = 'pop' AND releaseyear = 2017;

# Q3 How many artists were born before 1985?
SELECT COUNT(DISTINCT artid)
FROM artists
WHERE YEAR(dob) < 1985;

# Q4 How many artists are not from the Southwest region?
SELECT COUNT(DISTINCT artid)
FROM artists
WHERE birth_region != 'southwest';

# Q5 Which birth region has the least number of artists born in 1995 or later?
SELECT birth_region
FROM artists
WHERE YEAR(dob) >= 1995
GROUP BY birth_region
ORDER BY COUNT(artid)
LIMIT 1;

# Q6 Which albumID has sold the most copies according to the data in the annual sales table, and how many copies is that?
SELECT albid, SUM(nocopiessold)
FROM annualsales
GROUP BY albid
ORDER BY SUM(nocopiessold) DESC
LIMIT 1;

# Q7 How many artists are there with the last name ‘Blanchard’ that have released albums with fewer than 13 tracks?
SELECT COUNT(*)
FROM artists
WHERE lname = 'Blanchard'
AND artid IN (SELECT artid FROM albums GROUP BY artid HAVING MIN(numtracks) < 13);

# Q8 How many artists are there that were born before January 1, 1987 AND have released a Pop album?
SELECT COUNT(DISTINCT ar.artid)
FROM artists ar
INNER JOIN albums al
ON ar.artid = al.artid
WHERE dob < '1987-01-01' AND genre = 'pop';

# Q9 Which genre sold the most copies of a newly released albums (i.e., sales happening the same year they’re released) between 2010-2018 (SQL defines between two include endpoints, so include 2010 and 2018 in your calculations) and how many were there?
SELECT genre, SUM(nocopiessold)
FROM albums al
INNER JOIN annualsales an
ON al.albid = an.albid AND al.releaseyear = an.year
WHERE releaseyear BETWEEN 2010 AND 2018
GROUP BY genre
ORDER BY SUM(nocopiessold) DESC
LIMIT 1;

# Q10 Consider all the situations where multiple albums have been released that share both the same genre and the exact same title. 
# In situations where that has happened and included at least 7 albums with shared title/genres, which of the following is true?
SELECT a.genre, a.title, COUNT(DISTINCT a.albid)
FROM albums a
INNER JOIN albums b
ON a.genre = b.genre AND a.title = b.title
WHERE a.albid <> b.albid
GROUP BY a.genre, a.title
HAVING COUNT(DISTINCT a.albid) >= 7;

# Alternative Solution:
SELECT genre, title, COUNT(DISTINCT albid)
FROM albums
GROUP BY genre, title
HAVING COUNT(DISTINCT albid) >= 7;

# Q11 Make a list of unique albumIDs that were either created by an artist born in the Northeast or had a per profit value lower than 6.00. 
SELECT COUNT(DISTINCT albid)
FROM albums
WHERE artid IN (SELECT artid FROM artists WHERE birth_region = 'northeast')
OR albid IN (SELECT albid FROM annualsales WHERE profitpercopy < 6.00);

# Q12 What was the title of the album that made the least total profit
# (i.e., total profit considers all years an album has sales data recorded)?
SELECT title, SUM(nocopiessold * profitpercopy) AS total_profit
FROM albums al
INNER JOIN annualsales an
ON al.albid = an.albid
GROUP BY an.albid
ORDER BY total_profit
LIMIT 1;

# Q13 Which artist has sold the most album copies (include any albums attributed to that artist)?
SELECT fname, lname
FROM artists ar
INNER JOIN albums al
ON ar.artid = al.artid
INNER JOIN annualsales an
ON al.albid = an.albid
GROUP BY ar.artid
ORDER BY SUM(nocopiessold) DESC
LIMIT 1;

# Q11 Make a list of unique albumIDs that were either created by an artist born in the Northeast or had a per profit value lower than 6.00. 
select count(distinct albid)
from albums
where artid in (select artid from artists where birth_region = 'northeast')
or albid in (select albid from annualsales where profitpercopy < 6.00);

# Q12 What was the title of the album that made the least total profit
# (i.e., total profit considers all years an album has sales data recorded)?
select title, sum(nocopiessold * profitpercopy) as total_profit
from albums al
inner join annualsales an
on al.albid = an.albid
group by an.albid
order by total_profit
limit 1;

# Q13 Which artist has sold the most album copies (include any albums attributed to that artist)?
select fname, lname
from artists ar
inner join albums al
on ar.artid = al.artid
inner join annualsales an
on al.albid = an.albid
group by ar.artid
order by sum(nocopiessold) desc
limit 1;
