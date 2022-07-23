----------------------------------------------------------------------------------
-- The computer store: an exercise from https://en.wikibooks.org/wiki/SQL_Exercises/The_computer_store
----------------------------------------------------------------------------------

CREATE TABLE dsuser10.Manufecturers (
	Code INT PRIMARY KEY NOT NULL,
	[Name]	VARCHAR(100) NOT NULL
);

DROP TABLE dsuser10.Products
SELECT * FROM dsuser10.Manufecturers

CREATE TABLE dsuser10.Products (
	Code INT PRIMARY KEY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	Price REAL NOT NULL,
	Manufecturer INT NOT NULL
		CONSTRAINT fk_Manufecturers_Code REFERENCES dsuser10.Manufecturers(Code) 
);

SELECT * FROM dsuser10.Products	

INSERT INTO dsuser10.Manufecturers (Code, [Name]) VALUES (1, 'Nike'),
(2, 'Atza'),
(3, 'Agilent'),
(4, 'Biotek'),
(5, 'Sigma'),
(6, 'Naaman'),
(7, 'Bosch'),
(8, 'Viking'),
(9, 'Inkbird'),
(10, 'Grant');

INSERT INTO dsuser10.Products(Code, [Name], Price, Manufecturer) VALUES (11, 'Shoes', 100, 1),
(21, 'PadThai', 15, 2),
(31, 'GCMS', 150000, 3),
(41, 'PlateReader', 40000, 4),
(51, 'Ethanol', 40, 5),
(61, 'Forks', 5, 6),
(71, 'Fridge', 3000, 7),
(81, 'GasBruner', 5000, 8),
(91, 'SueVid', 300, 9),
(101, 'MountainBike', 1000, 10),
(12, 'Gstring', 70, 1),
(13, 'Hat', 30, 1),
(22, 'KurryChicken', 17, 2),
(23, 'StickyRice', 5, 2),
(32, 'UPLC', 120000, 3),
(33, 'SFC', 300000, 3),
(42, 'Microscope', 100000, 4),
(43, 'CellCounter', 1500, 4),
(52, 'DMEM', 20, 5),
(53, 'Trypsin', 50, 5),
(62, 'Knives', 100, 6),
(63, 'Plates', 7, 6),
(72, 'Freezer', 2000, 7),
(73, 'IceMaker', 1000, 7),
(82, 'Stove', 2000, 8),
(83, 'Grill', 1500, 8),
(92, 'Thermometer', 40, 9),
(93, 'Bags', 100, 9),
(102, 'Clippers', 150, 10),
(103, 'Stam', 200, 10);



--1. Select the names of all the products in the store.
SELECT [Name] FROM dsuser10.Products;

--2. Select the names and the prices of all the products in the store.
SELECT [Name], Price FROM dsuser10.Products;

--3. Select the name of the products with a price less than or equal to $200.
SELECT [Name] FROM dsuser10.Products WHERE Price <= 200;

--4. Select all the products with a price between $60 and $120.
/*With AND*/
SELECT * FROM dsuser10.Products
	WHERE Price >= 60 AND Price <= 120;

/*With BETWEEN */
SELECT * FROM dsuser10.Products
	WHERE Price BETWEEN 60 AND 120;

--5. Select the name and price in cents (i.e., the price must be multiplied by 100).
SELECT [Name], Price * 100 AS PriceCents FROM dsuser10.Products

--6. Compute the average price of all the products.
/*With AVG*/
SELECT AVG(Price) AS Price_mean FROM dsuser10.Products;

/*With Aggregations*/
SELECT 
	Code,
	AVG(Price) AS Price_mean
FROM dsuser10.Products
	GROUP BY Code


--7. Compute the average price of all products with manufacturer code equal to 2.
SELECT AVG(Price) FROM dsuser10.Products WHERE Manufecturer = 2;

--8. Compute the number of products with a price larger than or equal to $180.
SELECT COUNT(*) FROM dsuser10.Products WHERE Price >= 180;

--9. Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
SELECT 
	[Name], 
	Price 
FROM dsuser10.Products
	WHERE Price >= 180
	ORDER BY Price DESC, [Name];

--10. Select all the data from the products, including all the data for each product's manufacturer.
/*With INSER INTO*/
INSERT INTO dsuser10.Products --not valid due to different columns
	SELECT *
	FROM dsuser10.Manufecturers

/*With LEFT JOIN*/
SELECT 
	pr.Code AS Pr_Code,
	pr.[Name] AS Pr_Name,
	pr.Price,
	mn.Code AS Mn_Code,
	mn.[Name] AS Mn_Name
FROM dsuser10.Products AS pr
	LEFT JOIN dsuser10.Manufecturers AS mn
	ON pr.Manufecturer = mn.Code

/*w/o LEFT JOIN*/
SELECT * 
FROM 
	dsuser10.Products AS pr, 
	dsuser10.Manufecturers AS mn
WHERE pr.Manufecturer = mn.Code

--11. Select the product name, price, and manufacturer name of all the products.
/* With INNER JOIN*/
SELECT 
	pr.Name AS Pr_Name, 
	pr.Price, 
	mn.Name AS Ma_Name
