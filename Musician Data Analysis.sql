USE musicians;

select * from artists;
select * from albums;
select * from annualsales;

# Q1 How many artists have an ‘L’ as the third character of their last name?
select count(distinct artid)
from artists
where lname like '__L%';

# Q2 How many albums are associated with the Pop genre and released in 2017?
select count(distinct albid)
from albums
where genre = 'pop' and releaseyear = 2017;

# Q3 How many artists were born before 1985?
select count(distinct artid)
from artists
where year(dob) < 1985;

# Q4 How many artists are not from the Southwest region?
select count(distinct artid)
from artists
where birth_region != 'southwest';

# Q5 Which birth region has the least number of artists born in 1995 or later?
select birth_region
from artists
where year(dob) >= 1995
group by birth_region
order by count(artid)
limit 1;

# Q6 Which albumID has sold the most copies according to the data in the annual sales table, and how many copies is that?
select albid, sum(nocopiessold)
from annualsales
group by albid
order by sum(nocopiessold) desc
limit 1;

# Q7 How many artists are there with the last name ‘Blanchard’ that have released albums with fewer than 13 tracks?
select count(*)
from artists
where lname = 'Blanchard'
and artid in (select artid from albums group by artid having min(numtracks) < 13);

# Q8 How many artists are there that were born before January 1, 1987 and have released a Pop album?
select count(distinct ar.artid)
from artists ar
inner join albums al
on ar.artid = al.artid
where dob < '1987-01-01' and genre = 'pop';

# Q9 Which genre sold the most copies of a newly released albums (i.e., sales happening the same year they’re released) between 2010-2018 (SQL defines between two include endpoints, so include 2010 and 2018 in your calculations) and how many were there?
select genre, sum(nocopiessold)
from albums al
inner join annualsales an
on al.albid = an.albid and al.releaseyear = an.year
where releaseyear between 2010 and 2018
group by genre
order by sum(nocopiessold) desc
limit 1;

# Q10 Consider all the situations where multiple albums have been released that share both the same genre and the exact same title. 
# In situations where that has happened and included at least 7 albums with shared title/genres, which of the following is true?
select a.genre, a.title, count(distinct a.albid)
from albums a
inner join albums b
on a.genre = b.genre and a.title = b.title
where a.albid <> b.albid
group by a.genre, a.title
having count(distinct a.albid) >= 7;

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