WITH 
t0 AS (
    SELECT *
    FROM SuperStoreSales_Whole
    WHERE YEAR(Order_Date) = 2018
)
-- SELECT * FROM t0
, t1 AS (
    SELECT Order_ID, Order_Date, Customer_ID, Sales,  FORMAT( Order_Date , 'yyyy-MM-01' ) Order_Month
    FROM t0
    )
-- SELECT * FROM t1
, t2 AS (
    SELECT Customer_ID, FORMAT(MIN(Order_Date), 'yyyy-MM-01' ) Cohort_Month
    FROM t0
    GROUP BY Customer_ID
)
-- SELECT * FROM t2
, t3 AS (
    SELECT t1.*, t2.Cohort_Month, DATEDIFF(month, CAST(t2.Cohort_Month AS date), CAST(t1.Order_Month AS date))+1 AS CohortIndex
    FROM t1
    JOIN t2 ON t1.Customer_ID = t2.Customer_ID
)
-- SELECT * FROM t3
, t4 AS (
    SELECT Cohort_Month, Order_Month, CohortIndex, COUNT(DISTINCT Customer_ID) Count_CustomerID
    FROM t3
    GROUP BY Cohort_Month, Order_Month, CohortIndex 
)
-- SELECT * FROM t4
, t4_2 AS (
    SELECT Cohort_Month, Order_Month, CohortIndex, SUM(sales) Total_Sales
    FROM t3
    GROUP BY Cohort_Month, Order_Month, CohortIndex     
)
-- SELECT * FROM t4_2
, t5 AS (
    SELECT *
    FROM 
    (
        SELECT Cohort_Month, CohortIndex, Count_CustomerID
        FROM t4
    ) p
    PIVOT(
        SUM(Count_CustomerID)
        FOR CohortIndex IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
        ) piv
)
-- SELECT * FROM t5
SELECT Cohort_Month, 
    ROUND(1.0 * [1]/[1], 2) as [1], 
    ROUND(1.0 * [2]/[1], 2) as [2], 
    ROUND(1.0 * [3]/[1], 2) as [3],  
    ROUND(1.0 * [4]/[1], 2) as [4],  
    ROUND(1.0 * [5]/[1], 2) as [5], 
    ROUND(1.0 * [6]/[1], 2) as [6], 
    ROUND(1.0 * [7]/[1], 2) as [7], 
    ROUND(1.0 * [8]/[1], 2) as [8], 
    ROUND(1.0 * [9]/[1], 2) as [9], 
    ROUND(1.0 * [10]/[1], 2) as [10],   
    ROUND(1.0 * [11]/[1], 2) as [11],  
    ROUND(1.0 * [12]/[1], 2) as [12]
FROM t5
