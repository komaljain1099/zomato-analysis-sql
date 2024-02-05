create database zomato_analysis;
use zomato_analysis;

select * from zomatasql;

ALTER TABLE zomatasql ADD COLUMN Datekey_Opening DATE NOT NULL DEFAULT '2022-01-01';

Alter table zomatasql add column Datekey_Opening date not null; 
UPDATE zomatasql
SET Datekey_Opening = CAST(CONCAT(`Year Opening`, '-', `Month Opening`, '-', `Day Opening`) AS DATE);

select*from zomatasql;
#######################################################################################

# KPI-1 
CREATE TABLE Countries(
CountryCode int, CountryName varchar(30) ) ;

insert into Countries 
values (1, 'India'),
(14, 'Australia'),
(30, 'Brazil'),
(37, 'Canada'),
(94, 'Indonesia'),
(148, 'New Zealand'),
(162, 'Philippines'),
(166, 'Qatar'),
(184, 'South-east Asia'),
(189, 'South Africa'),
(191, 'Srilanka'),
(208, 'Turkey'),
(214, 'UAE'),
(215, 'United Kingdom'),
(216, 'United States');

select * from Countries;
######################################################################################

# KPI-2 Calendar Table
SELECT CONCAT(`Day Opening`, '-', `Month Opening`, '-', `Year Opening`) AS Datekey_Opening
FROM zomatasql;

select date(Datekey_Opening) AS DATES, 
year(Datekey_Opening) AS YEARS, 
month(Datekey_Opening) AS MONTHNO, 
monthname(Datekey_Opening) AS MONTHNAME, 
CONCAT("Q",quarter(Datekey_Opening)) AS QUARTERS, 
DATE_FORMAT(Datekey_Opening, '%Y-%b') as "YYYY-MMM",
dayofweek(Datekey_Opening) AS WEEKDAYNO, 
date_format(Datekey_Opening, "%W" ) AS WEEKDAY,

CASE 
when month(Datekey_Opening) = 4 then "FM1"
when month(Datekey_Opening) = 5 then "FM2"
when month(Datekey_Opening) = 6 then "FM3"
when month(Datekey_Opening) = 7 then "FM4"
when month(Datekey_Opening) = 8 then "FM5"
when month(Datekey_Opening) = 9 then "FM6"
when month(Datekey_Opening) = 10 then "FM7"
when month(Datekey_Opening) = 11 then "FM8"
when month(Datekey_Opening) = 12 then "FM9"
when month(Datekey_Opening) = 1 then "FM10"
when month(Datekey_Opening) = 2 then "FM11"
else "FM12"
END as Financial_Month, 

CASE 
when month(Datekey_Opening) between 1 and 3 then "FQ4"
when month(Datekey_Opening) between 4 and 6 then "FQ1"
when month(Datekey_Opening) between 7 and 9 then "FQ2"
else "FQ3"
END AS Financial_Quarter
from zomatasql;
 
############################################################################################

# KPI- 3 Find the Numbers of Resturants based on City and Country.

Select count(RestaurantID) as Restaurants, City, CountryName from zomatasql
join countries on  countries.CountryCode = zomatasql.CountryCode 
group by RestaurantID ;

SELECT
    COUNT(RestaurantID) AS Restaurants,
    City,
    CountryName
FROM
    zomatasql
JOIN
    countries ON countries.CountryCode = zomatasql.CountryCode
GROUP BY
    City, Countryname;

SELECT City,CountryName,COUNT(*) AS restaurant_count
FROM zomatasql
join countries on countries.CountryCode=zomatasql.CountryCode 
GROUP BY
    City, CountryName;
############################################################################################

# KPI-4 Numbers of Resturants opening based on Year , Quarter , Month

SELECT YEAR(Datekey_Opening) AS Year, COUNT(*) AS Yearwise_Restaurants_Opening
FROM zomatasql
GROUP BY YEAR(Datekey_Opening);

SELECT YEAR(Datekey_Opening) AS Year, QUARTER(Datekey_Opening) AS Quarter, COUNT(*) AS Quaterwise_Restaurants_Opening
FROM zomatasql
GROUP BY YEAR(Datekey_Opening), QUARTER(Datekey_Opening);

SELECT YEAR(Datekey_Opening) AS Year, MONTHNAME(Datekey_Opening) AS Month, COUNT(*) AS Monthwise_Restaurants_Opening
FROM zomatasql
GROUP BY YEAR(Datekey_Opening), MONTHNAME(Datekey_Opening);

SELECT YEAR(Datekey_Opening) AS Year, QUARTER(Datekey_Opening) AS Quarter, MONTHNAME(Datekey_Opening) AS Month, COUNT(*) AS Restaurants_Opening
FROM zomatasql
GROUP BY YEAR(Datekey_Opening), QUARTER(Datekey_Opening), MONTHNAME(Datekey_Opening);
######################################################################################################

# KPI-5 Count of Restaurants based on Average Ratings

SELECT AVG(Rating), COUNT(*) AS Num_Restaurants
FROM zomatasql
GROUP BY Rating;

