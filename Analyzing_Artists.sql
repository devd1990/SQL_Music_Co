/* Analyzing Music Artists */


/* 1. How many artists do I have? */

SELECT COUNT(DISTINCT a.ArtistId) FROM Artist a ;

/* 
	COUNT(DISTINCT ArtistId)|
	------------------------|
    	                 275|
*/


/* 2. How many albums does each artist have? */


SELECT Name, ArtistId, COUNT(AlbumId) as no_albums, COUNT(Title) as no_titles 
FROM 	
(SELECT * 
 	FROM Album a
	LEFT JOIN Artist b 
	ON a.ArtistId = b.ArtistId
)
GROUP BY Name, ArtistId
ORDER BY no_albums DESC ;

/*
	Name             |ArtistId|no_albums|no_titles|
	-----------------|--------|---------|---------|
	Iron Maiden      |      90|       21|       21|
	Led Zeppelin     |      22|       14|       14|
	Deep Purple      |      58|       11|       11|
	Metallica        |      50|       10|       10|
	U2               |     150|       10|       10|
	Ozzy Osbourne    |     114|        6|        6|
	Pearl Jam        |     118|        5|        5|
	Faith No More    |      82|        4|        4|
	Foo Fighters     |      84|        4|        4|
	Lost             |     149|        4|        4|
	Van Halen        |     152|        4|        4|
	Various Artists  |      21|        4|        4|
	
	....... etc.
*/


/* 3. How many genres and media types does each artist compose? */

SELECT Artist, COUNT(DISTINCT Genre) as no_genres, COUNT(DISTINCT MediaType) as no_media 
FROM 
	(SELECT t1.*, a1.Name as Artist, g1.Name as Genre, m1.Name as MediaType FROM 
 		Track as t1 
 		LEFT JOIN
 		(SELECT DISTINCT b.Name, a.AlbumId, a.ArtistId 
 			FROM Album a
			LEFT JOIN Artist b 
			ON a.ArtistId = b.ArtistId
		 ) as a1
		 ON t1.AlbumId = a1.AlbumId
		 LEFT JOIN Genre as g1
		 ON t1.GenreId = g1.GenreId 
		 LEFT JOIN MediaType as m1
		 ON t1.MediaTypeId = m1.MediaTypeId
	 )
GROUP BY Artist
ORDER BY no_genres DESC ;

/*
	Artist 	                 |no_genres|no_media|
	-------------------------|---------|--------|
	Iron Maiden              |        4|       2|
	Various Artists          |        3|       1|
	Lenny Kravitz            |        3|       1|
	Jamiroquai               |        3|       1|
	Gilberto Gil             |        3|       1|
	Battlestar Galactica     |        3|       1|
	Audioslave               |        3|       3|
	U2                       |        2|       2|
	The Office               |        2|       1|
	Red Hot Chili Peppers    |        2|       1|
	R.E.M.                   |        2|       1|
	Pearl Jam                |        2|       1|
	Ozzy Osbourne            |        2|       2|
	Lost                     |        2|       1|
	
	....... etc.
 */


/* 4. Show top 5 artists by number of tracks and their genres, media types and price potential */

SELECT Artist, Genre, MediaType, COUNT(TrackId) as no_tracks, SUM(UnitPrice) as total_price 
FROM 
	(SELECT d2.* FROM
		(
			(
			SELECT Artist, COUNT(TrackId) as no_tracks 
			FROM 
				(SELECT t1.*, a1.Name as Artist, g1.Name as Genre, m1.Name as MediaType FROM 
			 		Track as t1 
			 		LEFT JOIN
			 		(SELECT DISTINCT b.Name, a.AlbumId, a.ArtistId 
			 			FROM Album a
						LEFT JOIN Artist b 
						ON a.ArtistId = b.ArtistId
					 ) as a1
					 ON t1.AlbumId = a1.AlbumId
					 LEFT JOIN Genre as g1
					 ON t1.GenreId = g1.GenreId 
					 LEFT JOIN MediaType as m1
					 ON t1.MediaTypeId = m1.MediaTypeId
				 )
			GROUP BY Artist
			ORDER BY no_tracks DESC
			LIMIT 5
			) as d1 
			LEFT JOIN
			(SELECT t1.*, a1.Name as Artist, g1.Name as Genre, m1.Name as MediaType FROM 
		 		Track as t1 
		 		LEFT JOIN
		 		(SELECT DISTINCT b.Name, a.AlbumId, a.ArtistId 
		 			FROM Album a
					LEFT JOIN Artist b 
					ON a.ArtistId = b.ArtistId
				 ) as a1
				 ON t1.AlbumId = a1.AlbumId
				 LEFT JOIN Genre as g1
				 ON t1.GenreId = g1.GenreId 
				 LEFT JOIN MediaType as m1
				 ON t1.MediaTypeId = m1.MediaTypeId
			) as d2
			ON d1.Artist = d2.Artist
		)
	 )
GROUP BY Artist, Genre, MediaTypeId 
ORDER BY no_tracks DESC;

/*
	Artist      |Genre      |MediaType                  |no_tracks|total_price       |
	------------|-----------|---------------------------|---------|------------------|
	Led Zeppelin|Rock       |MPEG audio file            |      114|112.85999999999979|
	Metallica   |Metal      |MPEG audio file            |      112| 110.8799999999998|
	U2          |Rock       |MPEG audio file            |      112| 110.8799999999998|
	Iron Maiden |Metal      |MPEG audio file            |       95| 94.04999999999988|
	Iron Maiden |Rock       |MPEG audio file            |       70| 69.30000000000001|
	Lost        |TV Shows   |Protected MPEG-4 video file|       48| 95.51999999999994|
	Lost        |Drama      |Protected MPEG-4 video file|       44| 87.55999999999996|
	Iron Maiden |Heavy Metal|MPEG audio file            |       28|27.719999999999985|
	U2          |Pop        |Protected AAC audio file   |       23|22.769999999999992|
	Iron Maiden |Rock       |Protected AAC audio file   |       11|             10.89|
	Iron Maiden |Blues      |MPEG audio file            |        9|              8.91|
*/