FROM dsuser10.Products AS pr
	INNER JOIN dsuser10.Manufecturers AS mn
	ON pr.Manufecturer = mn.Code

/*w/o INNER JOIN*/
SELECT 
	pr.[Name] AS Pr_Name, 
	pr.Price, 
	mn.[Name] AS Ma_Name
FROM 
	dsuser10.Products AS pr, 
	dsuser10.Manufecturers AS mn
WHERE pr.Manufecturer = mn.Code

--12. Select the average price of each manufacturer's products, showing only the manufacturer's code.
SELECT
	AVG(Price) AS Price_mean, 
	Manufecturer
FROM dsuser10.Products
GROUP BY Manufecturer

--13. Select the average price of each manufacturer's products, showing the manufacturer's name.
/*w/o JOIN*/
SELECT
	AVG(pr.Price) AS Price_mean,
	mn.[Name]
FROM 
	dsuser10.Products AS pr,
	dsuser10.Manufecturers As mn
WHERE pr.Manufecturer = mn.Code -- WHERE comes after FROM 
GROUP BY mn.[Name] -- GROUP BY comes at the end

/*With JOIN*/
SELECT
	AVG(pr.Price) AS Price_mean,
	mn.[Name]
FROM dsuser10.Products AS pr
	INNER JOIN dsuser10.Manufecturers as mn
	ON pr.Manufecturer = mn.Code
GROUP BY mn.[Name]

--14. Select the names of manufacturer whose products have an average price larger than or equal to $150.
/*With JOIN*/
SELECT
	AVG(pr.Price) AS Price_mean,
	mn.[Name]
FROM dsuser10.Products AS pr
	INNER JOIN dsuser10.Manufecturers as mn
	ON pr.Manufecturer = mn.Code
GROUP BY mn.[Name]
HAVING AVG(pr.Price) >= 150;

/*w/o JOIN*/
SELECT
	AVG(pr.Price) AS Price_mean,
	mn.[Name]
FROM 
	dsuser10.Products AS pr,
	dsuser10.Manufecturers As mn
WHERE pr.Manufecturer = mn.Code
GROUP BY mn.[Name]
HAVING AVG(pr.Price) >= 150;

--15. Select the name and price of the cheapest product.
SELECT TOP 10 [Name], Price
FROM dsuser10.Products
ORDER BY Price ASC
--OR
/*With a nested SELECT*/
SELECT [Name], Price
FROM dsuser10.Products
WHERE Price = (
	SELECT MIN(Price) FROM dsuser10.Products
)

--16. Select the name of each manufacturer along with the name and price of its most expensive product.
/*With nested SELECT and INNER JOIN*/
SELECT
	mn.[Name] AS Mn_Name,
	pr.[Name]AS Pr_Name,
	pr.Price
FROM dsuser10.Products AS pr
	INNER JOIN dsuser10.Manufecturers AS mn
	ON pr.Manufecturer = mn.Code 
		AND pr.Price = 
		(
			SELECT MAX(pr.Price)
			FROM dsuser10.Products AS pr
			WHERE pr.Manufecturer = mn.Code
		);

/*With nested SELECT and w/o INNER JOIN*/
SELECT A.Name, A.Price, F.Name
FROM Products A, Manufacturers F
WHERE A.Manufacturer = F.Code
	AND A.Price =
	(
       SELECT MAX(A.Price)
       FROM Products A
       WHERE A.Manufacturer = F.Code
     );

--17. Select the name of each manufacturer which have an average price above $145 and contain at least 2 different products.
/*With INNER JOIN*/
SELECT 
	mn.[Name] AS Mn_Name,
	AVG(pr.Price) AS Pr_Price,
	COUNT(1) AS Pr_Count 
FROM dsuser10.Products AS pr
	INNER JOIN dsuser10.Manufecturers AS mn
	ON pr.Manufecturer = mn.Code
	GROUP BY mn.[Name]
HAVING AVG(pr.Price) >= 145 AND COUNT(1) > 1;

/*w/o INNER JOIN*/
Select 
	m.[Name], 
	Avg(p.price) as p_price, 
	COUNT(1) as m_count
FROM 
	dsuser10.Manufecturers m, 
	dsuser10.Products p
	WHERE p.Manufecturer = m.code
	GROUP BY m.[Name]
HAVING AVG(p.Price) >= 145 AND COUNT(1) > 1;

--18. Add a new product: Loudspeakers, $70, manufacturer 2.
INSERT INTO dsuser10.Products(Code, [Name], Price, Manufecturer) VALUES (14, 'Loudspeakers', 70, 2)
SELECT * FROM dsuser10.Products

--19. Update the name of product 8 to "Laser Printer".
UPDATE dsuser10.Products SET Code = 24 WHERE [Name] = 'Loudspeakers'

--20. Apply a 10% discount to all products.
SELECT *,
	Price * 0.9 AS '0.9Price'
FROM dsuser10.Products

--21. Apply a 10% discount to all products with a price larger than or equal to $120.
SELECT *,
	Price * 0.9 AS '0.9_Price'
FROM dsuser10.Products
WHERE Price > 120
ORDER BY Price DESC