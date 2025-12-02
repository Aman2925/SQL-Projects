<h1 align="center">🎬 Netflix Shows and Movies Project</h1>

<p align="center">
  <img src="https://cdn.dribbble.com/userupload/34116929/file/original-26e501e97684a115bfff294b1f1d41b0.png" width="600">
</p>

<br>

<p align="center">
  🧰 <b>Tools Used:</b> MySQL, Python
</p>

<p align="center">
  📂 <b>Dataset Used:</b>
  <a href="https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies?select=titles.csv" target="_blank">
    Netflix TV Shows and Movies (Kaggle)
  </a>
</p>

<p align="center">
  🧾 <b>SQL Analysis:</b>
  <a href="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/NetflixProj.sql" target="_blank">
    View SQL Script
  </a>
</p>

<p align="center">
  📊 <b>Power BI Dashboard:</b>
  <a href="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/NetflixDashboard(PowerBi).png" target="_blank">
    View Dashboard
  </a>
</p>

<br>

<div align="center" style="max-width:800px;">
  <p>
    <b>Business Problem:</b> 🎯 Netflix wants to gain a deeper understanding of subscriber preferences and content performance across its vast library of shows and movies. With over 82,000 records spanning multiple genres, countries, and years, manually analyzing this data is nearly impossible. Without proper insights, it becomes challenging to make data-driven decisions for content strategy, marketing, and viewer engagement. Netflix needs a robust, scalable method to extract meaningful patterns that highlight popular genres, trending releases, and regional preferences.
  </p>

  <p>
    <b>Solution Approach:</b> 🛠️ I will leverage SQL to process and analyze the large dataset efficiently, enabling the extraction of key metrics such as average viewer ratings, genre distribution, release trends, and country-wise popularity. Once the data is prepared, I will use Tableau to create interactive dashboards and visualizations that allow Netflix stakeholders to explore the insights dynamically. This approach ensures that trends and patterns are easily understandable, actionable, and can directly inform Netflix’s content acquisition, recommendation systems, and marketing strategies.
  </p>
</div>

<br>

<h2>❓ Questions I Wanted To Answer From the Dataset:</h2>

<br>
<h2>1. Which movies and shows on Netflix ranked in the top 10 and bottom 10 based on their IMDB scores?</h2>
<br>

<h3>🎥 Top 10 Movies</h3>

<h3>🎥 Top 10 Movies</h3>

<ul>
  <li>
    <b>SQL Query:</b>
    <pre><code>
CREATE VIEW TOP10_MOVIES AS 
SELECT 
  TITLE,
  TYPE,
  IMDB_SCORE
FROM netflix_titles
WHERE TYPE = 'MOVIE'
ORDER BY IMDB_SCORE DESC
LIMIT 10;

SELECT * FROM TOP10_MOVIES;
    </code></pre>
  </li>

  <li>
    <b>Result:</b>
    <br><br>
    <p align="center">
      <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question1.png" width="700">
    </p>
  </li>
</ul>

<br>

<h3>📺 Top 10 Shows</h3>

<ul>
  <li>
    <b>SQL Query:</b>
    <pre><code>
CREATE VIEW TOP10_SHOWS AS 
SELECT 
  TITLE,
  TYPE,
  DESCRIPTION,
  RELEASE_YEAR,
  IMDB_SCORE
FROM netflix_titles
WHERE TYPE = 'SHOW'
ORDER BY IMDB_SCORE DESC
LIMIT 10;

SELECT * FROM TOP10_SHOWS;
    </code></pre>
  </li>

  <li>
    <b>Result:</b>
    <br><br>
    <p align="center">
      <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question2.png" width="700">
    </p>
  </li>
</ul>

<h3>🎞️ Bottom 10 Movies</h3>

<ul>
  <li>
    <b>SQL Query:</b>
    <pre><code>
CREATE VIEW BOTTOM10_MOVIES AS
SELECT 
  TITLE, 
  TYPE, 
  IMDB_SCORE
FROM netflix_titles
WHERE TYPE = 'MOVIE' 
  AND IMDB_SCORE IS NOT NULL
ORDER BY IMDB_SCORE ASC
LIMIT 10;

