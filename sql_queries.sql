-- App_Name
-- SELECT MAX(LEN(App_Name)) FROM googleplaystore

--SELECT App_Name FROM googleplaystore
--WHERE App_Name IS NULL OR App_Name = ''

ALTER TABLE googleplaystore
ALTER COLUMN App_Name varchar(50) NOT NULL

-- App_Id
--SELECT MAX(LEN(App_Id)) FROM googleplaystore

--SELECT App_Id FROM googleplaystore
--WHERE App_Id IS NULL OR App_Id = ''

ALTER TABLE googleplaystore
ALTER COLUMN App_Id varchar(150) NOT NULL

-- Category
--SELECT MAX(LEN(Category)) FROM googleplaystore

--SELECT Category FROM googleplaystore
--WHERE Category IS NULL OR Category = ''

ALTER TABLE googleplaystore
ALTER COLUMN Category varchar(30)

-- Rating
--SELECT Rating FROM googleplaystore

--SELECT Rating FROM googleplaystore
--WHERE Rating IS NULL

ALTER TABLE googleplaystore
ALTER COLUMN Rating float

UPDATE googleplaystore
SET Rating = 
CASE WHEN Rating IS NULL THEN 0
ELSE Rating
END


-- Rating_Count
-- SELECT MAX(Rating_Count) FROM googleplaystore

-- SELECT Rating_Count FROM googleplaystore
-- WHERE Rating_Count IS NULL OR Rating_Count = ''

ALTER TABLE googleplaystore
ALTER COLUMN Rating_Count int

UPDATE googleplaystore
SET Rating_Count =
CASE WHEN Rating_Count IS NULL THEN 0
ELSE Rating_Count
END

-- Installs
--SELECT MAX(Installs) FROM googleplaystore

--SELECT Installs FROM googleplaystore
--WHERE Installs IS NULL OR Installs = ''

UPDATE googleplaystore
SET Installs = REPLACE(Installs, '+','')

UPDATE googleplaystore
SET Installs = REPLACE(Installs, ',','')

ALTER TABLE googleplaystore
ALTER COLUMN Installs bigint

UPDATE googleplaystore
SET Installs =
CASE WHEN Installs IS NULL THEN 0
ELSE Installs
END

-- Minimum_Installs
-- SELECT Minimum_Installs FROM googleplaystore
-- ORDER BY Minimum_Installs DESC

ALTER TABLE googleplaystore
ALTER COLUMN Minimum_Installs bigint

UPDATE googleplaystore
SET Minimum_Installs =
CASE WHEN Minimum_Installs IS NULL THEN 0
ELSE Minimum_Installs
END

-- Maximum_Installs
-- SELECT MAX(Maximum_Installs) FROM googleplaystore

ALTER TABLE googleplaystore
ALTER COLUMN Maximum_Installs bigint

UPDATE googleplaystore
SET Maximum_Installs =
CASE WHEN Maximum_Installs IS NULL THEN 0
ELSE Maximum_Installs
END

-- Free
-- SELECT Free FROM googleplaystore

ALTER TABLE googleplaystore
ALTER COLUMN Free bit

-- SELECT Free FROM googleplaystore
--WHERE Free IS NULL OR Free = ''

-- Price
--SELECT Price FROM googleplaystore
--ORDER BY Price DESC

ALTER TABLE googleplaystore
ALTER COLUMN Price float

-- Currency
-- SELECT DISTINCT Currency FROM googleplaystore

UPDATE googleplaystore
SET Currency =
CASE WHEN Currency IS NULL OR Currency = 'XXX' THEN 'Unknown'
ELSE Currency
END 

ALTER TABLE googleplaystore
ALTER COLUMN Currency VARCHAR(10)



-- Size
--SELECT Size FROM googleplaystore
UPDATE googleplaystore SET Size = replace(Size,'Varies with device',0)

ALTER TABLE googleplaystore
ADD new_size float

UPDATE googleplaystore
SET Size = REPLACE(Size, ',','')


Update googleplaystore
    SET  new_size = 
	CASE WHEN RIGHT(Size,1) = 'k' THEN CAST(SUBSTRING(Size,1,LEN(Size)-1) as float)/ cast(1024 as float)
	WHEN RIGHT(Size,1) = 'M' THEN SUBSTRING(Size,1,LEN(Size)-1)
    ELSE 0
    END;

ALTER TABLE googleplaystore
DROP COLUMN Size -- old column

ALTER TABLE googleplaystore
ALTER COLUMN new_size decimal(6,2)

EXEC sp_rename 'googleplaystore.new_size','Size','COLUMN'

-- Minimum_Android
SELECT Minimum_Android FROM googleplaystore

ALTER TABLE googleplaystore
ADD new_min_android varchar(100)

UPDATE googleplaystore
SET Minimum_Android = REPLACE(Minimum_Android, ' and up', '')

UPDATE googleplaystore
SET Minimum_Android = REPLACE(Minimum_Android, 'Varies with device', 0)

UPDATE googleplaystore
SET Minimum_Android = REPLACE(Minimum_Android, 'W', '')

ALTER TABLE googleplaystore
ALTER COLUMN Minimum_Android varchar(20)

-- Developer_Id
SELECT Developer_Id FROM googleplaystore

ALTER TABLE googleplaystore
ALTER COLUMN Developer_Id varchar(50)

-- Content_rating
SELECT Content_rating FROM googleplaystore
WHERE Content_Rating IS NULL OR Content_Rating = ''

ALTER TABLE googleplaystore
ALTER COLUMN Content_rating varchar(20)

-- Ad_supported
SELECT Ad_supported FROM googleplaystore
WHERE Ad_supported IS NULL OR Ad_supported = ''

ALTER TABLE googleplaystore
ALTER COLUMN Ad_supported bit

-- In_app_purchases
SELECT In_app_purchases FROM googleplaystore
WHERE In_app_purchases IS NULL OR In_app_purchases = ''

ALTER TABLE googleplaystore
ALTER COLUMN In_app_purchases bit

-- Editors_Choice
SELECT DISTINCT Editors_Choice FROM googleplaystore
WHERE Editors_Choice IS NULL OR Editors_Choice = ''

ALTER TABLE googleplaystore
ALTER COLUMN Editors_Choice bit


-- Developer_Website, Developer_Email, Privacy_Policy, Scraped_Time
ALTER TABLE googleplaystore 
DROP COLUMN Developer_Website, Developer_Email, Privacy_Policy, Scraped_Time

SELECT * FROM googleplaystore

-- Remove duplicates

WITH DuplicateApp
AS (SELECT App_Id,
RowNumber = ROW_NUMBER() OVER (PARTITION BY App_Id ORDER BY App_Id)
FROM googleplaystore
)
DELETE FROM DuplicateApp
WHERE RowNumber > 1