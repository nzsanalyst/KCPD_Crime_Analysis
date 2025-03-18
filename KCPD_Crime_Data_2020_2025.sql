-- Creating a new table for all combined data from 2020 to 2025.

CREATE TABLE KCPD_Crime_Data_2020_2025 (
    Report_No nvarchar(50),
    Reported_Date date,
    Reported_Time time(7),
    From_Date date,
    From_Time time(7),
    To_Date date,
    Offense nvarchar(255),
    IBRS nvarchar(50),
    Description nvarchar(255),
    Beat nvarchar(50),
    Address nvarchar(255),
    City nvarchar(100),
    Zip_Code nvarchar(50),
    Rep_Dist nvarchar(50),
    Area nvarchar(50),
    DVFlag bit,
    Involvement nvarchar(50),
    Race char(1),
    Sex char(1),
    Age tinyint,
    Fire_Arm_Used_Flag bit,
    Location nvarchar(MAX),
    Age_Range nvarchar(50)
);

--Union and insert all 5 years of data into [dbo].[KCPD_Crime_Data_2020_2025]

INSERT INTO KCPD_Crime_Data_2020_2025
(
    Report_No, Reported_Date, Reported_Time, From_Date, From_Time, 
    To_Date, Offense, IBRS, Description, Beat, Address, City, 
    Zip_Code, Rep_Dist, Area, DVFlag, Involvement, Race, Sex, Age, 
    Fire_Arm_Used_Flag, Location, Age_Range
)
SELECT 
    Report_No, Reported_Date, Reported_Time, From_Date, From_Time, 
    To_Date, Offense, IBRS, Description, Beat, Address, City, 
    Zip_Code, Rep_Dist, Area, DVFlag, Involvement, Race, Sex, Age, 
    Fire_Arm_Used_Flag, Location, Age_Range
FROM [dbo].[KCPD_Crime_Data_2020]

UNION ALL

SELECT 
    Report_No, Reported_Date, Reported_Time, From_Date, From_Time, 
    To_Date, Offense, IBRS, Description, Beat, Address, City, 
    Zip_Code, Rep_Dist, Area, DVFlag, Involvement, Race, Sex, Age, 
    Fire_Arm_Used_Flag, Location, Age_Range
FROM [dbo].[KCPD_Crime_Data_2021]

UNION ALL

SELECT 
    Report_No, Reported_Date, Reported_Time, From_Date, From_Time, 
    To_Date, Offense, IBRS, Description, Beat, Address, City, 
    Zip_Code, Rep_Dist, Area, DVFlag, Involvement, Race, Sex, Age, 
    Fire_Arm_Used_Flag, Location, Age_Range
FROM [dbo].[KCPD_Crime_Data_2022]

UNION ALL

SELECT 
    Report_No, Reported_Date, Reported_Time, From_Date, From_Time, 
    To_Date, Offense, IBRS, Description, Beat, Address, City, 
    Zip_Code, Rep_Dist, Area, DVFlag, Involvement, Race, Sex, Age, 
    Fire_Arm_Used_Flag, Location, Age_Range
FROM [dbo].[KCPD_Crime_Data_2023]

UNION ALL

SELECT 
    Report_No, Reported_Date, Reported_Time, From_Date, From_Time, 
    To_Date, Offense, IBRS, Description, Beat, Address, City, 
    Zip_Code, Rep_Dist, Area, DVFlag, Involvement, Race, Sex, Age, 
    Fire_Arm_Used_Flag, Location, Age_Range
FROM [dbo].[KCPD_Crime_Data_2024]

UNION ALL

SELECT 
    Report_No, Reported_Date, Reported_Time, From_Date, From_Time, 
    To_Date, Offense, IBRS, Description, Beat, Address, City, 
    Zip_Code, Rep_Dist, Area, DVFlag, Involvement, Race, Sex, Age, 
    Fire_Arm_Used_Flag, Location, Age_Range
FROM [dbo].[KCPD_Crime_Data_2025];

--Check if data has been inserted correctly, switch (2020-2025).
SELECT top 1000*
FROM [dbo].[KCPD_Crime_Data_2020_2025]
WHERE YEAR(Reported_Date) = 2025;

--Remove exact duplicates. 
WITH Ranked_Report_No AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Report_No ORDER BY Reported_Date DESC) AS row_num
    FROM [dbo].[KCPD_Crime_Data_2020_2025]
)
SELECT Report_No, 
       Reported_Date, 
       Reported_Time, 
       From_Date, 
       From_Time, 
       To_Date, 
       Offense, 
       IBRS, 
       Description, 
       Beat, 
       Address, 
       City, 
       Zip_Code, 
       Rep_Dist, 
       Area, 
       DVFlag, 
       Involvement, 
       Race, 
       Sex, 
       Age, 
       Fire_Arm_Used_Flag, 
       Location, 
       Age_Range
FROM Ranked_Report_No
WHERE row_num = 1;

--Checking for Duplicates
SELECT Report_No, COUNT(*) AS DuplicateCount
FROM [dbo].[KCPD_Crime_Data_2020_2025]
GROUP BY Report_No
HAVING COUNT(*) > 1;

--Standardize all columns 
UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET Report_No = UPPER(Report_No),
    Offense = UPPER(Offense),
    IBRS = UPPER(IBRS),
    Description = UPPER(Description),
    Address = UPPER(Address),
    City = UPPER(City),
    Zip_Code = UPPER(Zip_Code),
    Rep_Dist = UPPER(Rep_Dist),
    Area = UPPER(Area),
    Involvement = UPPER(Involvement),
    Location = UPPER(Location),
    Age_Range = UPPER(Age_Range);


--Checking for standardization
SELECT TOP 10 *
FROM [dbo].[KCPD_Crime_Data_2020_2025];

--Trimming leading and trailing spaces
UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET Report_No = TRIM(Report_No),
    Offense = TRIM(Offense),
    IBRS = TRIM(IBRS),
    Description = TRIM(Description),
    Address = TRIM(Address),
    City = TRIM(City),
    Zip_Code = TRIM(Zip_Code),
    Rep_Dist = TRIM(Rep_Dist),
    Area = TRIM(Area),
    Involvement = TRIM(Involvement),
    Location = TRIM(Location),
    Age_Range = TRIM(Age_Range);

--Save CSV
SELECT * FROM [dbo].[KCPD_Crime_Data_2020_2025];
