USE spotify;

-- EDA

-- 1.Total records in the dataset

SELECT COUNT(*) FROM spotify;

-- 2.Number of artists

SELECT COUNT(DISTINCT(artist)) FROM spotify;

-- Number of Albums

SELECT COUNT(DISTINCT(album)) FROM spotify; 

-- Different Types of Albums

SELECT DISTINCT album_type FROM spotify;

-- Maxmum Duration

SELECT MAX(duration_min) FROM spotify;

-- Minimum Duration

SELECT Min(duration_min) FROM spotify;


-- PERFORMING EDA ON Duration

SET SQL_SAFE_UPDATES = 0;

SELECT * FROM Spotify
WHERE duration_min = 0;

DELETE FROM Spotify
WHERE duration_min = 0;

-- Channels 
SELECT DISTINCT channel FROM spotify;


-- Most PLayed Platforms

SELECT DISTINCT most_played_on FROM Spotify;
	