SELECT * FROM BOTTOM10_MOVIES;
    </code></pre>
  </li>

  <li>
    <b>Result:</b>
    <br><br>
    <p align="center">
      <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question3.png" width="700">
    </p>
  </li>
</ul>

<br>

<h3>📉 Bottom 10 Shows</h3>

<ul>
  <li>
    <b>SQL Query:</b>
    <pre><code>
CREATE VIEW BOTTOM10_SHOWS AS 
SELECT 
  TITLE,
  TYPE,
  DESCRIPTION,
  RELEASE_YEAR,
  IMDB_SCORE
FROM netflix_titles
WHERE TYPE = 'SHOW' 
  AND IMDB_SCORE IS NOT NULL
ORDER BY IMDB_SCORE ASC
LIMIT 10;

SELECT * FROM BOTTOM10_SHOWS;
    </code></pre>
  </li>

  <li>
    <b>Result:</b>
    <br><br>
    <p align="center">
      <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question4.png" width="700">
    </p>
  </li>
</ul>

<p>The IMDb score serves as a trusted benchmark for gauging the popularity, impact, and overall quality of movies and shows. The top 10 titles in this analysis reflect content that resonated strongly with audiences — receiving widespread praise for storytelling, performances, and production value. These high-performing titles represent the kind of content that keeps viewers engaged and enhances Netflix’s reputation for premium entertainment. Conversely, the bottom 10 titles reveal the less successful side of the spectrum. Their lower IMDb scores suggest weaker audience reception, which could be attributed to shortcomings in direction, narrative strength, or viewer relatability. Analyzing both extremes allows for a balanced understanding of audience sentiment. It not only identifies the standout titles that drive engagement but also highlights areas where Netflix can refine its content strategy — such as improving curation, promoting diverse genres, or re-evaluating underperforming productions. Ultimately, this comparison provides a meaningful glimpse into what viewers truly value and how their preferences shape the success of Netflix’s catalog.</p>


<h2>📅 2. How Many Movies and Shows Fall in Each Decade in Netflix's Library?</h2>

<ul>
  <li>
    <b>SQL Query:</b>
    <pre><code>
CREATE VIEW DECADE_WISE_SELECTION AS
SELECT 
  CONCAT(FLOOR(release_year/10)*10, 's') AS Decade,
  COUNT(*) AS movies_shows_count
FROM netflix_titles
GROUP BY CONCAT(FLOOR(release_year/10)*10, 's')
ORDER BY Decade;

SELECT * FROM DECADE_WISE_SELECTION;
    </code></pre>
  </li>

  <li>
    <b>Result:</b>
    <br><br>
    <p align="center">
      <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question5.png" width="700">
    </p>
  </li>
</ul>

<p>
  The decade-wise breakdown provides an overview of how Netflix’s library has evolved through time. 
  The data reveals that the majority of content comes from the 2010s and 2020s, reflecting Netflix’s 
  focus on acquiring and producing newer titles to match current audience interests. 
  Older decades, while contributing fewer titles, represent classic additions that diversify the platform’s offerings. 
  This distribution emphasizes Netflix’s strategic balance between modern content creation and maintaining a 
  nostalgic connection through select older releases.
</p>

