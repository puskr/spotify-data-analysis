DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--importing data

COPY spotify 
FROM 'C:\\Program Files\\PostgreSQL\\16\\data\\data_copy\\cleaned_dataset.csv'
WITH (FORMAT csv, HEADER, DELIMITER ',');

-- EDA

select count(*) from spotify

select count(distinct album) from spotify

select distinct album_type from spotify

select max(duration_min) from spotify

select min(duration_min) from spotify

select * from spotify where duration_min=0

delete from spotify where duration_min=0

select distinct most_played_on from spotify

-------------------------------
-- DATA ANALYSIS -EASY CATEGORY
-------------------------------

--Q1 Retrieve the names of all tracks that have more than 1 billion streams.

	select 
	track,stream
	from spotify
	where stream >=1000000000

	
--Q2List all albums along with their respective artists.

	select distinct album, artist
	from spotify
	order by 1

	
--Q3Get the total number of comments for tracks where licensed = TRUE.

	
	select count(comments)
	from spotify
	where licensed = true


--Q4Find all tracks that belong to the album type single.

 select
 track, album_type
	from spotify
	where album_type = 'single'


	
--Q5Count the total number of tracks by each artist.


select count(track),
	artist
	from spotify
	group by 2




-------------------------------
-- DATA ANALYSIS -MEDIUM CATEGORY
-------------------------------

--Q1 Calculate the average danceability of tracks in each album.

 select avg(danceability), album
	 from spotify
	 group by album

--Q2 Find the top 5 tracks with the highest energy values.

select track, max(energy)
	 from spotify
	group by 1
	 order by 2 desc
	 limit 5


	 
--Q3 List all tracks along with their views and likes where official_video = TRUE.

	 select
	 track,
	 sum(views),
	 sum (likes)
	 from spotify
	 where official_video = TRUE
	group by track
	order by sum(views) desc
	 

	 
--Q4 For each album, calculate the total views of all associated tracks.

select count(distinct album) from spotify

	 select album,
	 track,
	 sum(views) as total_views
	 from spotify
	 group by album, track
	order by 2 desc
	 
--Q5 Retrieve the track names that have been streamed on Spotify more than YouTube.
select *
	from
(select 
	track,
	coalesce(sum(case when most_played_on = 'Youtube' THEN stream END),0) as streamed_on_YT,
	coalesce(sum(case when most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify
	from spotify
	group by 1
	) as t1
	where streamed_on_spotify>streamed_on_YT
	and
	streamed_on_YT <>0

-------------------------------
-- DATA ANALYSIS -ADVANCE CATEGORY
-------------------------------
--Q1 Find the top 3 most-viewed tracks for each artist using window functions.


	with ranking_artist
	as
	(
select 
	artist,
	track,
	sum(views) as total_view,
	dense_rank() over (partition by artist order by sum(views)) as rank
	from spotify
	group by 1,2
	order by 1,3 desc

 )

	select * from ranking_artist
	where rank <=3
	
--Q2 Write a query to find tracks where the liveness score is above the average.

select
	track,
	artist,
	liveness
	from spotify
	where liveness > (select avg(liveness) from spotify)



	
	
--Q3 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
--Q4Find tracks where the energy-to-liveness ratio is greater than 1.2.

select * from spotify

SELECT 
track, 
energy, 
liveness, 
(energy::numeric / NULLIF(liveness, 0)::numeric) AS energy_to_liveness_ratio
FROM spotify
WHERE 
(energy::numeric / NULLIF(liveness, 0)::numeric) > 1.2;



--Q5 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT 
    track,
    likes,
    views,
    SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM 
    spotify
ORDER BY 
    views desc;
