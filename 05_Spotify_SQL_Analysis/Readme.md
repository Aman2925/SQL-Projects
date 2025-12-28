# 🎵 Spotify Music Data Analysis – SQL Project

## Project Overview

**Project Title**: Spotify Music Data Analysis
**Level**: Basic to Intermediate
**Database**: `spotify_db` (or single-table analysis)

This project focuses on analyzing a Spotify music dataset using **SQL** to explore **track popularity, artist performance, album characteristics, and user engagement patterns**. The analysis combines **audio features** with **engagement metrics** to answer practical, real-world analytical questions.

The project demonstrates the use of **SQL aggregations, CTEs, window functions, and conditional logic**, which are essential skills for entry-level and intermediate **Data Analyst** roles.

---

## Objectives

1. Analyze **track, album, and artist-level performance**
2. Compare **engagement metrics** such as views, likes, and streams
3. Study **audio features** like energy, liveness, and tempo
4. Identify **top-performing tracks and artists**
5. Apply **CTEs and window functions** for analytical queries
6. Derive **insights from real-world music data** using SQL

---

## Dataset Overview

The dataset consists of Spotify track-level data containing information about:

* Artist and track details
* Album and album type
* Audio features (energy, danceability, tempo, liveness, etc.)
* Engagement metrics (views, likes, comments, streams)
* Platform information (Spotify, YouTube)

The dataset contains **20,000+ records** and represents real-world music streaming data suitable for SQL-based exploratory and analytical analysis.

---

## Database & Table Structure

The analysis is performed on a single table named `spotify`, designed to store all relevant attributes required for analysis.

### Key Columns

* **Track & Artist Info**: `artist`, `track`, `album`, `album_type`
* **Audio Features**: `energy`, `danceability`, `liveness`, `tempo`, `duration_min`
* **Engagement Metrics**: `views`, `likes`, `comments`, `stream`
* **Metadata**: `licensed`, `official_video`, `most_played_on`

Proper data types were assigned to support analytical calculations and comparisons.

---

## Data Loading & Cleaning

* Data was loaded using `LOAD DATA LOCAL INFILE` for efficient bulk ingestion.
* Boolean values were standardized.
* Missing or invalid numeric values were handled using `NULL`.
* One malformed row was identified and documented, reflecting real-world data quality challenges.

This ensured the dataset was reliable and ready for analysis.

---

## Analysis & SQL Tasks

### 1️⃣ Tracks Streamed More on Spotify than YouTube

This query compares total streams across platforms and identifies tracks that perform better on Spotify than on YouTube using conditional aggregation.

---

### 2️⃣ Top 3 Most-Viewed Tracks for Each Artist

Using window functions (`DENSE_RANK`), this query ranks tracks based on views within each artist group and extracts the top three tracks per artist.

---

### 3️⃣ Cumulative Sum of Likes Ordered by Views

This analysis calculates the running total of likes when tracks are ordered by total views, demonstrating how engagement accumulates with popularity.

---

### 4️⃣ Energy Variation Across Albums

A CTE is used to calculate the difference between the highest and lowest energy values for tracks within each album, helping identify albums with diverse musical styles.

---

### 5️⃣ Energy-to-Liveness Ratio Analysis

This query identifies tracks where the energy-to-liveness ratio exceeds a defined threshold, helping distinguish studio-focused tracks from live-style performances.

---

## SQL Concepts Demonstrated

* `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
* Aggregate functions (`SUM`, `AVG`, `MAX`, `MIN`)
* Conditional logic (`CASE`, `COALESCE`, `NULLIF`)
* Common Table Expressions (CTEs)
* Window Functions (`RANK`, `DENSE_RANK`, `SUM() OVER`)
* Ratio and comparative analysis

---

## Tools Used

* **MySQL**
* **SQL Workbench**
* **GitHub**

---

## Key Insights

* Tracks with higher views tend to accumulate likes rapidly.
* A small number of tracks contribute significantly to total engagement.
* Energy variation within albums highlights diversity in musical composition.
* Platform-wise comparisons reveal differences in streaming behavior.

---

## Key Learnings & Outcomes

* Strengthened understanding of **SQL-based data analysis**
* Gained hands-on experience with **CTEs and window functions**
* Improved ability to translate **analytical questions into SQL queries**
* Learned to handle **real-world data inconsistencies**

---

## How to Use This Project

1. Clone the repository:

```bash
git clone https://github.com/HeyChamp29/SQL-Projects.git
```

2. Navigate to the Spotify project folder:

```bash
cd SQL-Projects/05_Spotify_SQL_Analysis
```

3. Load the dataset into MySQL and execute the queries sequentially.

---

## Conclusion

This project demonstrates how SQL can be effectively used to analyze music streaming data and extract meaningful insights. It reflects practical analytical thinking and serves as a solid portfolio project for aspiring **Data Analysts**.

---

## Author

**Aman Shah**
🎓 B.Tech Engineering Student
📍 Mumbai, India
💼 Aspiring Data Analyst

🔗 GitHub: [https://github.com/Aman2925](https://github.com/Aman2925)
🔗 LinkedIn: [https://www.linkedin.com/in/aman-shah-546775255/](https://www.linkedin.com/in/aman-shah-546775255/)

---