<h2>🔞 3. How Did Age-Certifications Impact the Dataset?</h2> <ul> <li> <b>SQL Query:</b> <pre><code> CREATE VIEW AGE_CERTIFICATION_IMPACT AS SELECT DISTINCT age_certification, ROUND(AVG(imdb_score), 2) AS imdb_score, ROUND(AVG(tmdb_score), 2) AS tmdb_score FROM netflix_titles GROUP BY age_certification ORDER BY imdb_score DESC;
SELECT * FROM AGE_CERTIFICATION_IMPACT;
</code></pre>
</li> <li> <b>Result:</b> <br><br> <p align="center"> <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question6.png" width="700"> </p> </li> </ul> <p> Age certifications are a crucial aspect of content classification, designed to guide viewers on age-appropriate content and help platforms like Netflix manage audience segmentation effectively. This analysis explores how different age-certification categories correlate with audience ratings, using both IMDb and TMDB scores as indicators of content reception. </p> <p> From the results, we observe that titles rated for more mature audiences (such as <code>R</code> or <code>TV-MA</code>) tend to score higher on average than those intended for general or younger audiences (like <code>PG</code> or <code>TV-Y</code>). This trend suggests that mature content may offer more complex narratives, deeper character development, or edgier themes that resonate strongly with audiences and critics alike. </p> <p> Conversely, content designed for children or family viewing, while important for platform diversity, tends to receive slightly lower ratings—possibly due to simpler plots or niche appeal. These insights help Netflix understand the performance of content across different viewer age groups and can inform decisions about where to invest in original programming, how to optimize content recommendations, and how to balance offerings for various audience segments. </p>
<h2>🎭 4. Which Genres Are the Most Common?</h2> <ul> <li> <b>SQL Query (Most Common Genres for Shows):</b> <pre><code> CREATE VIEW MOST_SHOWS_BY_GENRES AS SELECT genres, COUNT(*) AS most_movies FROM netflix_titles WHERE type = 'SHOW' AND genres IS NOT NULL GROUP BY genres ORDER BY most_movies DESC;
SELECT * FROM MOST_SHOWS_BY_GENRES;
</code></pre>
</li> <li> <b>Result:</b><br><br> <p align="center"> <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question13.png" width="700"> </p> </li> </ul> <p> Genre analysis helps Netflix understand what types of content dominate its library and which ones resonate the most with its audience. In this query, we specifically focus on <strong>shows</strong> and group them by their genre to find the most frequently occurring categories. </p> <p> From the results, it's evident that genres such as <strong>Drama</strong>, <strong>Comedy</strong>, and <strong>Reality</strong> top the list, reflecting a strong global appetite for emotionally engaging stories, humor, and unscripted entertainment. These popular genres likely receive higher production budgets and more prominent placements on the platform. </p> <p> Understanding genre trends enables Netflix to tailor its acquisition and production strategies. It can help in identifying oversaturated areas or underrepresented niches, ultimately supporting smarter content investment and more personalized viewer recommendations. </p> <br> <ul> <li> <b>SQL Query (Top 3 Most Common Genres for Movies):</b> <pre><code> CREATE VIEW TOP3_GENRE AS SELECT genres, COUNT(*) AS count_genres FROM netflix_titles WHERE type = 'MOVIE' GROUP BY genres ORDER BY count_genres DESC LIMIT 3;
SELECT * FROM TOP3_GENRE;
</code></pre>
</li> <li> <b>Result:</b><br><br> <p align="center"> <img src="https://github.com/HeyChamp29/Netflix-Shows-and-Movies-SQL/blob/main/Question18.png" width="700"> </p> </li> </ul> <p> While the previous query focused on shows, this one targets <strong>movies</strong> to determine which genres are most prevalent in that category. As seen in the results, genres like <strong>Drama</strong>, <strong>Comedy</strong>, and <strong>Documentary</strong> lead the way — genres that often appeal to wide audiences and are versatile in storytelling. </p> <p> This insight supports Netflix’s efforts to optimize their movie catalog based on viewer demand, helping inform decisions around licensing deals and original film production. </p>

<h2>🧠 Conclusion</h2> <br> <p> This Netflix Shows and Movies SQL project offered a comprehensive deep dive into the platform’s vast content library using structured data analysis. By leveraging SQL, we were able to uncover meaningful patterns related to audience preferences, content ratings, genre distributions, and more. The exploration of top- and bottom-ranked titles through IMDb scores highlighted how certain shows and movies consistently outperform others in terms of viewer reception. Decade-wise content analysis revealed Netflix's clear focus on modern and fresh titles, while still maintaining a touch of older, classic works to cater to a broad spectrum of audiences. </p> <p> Additionally, examining age certifications and genre popularity provided valuable insights into how content is categorized and consumed across different viewer segments. High ratings in mature-rated titles suggest a demand for complex, adult storytelling, while the dominance of genres like Drama and Comedy reflects global tastes. Such findings can guide Netflix in refining their content strategy, optimizing user recommendations, and investing wisely in future productions. This data-driven approach empowers stakeholders to make smarter decisions, ensuring that the platform continues to grow as a leader in the entertainment industry. </p>





