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
 GROUP BY P.PlanID
 ORDER BY 3 DESC;
 
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

SELECT ContentAccess, count(*) FROM subscribes S
JOIN plans P on
S.PlanID=P.PlanID
group by ContentAccess;

/* 12. Find Average monthly price for plans with Content Access as "unlimited". */

SELECT 
ROUND(AVG(MonthlyPrice),2) AS "Average_monthly_price"
FROM plans 
WHERE ContentAccess= "unlimited";

/*13. List all the customers who have taken the plan for till 2028 and later.
Display CustomerID, Customer name and ExpirationDate of the plan,
ordered by ExpirationDate in descending order first, and then by Customer Name. */

SELECT 
	C.CUSTID,
	CONCAT(FNAME," ",LNAME) AS "Customer Name",
	ExpirationDate	
FROM paymentmethod P JOIN customers C 
ON P.CUSTID=C.CUSTID
WHERE YEAR(ExpirationDate)>=2028
ORDER BY 3 DESC , 2;

/* 14. Display Average Revenue generated from each city.
Rank city based on average revenue.*/ 

SELECT 
	State,
	ROUND(AVG(PaymentAmount),2) AS "Avg_revenue",
	DENSE_RANK() OVER(ORDER BY AVG(PaymentAmount) DESC) AS "Rank"
FROM paymenthistory P JOIN paymentmethod P1 
ON P.CardID = P1.CardID 
GROUP BY State;

/*15. Display most frequently viewed genre among adults for each category. */

WITH df AS (
	SELECT 
		Genre,
		Category,
		count(*) AS "View_Count",
		RANK() OVER(PARTITION BY Category ORDER BY COUNT(*) DESC) AS "View_Rank"
	FROM content C 
    JOIN viewinghistory V ON C.ContentID = V.ContentID
	JOIN profiles P ON V.ProfileID = P.ProfileID
	JOIN adultacc A ON P.ProfileID = A.ProfileID
	GROUP BY Genre,Category
)
SELECT 
	Genre,
	Category,
	View_Count 
FROM df WHERE View_Rank=1;


 


 
 
 
 