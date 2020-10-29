/* Analyzing Customers and Employees */

/* Who are my top 10 customers by sales? */

SELECT FirstName, LastName, SUM(Total) as Total_Purchase 
FROM 	
(SELECT * 
 	FROM Customer as a
	LEFT JOIN Invoice as b 
	ON a.CustomerId = b.CustomerId 
)
GROUP BY FirstName, LastName
ORDER BY Total_Purchase DESC
LIMIT 10;

/*
	FirstName|LastName  |Total_Purchase    |
	---------|----------|------------------|
	Helena   |Holý      |49.620000000000005|
	Richard  |Cunningham|47.620000000000005|
	Luis     |Rojas     |             46.62|
	Hugh     |O'Reilly  |             45.62|
	Ladislav |Kovács    |             45.62|
	Julia    |Barnett   |43.620000000000005|
	Frank    |Ralston   |             43.62|
	Fynn     |Zimmermann|             43.62|
	Astrid   |Gruber    |             42.62|
	Victor   |Stevens   |             42.62|
*/


/* What are my top customers buying? */



SELECT FirstName, LastName, Artist, Genre, count(TrackID) as no_tracks 
FROM
(SELECT inv2.FirstName, inv2.LastName, tr.Artist, tr.Genre, tr.TrackID FROM 
(SELECT topcust2.FirstName, topcust2.LastName, topcust2.InvoiceID, il.TrackId
	FROM 
	(SELECT topcust.FirstName, topcust.LastName, inv.InvoiceId
		FROM 
		(SELECT FirstName, LastName, CustomerId, SUM(Total) as Total_Purchase 
			FROM 	
			(SELECT * 
			 	FROM Customer as a
				LEFT JOIN Invoice as b 
				ON a.CustomerId = b.CustomerId 
			)
			GROUP BY FirstName, LastName
			ORDER BY Total_Purchase DESC
			LIMIT 10
		) as topcust
		LEFT JOIN
		Invoice as inv
		ON topcust .CustomerId = inv.CustomerId
	) as topcust2
	LEFT JOIN InvoiceLine as il
	ON topcust2.InvoiceId = il.InvoiceId
) as inv2
LEFT JOIN
(SELECT t1.*, a1.Name as Artist, g1.Name as Genre 
	FROM 
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
)as tr
ON inv2.TrackId = tr.TrackId
)
GROUP BY FirstName, LastName, Artist, Genre
ORDER BY no_tracks DESC;

/*
	FirstName|LastName  |Artist                        |Genre             |no_tracks|
	---------|----------|------------------------------|------------------|---------|
	Astrid   |Gruber    |U2                            |Rock              |        9|
	Richard  |Cunningham|U2                            |Rock              |        8|
	Hugh     |O'Reilly  |Lost                          |TV Shows          |        7|
	Hugh     |O'Reilly  |Chico Science & Nação Zumbi   |Latin             |        6|
	Hugh     |O'Reilly  |U2                            |Rock              |        6|
	Luis     |Rojas     |Led Zeppelin                  |Rock              |        6|
	Frank    |Ralston   |Led Zeppelin                  |Rock              |        5|
	Frank    |Ralston   |The Office                    |Comedy            |        5|
	Helena   |Holý      |Caetano Veloso                |Latin             |        5|
	Helena   |Holý      |Lost                          |TV Shows          |        5|
	Helena   |Holý      |U2                            |Rock              |        5|
	Richard  |Cunningham|Chico Buarque                 |Latin             |        5|
	Astrid   |Gruber    |Lost                          |TV Shows          |        4|
	Astrid   |Gruber    |The Who                       |Rock              |        4|
	Frank    |Ralston   |Legião Urbana                 |Latin             |        4|
	Frank    |Ralston   |Queen                         |Rock              |        4|
	Fynn     |Zimmermann|Djavan                        |Latin             |        4|
	Fynn     |Zimmermann|Led Zeppelin                  |Rock              |        4|
	Hugh     |O'Reilly  |The Tea Party                 |Alternative & Punk|        4|
	Julia    |Barnett   |Battlestar Galactica (Classic)|Sci Fi & Fantasy  |        4|
	
	....... etc.
*/


/* Who of my employees are selling the most and how much? */

SELECT e.FirstName , e.LastName, e.Title, topcust.No_Purchase as No_Sales, topcust.Total_Sales
FROM
(SELECT SupportRepId, COUNT(InvoiceID) as No_Purchase, SUM(Total) as Total_Sales
	FROM 	
	(SELECT * 
	 	FROM Customer as a
		LEFT JOIN Invoice as b 
		ON a.CustomerId = b.CustomerId 
	)
	GROUP BY SupportRepId
) as topcust
LEFT JOIN Employee as e
ON topcust.SupportRepId = e.EmployeeId;

/*
	FirstName|LastName|Title              |No_Sales|Total_Sales      |
	---------|--------|-------------------|--------|-----------------|
	Jane     |Peacock |Sales Support Agent|     146|833.0400000000013|
	Margaret |Park    |Sales Support Agent|     140|775.4000000000011|
	Steve    |Johnson |Sales Support Agent|     126| 720.160000000001|
*/

