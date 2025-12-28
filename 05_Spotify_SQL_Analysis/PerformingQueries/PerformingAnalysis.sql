USE spotify;

SELECT * FROM spotify;

-- ---------------------------

-- DATA ANALYSIS - EASY CATEGORY

-- ---------------------------

/* 
Q.1 Retrieve the names of all tracks that have more than 1 billion streams.
*/

SELECT * FROM spotify 
WHERE stream > 100000000;


/* 
Q.2. List all albums along with their respective artists.
*/

SELECT DISTINCT
    artist,
    album
FROM spotify;


/* 
Q.3. Get the total number of comments for tracks where licensed = TRUE.
*/

SELECT 
	SUM(comments) as No_of_Comments
FROM spotify 
where licensed = 1;

/* 
Q.4. Find all tracks that belong to the album type single.
*/

SELECT 
	DISTINCT(track)
FROM spotify
WHERE album_type = 'single';

/* 
Q.5. Count the total number of tracks by each artist.
*/

SELECT 
	artist,
    COUNT(*) AS Total_Track
FROM spotify
GROUP BY artist
ORDER BY Total_Track DESC;



-- ---------------------------

-- DATA ANALYSIS - MEDIUM CATEGORY

-- ---------------------------

/*
Q.1 Calculate the average danceability of tracks in each album.
*/


SELECT 
	DISTINCT(album),
    ROUND(AVG(danceability),2) AS Avg_Danceabilty
FROM spotify
GROUP BY album
ORDER BY Avg_Danceabilty DESC;

/*
Q.2 Find the top 5 tracks with the highest energy values.
*/

SELECT 
	track,
    MAX(energy) AS Energy_Values
FROM spotify
GROUP BY track
ORDER BY Energy_Values DESC
LIMIT 5;


/*
Q.3 List all tracks along with their views and likes where official_video = TRUE.
*/

SELECT 
	track,
    SUM(views) AS total_views,
    SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 1
GROUP BY track;

/*
Q.4 For each album, calculate the total views of all associated tracks.
*/

SELECT 
	album,
    track,
    SUM(views) AS Total_View
FROM spotify
GROUP BY album,track
ORDER BY Total_View DESC;

/*
Q.5 Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

WITH streaming_config 
AS 
(
SELECT 
	track,
    COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_Youtube,
    COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_Spotify
FROM spotify
GROUP BY track
)

SELECT 
	track,
    streamed_on_Spotify
FROM streaming_config 
WHERE streamed_on_Spotify > streamed_on_Youtube;


-- ---------------------------

-- DATA ANALYSIS - ADVANCE CATEGORY

-- ---------------------------

/*
Find the top 3 most-viewed tracks for each artist using window functions.
*/

WITH TOP_3 
AS 
(
SELECT 
	artist,
	track,
    SUM(views) AS Views,
    DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rnk
FROM spotify
GROUP BY artist,track
)

SELECT 
	artist,
    track,
    VIEWS
FROM TOP_3
WHERE rnk<=3;



/*
Write a query to find tracks where the liveness score is above the average.
*/

SELECT 
	track,
    artist,
    liveness
FROM spotify
WHERE liveness > (
			SELECT AVG(liveness)
				FROM spotify

);

/*
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
*/

WITH album_energy_stats AS (
    SELECT
        album,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT
    album,
    max_energy - min_energy AS energy_difference
FROM album_energy_stats
ORDER BY energy_difference DESC;




/*
Find tracks where the energy-to-liveness ratio is greater than 1.2.
*/

SELECT
    track,
    artist,
    energy,
    liveness,
    energy / liveness AS energy_liveness_ratio
FROM spotify
WHERE liveness > 0
  AND energy / liveness > 1.2;




/*
Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/


SELECT
    track,
    total_views,
    total_likes,
    SUM(total_likes) OVER (
        ORDER BY total_views DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_likes
FROM (
    SELECT
        track,
        SUM(views) AS total_views,
        SUM(likes) AS total_likes
    FROM spotify
    GROUP BY track
) t
ORDER BY total_views DESC;

