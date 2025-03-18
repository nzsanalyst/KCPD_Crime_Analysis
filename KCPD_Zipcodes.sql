SELECT *
FROM [dbo].[all_us_zipcodes];

-- Deleting all States other than Kansas and Missouri.
DELETE FROM [dbo].[all_us_zipcodes]
WHERE state NOT IN ('KS', 'MO');

--Save CSV
SELECT * FROM [dbo].[all_us_zipcodes];