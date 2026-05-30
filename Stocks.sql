CREATE DATABASE STOCK_MARKET_DB;

USE STOCK_MARKET_DB;

SELECT COUNT(*) FROM STOCK_DATA;

SELECT *
FROM STOCK_DATA
LIMIT 5;

SHOW TABLES;

DESC stock_data;

### Average Closing Price
SELECT AVG(Close_Price) AS AVG_CLOSE_PRICE
FROM STOCK_DATA;
     

### Maximum & Minimum Return
SELECT MIN(Daily_Return_Pct) AS MIN_RETURNS,
	   MAX(Daily_Return_Pct) AS MAX_RETURNS
FROM STOCK_DATA;


### Highest Volatility Day
SELECT *
FROM STOCK_DATA
ORDER BY Volatility_Range DESC
LIMIT 1;


### Average VIX_Close
SELECT AVG(VIX_Close) AS AVG_VIX
FROM STOCK_DATA;


----------------GROUPING ANALYSIS---------------------


### Monthly Average Returns
SELECT 
	  DATE_FORMAT(DATE, '%Y-%M') AS MONTH,
      AVG(Daily_Return_Pct) AS AVG_MONTHLY_RETURN
FROM STOCK_DATA
GROUP BY MONTH
ORDER BY MONTH;


### Quarterly Average Volatility
SELECT 
    CONCAT(YEAR(Date), '-Q', QUARTER(Date)) AS quarter,
    AVG(Volatility_Range) AS avg_quarterly_volatility
FROM stock_data
GROUP BY quarter
ORDER BY quarter;


### Average Sentiment Score by Year
SELECT 
    YEAR(Date) AS year,
    AVG(Sentiment_Score) AS avg_sentiment
FROM stock_data
GROUP BY year
ORDER BY year;


### Average Return during Economic News Events
SELECT 
    Economic_News_Flag,
    AVG(Daily_Return_Pct) AS avg_return
FROM stock_data
GROUP BY Economic_News_Flag;


------------------Relationship Queries-------------------


### Top 10 Highest Volatility Days
SELECT *
FROM stock_data
ORDER BY Volatility_Range DESC
LIMIT 10;


### Months with Highest Average Returns
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    AVG(Daily_Return_Pct) AS avg_return
FROM stock_data
GROUP BY month
ORDER BY avg_return DESC
LIMIT 10;


### Compare Returns during High vs Low VIX
SELECT 
    CASE 
        WHEN VIX_Close >= 20 THEN 'High VIX'
        ELSE 'Low VIX'
    END AS vix_category,
    AVG(Daily_Return_Pct) AS avg_return
FROM stock_data
GROUP BY vix_category;


### Rank Top Months by Returns
SELECT 
    month,
    avg_return,
    RANK() OVER (ORDER BY avg_return DESC) AS rank_position
FROM (
    SELECT 
        DATE_FORMAT(Date, '%Y-%m') AS month,
        AVG(Daily_Return_Pct) AS avg_return
    FROM stock_data
    GROUP BY month
) t;


### Moving Average of Closing Prices
SELECT 
    Date,
    Close_Price,
    AVG(Close_Price) OVER (
        ORDER BY Date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7d
FROM stock_data;


### Running Total of Volume
SELECT 
    Date,
    Volume,
    SUM(Volume) OVER (ORDER BY Date) AS running_volume
FROM stock_data;


### Window Functions(Ranking Returns Daily)
SELECT 
    Date,
    Daily_Return_Pct,
    RANK() OVER (ORDER BY Daily_Return_Pct DESC) AS return_rank
FROM stock_data;


