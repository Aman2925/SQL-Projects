USE spotify;

SET GLOBAL local_infile = 1;


LOAD DATA LOCAL INFILE '/Users/amanjayeshshah/SQL PROJECTS/Spotify/cleaned_dataset.csv'
INTO TABLE spotify
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    artist,
    track,
    album,
    album_type,
    @danceability,
    @energy,
    @loudness,
    @speechiness,
    @acousticness,
    @instrumentalness,
    @liveness,
    @valence,
    @tempo,
    @duration_min,
    title,
    channel,
    @views,
    @likes,
    @comments,
    @licensed,
    @official_video,
    @stream,
    @energy_liveness,
    most_played_on
)
SET
    danceability      = NULLIF(@danceability, ''),
    energy             = NULLIF(@energy, ''),
    loudness           = NULLIF(@loudness, ''),
    speechiness        = NULLIF(@speechiness, ''),
    acousticness       = NULLIF(@acousticness, ''),
    instrumentalness   = NULLIF(@instrumentalness, ''),
    liveness            = NULLIF(@liveness, ''),
    valence             = NULLIF(@valence, ''),
    tempo               = NULLIF(@tempo, ''),
    duration_min        = NULLIF(@duration_min, ''),
    views               = NULLIF(@views, ''),
    likes               = NULLIF(@likes, ''),
    comments            = CASE 
                             WHEN LOWER(@comments) IN ('true','false') THEN NULL
                             ELSE NULLIF(@comments, '')
                          END,
    licensed            = CASE 
                             WHEN LOWER(@licensed) IN ('true','1','yes') THEN 1 
                             ELSE 0 
                          END,
    official_video      = CASE 
                             WHEN LOWER(@official_video) IN ('true','1','yes') THEN 1 
                             ELSE 0 
                          END,
    stream              = NULLIF(@stream, ''),
    energy_liveness     = NULLIF(@energy_liveness, '');
    
    
SHOW WARNINGS;


/*

“While loading the Spotify dataset using LOAD DATA LOCAL INFILE, one row was structurally malformed in the source CSV. 
MySQL raised truncation warnings, which I validated using SHOW WARNINGS. 
Since it affected only one row out of ~20k, I documented and excluded it during analysis.”

*/