Select count(RestaurantID),avg(Rating) from zomatasql;
##############################################################################################

# Currency Table
select Currency,  Average_Cost_for_two,
Case 
when Currency = "Indian Rupees(Rs.)" then concat(Average_Cost_for_two * 0.01 , " $")  
when Currency = "Dollar($)" then concat(Average_Cost_for_two * 1.08 , " $")
when Currency = "Pounds(Œ£)" then concat(Average_Cost_for_two * 1.23 , " $")
when Currency = "NewZealand($)" then concat(Average_Cost_for_two * 0.63 , " $")
when Currency = "Emirati Diram(AED)" then concat(Average_Cost_for_two * 0.27 , " $")
when Currency = "Brazilian Real(R$)" then concat(Average_Cost_for_two * 0.19 , " $")
when Currency = "Turkish Lira(TL)" then concat(Average_Cost_for_two * 0.05 , " $")
when Currency = "Qatari Rial(QR)" then concat(Average_Cost_for_two * 0.27 , " $")
when Currency = "Rand(R)" then concat(Average_Cost_for_two * 0.06 , " $")
when Currency = "Sri Lankan Rupee(LKR)" then concat(Average_Cost_for_two * 0.003 , " $")
when Currency = "Indonesian Rupiah(IDR)" then concat(Average_Cost_for_two * 0.00007 , " $")
when Currency = "Botswana Pula(P)" then concat(Average_Cost_for_two * 0.08 , " $")
END as USD  
from zomatasql ;
 
# KPI- 6 Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

select COUNT(RestaurantID),
Case 
when Currency = "Indian Rupees(Rs.)" then 
     Case 
when (Average_Cost_for_two * 0.01) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.01) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.01) between 251 AND 550 then "251 to 550" 
else "551 Above" 
 End  
when Currency = "Dollar($)" then 
	Case 
when (Average_Cost_for_two * 1.08) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 1.08) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 1.08) between 251 AND 550 then "251 to 550"  
else "551 Above"  
    end
when Currency = "Pounds(Œ£)" then 
Case
when (Average_Cost_for_two * 1.23) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 1.23) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 1.23) between 251 AND 550 then "251 to 550" 
else "551 Above"  
    end  
when Currency = "NewZealand($)" then 
Case
when (Average_Cost_for_two * 0.63) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.63) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.63) between 251 AND 550 then "251 to 550"  
else "551 Above" 
    end  
when Currency = "Emirati Diram(AED)" then 
Case
when (Average_Cost_for_two * 0.27) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.27) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.27) between 251 AND 550 then "251 to 550"  
else "551 Above" 
    end 
when Currency = "Brazilian Real(R$)" then 
Case
when (Average_Cost_for_two * 0.19) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.19) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.19) between 251 AND 550 then "251 to 550"  
else "551 Above" 
    end 
when Currency = "Turkish Lira(TL)" then 
Case
when (Average_Cost_for_two * 0.05) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.05) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.05) between 251 AND 550 then "251 to 550" 
else "551 Above" 
    end 
when Currency = "Qatari Rial(QR)" then 
Case
when (Average_Cost_for_two * 0.27) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.27) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.27) between 251 AND 550 then "251 to 550" 
else "551 Above"  
    end 
when Currency = "Rand(R)" then
Case
when (Average_Cost_for_two * 0.06) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.06) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.06) between 251 AND 550 then "251 to 550" 
else "551 Above"  
    end  
when Currency = "Sri Lankan Rupee(LKR)" then
Case
when (Average_Cost_for_two * 0.003) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.003) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.003) between 251 AND 550 then "251 to 550" 
else "551 Above" 
    end 
when Currency = "Indonesian Rupiah(IDR)" then
Case
when (Average_Cost_for_two * 0.00007) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.00007) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.00007) between 251 AND 550 then "251 to 550"  
else "551 Above" 
    end 
when Currency = "Botswana Pula(P)" then
Case
when (Average_Cost_for_two * 0.08) between 0 AND 150 then "0 to 150"
when (Average_Cost_for_two * 0.08) between 151 AND 250 then "151 to 250"
when (Average_Cost_for_two * 0.08) between 251 AND 550 then "251 to 550"  
else "551 Above" 
    end 
END as Bucket  
from zomatasql
group by Bucket;
###############################################################################################

# KPI-7 Percentage of Resturants based on "Has_Table_booking"
SELECT 
    CONCAT(COUNT(CASE
                WHEN Has_Table_Booking = 'Yes' THEN 1
                ELSE NULL
            END) * 100 / COUNT(*),
            '%') AS Percentage_With_Table_Booking
FROM
    zomatasql;
#################################################################################################

# KPI-8 Percentage of Resturants based on "Has_Online_delivery"
SELECT 
    CONCAT(COUNT(CASE
                WHEN Has_Online_delivery = 'Yes' THEN 1
                ELSE NULL
            END) * 100 / COUNT(*),
            '%') AS Percentage_With_Online_delivery
FROM
    zomatasql;
#############################################################################################

