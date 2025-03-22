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

--Updating City Names 
UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET City = 'Kansas City'
WHERE City IN ('KC', 'KCMO', 'KCK');

---Finding Zipcodes under City. 
SELECT City, Address, COUNT(*) AS ZipCodeCount
FROM [dbo].[KCPD_Crime_Data_2020_2025]
WHERE (LEN(City) = 4 OR LEN(City) = 5) AND City NOT LIKE '%[^0-9]%'  -- Ensures it's numeric
GROUP BY City, Address
ORDER BY ZipCodeCount DESC;

---Update Zipcodes to true City names. 
UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET City = CASE 
    WHEN City = '1604' THEN 'Kansas City'  -- Example for zip code 1604
    WHEN City = '64123' THEN 'Kansas City'  -- Example for zip code 64123
    WHEN City = '64108' THEN 'Kansas City'  -- Example for zip code 64108
    WHEN City = '64130' THEN 'Kansas City'  -- Example for zip code 64130
    WHEN City = '64106' THEN 'Kansas City'  -- Example for zip code 64106
    WHEN City = '64105' THEN 'Kansas City'  -- Example for zip code 64105
    WHEN City = '64111' THEN 'Kansas City'  -- Example for zip code 64111
    WHEN City = '64129' THEN 'Kansas City'  -- Example for zip code 64129
    WHEN City = '64132' THEN 'Kansas City'  -- Example for zip code 64132
    WHEN City = '64155' THEN 'Kansas City'  -- Example for zip code 64155
    ELSE City  -- Keep the current value if it's not a zip code
END
WHERE City IN ('1604', '64123', '64108', '64130', '64106', '64105', '64111', '64129', '64132', '64155');

---Cleaning up City names
SELECT DISTINCT City
FROM [dbo].[KCPD_Crime_Data_2020_2025]
WHERE City LIKE '%kansas%' OR City LIKE '%city%' OR City LIKE '%KANSAS%'
ORDER BY City;

UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET City = CASE 
              WHEN City LIKE '%N KANSAS CITY%' THEN 'NORTH KANSAS CITY'
              WHEN City LIKE '%K%' AND City LIKE '%C%' AND City NOT LIKE '%JEFFERSON CITY%' AND City NOT LIKE '%PLATTE CITY%' THEN 'KANSAS CITY'
              WHEN City LIKE '%Kanas%' AND City NOT LIKE '%JEFFERSON CITY%' AND City NOT LIKE '%PLATTE CITY%' THEN 'Kansas City'  -- Handles "Kanas"
              ELSE City
           END
WHERE City LIKE '%K%' AND City LIKE '%C%' 
   OR City LIKE '%N KANSAS CITY%' 
   OR City LIKE '%PLATTE%' 
   OR City LIKE '%JEFFERSON%' 
   OR City LIKE '%Kanas%';  

--- Finding more cities that are misspelled
   SELECT DISTINCT City
FROM [dbo].[KCPD_Crime_Data_2020_2025]
WHERE LEN(City) BETWEEN 3 AND 5;

---Cleaning up Blue Springs
UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET City = CASE 
              WHEN City LIKE '%BLUES SPRINGS%' THEN 'BLUE SPRINGS'
              WHEN City LIKE '%BLUESPRINGS%' THEN 'BLUE SPRINGS'
              WHEN City LIKE '%BLUR SPRINGS%' THEN 'BLUE SPRINGS'
              ELSE City
           END
WHERE City LIKE '%BLUES SPRINGS%' 
   OR City LIKE '%BLUESPRINGS%' 
   OR City LIKE '%BLUR SPRINGS%';

   ---Cleaning up Independence
   UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET City = 'INDEPENDENCE'
WHERE City IN ('INDEP', 'INDEPENDEANCE', 'INDEPEDENCE');


---Some other corrections 
UPDATE [dbo].[KCPD_Crime_Data_2020_2025]
SET City = CASE 
    WHEN City IN ('LEE SUMMIT', 'LEES SUMMIT', 'LEESSUMIT') THEN 'LEE''S SUMMIT'
    WHEN City IN ('UNK') THEN 'UNKNOWN'
    WHEN City IN ('SAINT JOSEPH', 'ST JOSEPH') THEN 'ST. JOSEPH'
    WHEN City IN ('ST LOUIS') THEN 'ST. LOUIS'
	WHEN City IN ('PLATTE CO', 'PLATTE CTY') THEN 'PLATTE CITY'
	WHEN City IN ('PLATTESBURG') THEN 'PLATTSBURG'
	WHEN City IN ('GLASTONE') THEN 'GLADSTONE'
	WHEN City IN ('GRAVOIS MILL') THEN 'GRAVOIS MILLS'
    ELSE City
END
WHERE City IN ('LEE SUMMIT', 'LEES SUMMIT', 'LEESSUMIT', 'UNK', 'SAINT JOSEPH', 'ST JOSEPH', 'ST LOUIS','PLATTE CO', 'PLATTE CTY', 'PLATTESBURG', 'GLASTONE','GRAVOIS MILL');
