
use VehAcc;
select * from [dbo].[accident];
select * from [dbo].[vehicle];

--Question 1: How many accidents have occurred in urban areas versus rural areas?
select [Area], COUNT([AccidentIndex]) AS 'Total Accident'
from [dbo].[accident]
group by [Area]
Order by [Total Accident] desc

--Question 2: Which day of the week has the highest number of accidents?
select [Day], COUNT(AccidentIndex) as 'Total Accident'
from [dbo].[accident]
group by [Day]
order by [Total Accident] desc

--Question 3: What is the average age of vehicles involved in accidents based on their type?
select [VehicleType], COUNT(AccidentIndex) as 'Total Accident', AVG([AgeVehicle]) as 'Avg age of vehicle'
from [dbo].[vehicle]
where [AgeVehicle] is not NULL
group BY [VehicleType]
order by [Total Accident] desc

--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
select AgeGroup, COUNT(AccidentIndex) as 'Total Accident', 
AVG([AgeVehicle]) as 'Average year'
from(select [AccidentIndex],
[AgeVehicle],
CASE
WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'NEW'
WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'REGULAR'
ELSE 'OLD'
END AS 'AgeGroup'
FROM [dbo].[vehicle]
)AS SubQuery
group by AgeGroup
order by [Average year] desc

--Question 5: Are there any specific weather conditions that contribute to severe accidents?
DECLARE @Severity varchar(100)
SET @Severity='Fatal'
select [WeatherConditions], COUNT([Severity]) as 'Total Accident'
from [dbo].[accident]
where [Severity]=@Severity
group by [WeatherConditions]
order by 'Total Accident' Desc;

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
select [LeftHand], COUNT(AccidentIndex) as 'Total Accident'
from [dbo].[vehicle]
group by [LeftHand]

--Question 7: Are there any relationships between journey purposes and the severity of accidents?
select V.[JourneyPurpose],
COUNT(A.[Severity]) AS 'Total Accident',
CASE 
WHEN COUNT(A.[Severity]) BETWEEN 0 AND 1000 THEN 'LOW'
WHEN COUNT(A.[Severity]) BETWEEN 1000 AND 3000 THEN 'MODERATE'
ELSE 'HIGH'
END AS 'Level'
from [dbo].[accident] AS A
join [dbo].[vehicle] V ON  V.[AccidentIndex] = A.[AccidentIndex]
GROUP BY V.[JourneyPurpose]
ORDER BY 'Total Accident' DESC;

--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
DECLARE @impact varchar(100)
DECLARE @Light varchar(100)
SET @impact='Nearside'
SET @Light='Daylight'
SELECT A.[LightConditions], V.[PointImpact], AVG(V.[AgeVehicle]) AS 'AVERAGE YEAR'
FROM [dbo].[accident] A
JOIN [dbo].[vehicle] V ON V.[AccidentIndex] = A.[AccidentIndex]
GROUP BY A.[LightConditions], V.[PointImpact]
HAVING V.[PointImpact] = @impact AND A.[LightConditions]= @Light;

--Question 9: Calculate the average age of vehicles involved in accidents , considering Day light and Propulsion.
DECLARE @prop varchar(100)
DECLARE @Light varchar(100)
SET @prop='Petrol'
SET @Light='Daylight'
SELECT A.[LightConditions], V.[Propulsion], AVG(V.[AgeVehicle]) AS 'AVERAGE YEAR'
FROM [dbo].[accident] A
JOIN [dbo].[vehicle] V ON V.[AccidentIndex] = A.[AccidentIndex]
GROUP BY A.[LightConditions], V.[Propulsion]
HAVING V.[Propulsion] = @prop AND A.[LightConditions]= @Light;