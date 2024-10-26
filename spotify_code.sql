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
--Q2List all albums along with their respective artists.
--Q3Get the total number of comments for tracks where licensed = TRUE.
--Q4Find all tracks that belong to the album type single.
--Q5Count the total number of tracks by each artist.







-------------------------------
-- DATA ANALYSIS -MEDIUM CATEGORY
-------------------------------

--Q1 Calculate the average danceability of tracks in each album.


	SELECT * from spotify
	limit 10;

 select avg(danceability), album
	 from spotify
	 group by album


	
--Q2 Find the top 5 tracks with the highest energy values.
--Q3 List all tracks along with their views and likes where official_video = TRUE.
--Q4 For each album, calculate the total views of all associated tracks.
--Q5 Retrieve the track names that have been streamed on Spotify more than YouTube.

-------------------------------
-- DATA ANALYSIS -ADVANCE CATEGORY
-------------------------------
--Q1 Find the top 3 most-viewed tracks for each artist using window functions.
--Q2 Write a query to find tracks where the liveness score is above the average.
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
--Q5 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.