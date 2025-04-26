-- Netflix Data Analysis
-- __________________________________________________________________________________________________________

/* 1. Using the Viewing History table,
identify the top 3 most-watched movies based on average viewing hours. */

SELECT 
	TitleName AS "Movie",
	ROUND(AVG(Runtime),2) AS "Viewing hours"
FROM viewinghistory V JOIN content C 
ON V.ContentID=C.ContentID 
WHERE Category="Movie"
GROUP BY TitleName
ORDER BY 2 DESC
LIMIT 3;

/* 2. Partition the viewing hours by category and genre to find the top genre in each category.
Use the rank function to rank genres within each category. */

WITH df AS (
	SELECT 
		Category,
		Genre,
		ROUND(AVG(Runtime),2) AS "Viewing_hours",
		RANK() OVER (
			PARTITION BY Category 
			ORDER BY AVG(Runtime) DESC
			) AS "Genre_rank"
	FROM viewinghistory V JOIN content C 
	ON V.ContentID=C.ContentID
	GROUP BY Category,Genre
    )
SELECT Category,
		Genre,
        Viewing_hours
FROM df
WHERE Genre_rank=1;

/* 3. Determine the number of subscriptions for each plan. 
Display PlanID, PlanName and Subscriber_count in descending order of Subscriber_count. */
 
 SELECT 
	 P.PlanID,
	 PlanName,
	 COUNT(*) AS "Subscriber_count"
 FROM plans P JOIN subscribes S 
 ON P.PlanID=S.PlanID 
 GROUP BY P.PlanID;
 
 /* 4. Which device type is most commonly used to access Netflix content?
 Provide the DeviceType and count of accesses. */
 
 SELECT DeviceType,
 COUNT(*) AS "Access_Count"
 FROM devices 
 GROUP BY DeviceType 
 ORDER BY 2 DESC
 LIMIT 1;
 
 /* 5. Compare the viewing trends of movies versus TV shows.
 What is the average viewing time for movies and TV shows separately? */
 
 SELECT 
 Category,
 ROUND(AVG(Runtime),2) AS "Average viewing time" 
 FROM content C JOIN viewinghistory V 
 ON C.ContentID=V.ContentID
 GROUP BY Category;
 
 /* 6. Identify the most preferred language by customers.
 Provide the number of customers ,and language. */
 
 SELECT 
	 Language,
	 COUNT(*) AS "Customer_count"
 FROM customers C JOIN customerslanguagepreferred CL 
 ON C.CUSTID=CL.CustID
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 1;
 
 /* 7. How many customers have adult accounts versus child accounts?
 Provide the count for each type. */
 
SELECT 
	"Adult" as "Account_type" ,
	COUNT(*) AS "Account_count"
FROM adultacc
UNION 
SELECT 
	"Child" as "Account_type" ,
	COUNT(*) AS "Account_count"
FROM childacc;

/* 8. Determine the average number of profiles created per customer account. */

WITH df AS (
	SELECT 
		CustID,
        COUNT(ProfileID) AS "Profile_count"
	FROM profiles 
    GROUP BY CustID
    )
SELECT 
	ROUND(AVG(Profile_count))
    AS "Average_profile_count" 
from df;

/* 9. Identify the content that has the lowest average viewing time per user.
Provide the titles and their average viewing time. */

SELECT 
	TitleName,
	ROUND(AVG(Runtime),2) AS "Average_viewing_time"
FROM viewinghistory V JOIN content C 
ON V.ContentID=C.ContentID 
GROUP BY TitleName
ORDER BY 2 
LIMIT 1;

/* 10. Determine the count for each content type. */

SELECT Category,
COUNT(*)
FROM content 
GROUP BY Category;

/* 11. Compare the number of customers that have unlimited access and who do not. */

SELECT 
	UnlimitedAccess,
	COUNT(*) AS "Customer_count"
FROM content C JOIN viewinghistory V ON C.ContentID=V.ContentID
JOIN profiles P ON V.ProfileID=P.ProfileID
GROUP BY UnlimitedAccess;

/* 12. Find Average monthly price for plans with Content Access as "unlimited". */

SELECT 
ROUND(AVG(MonthlyPrice),2) AS "Average_monthly_price"
FROM plans 
WHERE ContentAccess= "unlimited";




 


 


 
 
 
 