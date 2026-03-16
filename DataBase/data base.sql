CREATE DATABASE My_Shop_DB;
USE My_Shop_DB;
CREATE TABLE Shopping_List (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL
);
INSERT INTO Shopping_List (Product_Name, Price, Quantity) VALUES
('Milk', 35.50, 2),
('Cola', 57.50, 2),
('Bread', 25.00, 1),
('Eggs', 60.00, 1),
('Cheese', 120.75, 1),
('Apples', 40.00, 3),
('Bananas', 30.20, 4),
('Chicken', 150.00, 2),
('Rice', 55.90, 1),
('Tomatoes', 45.30, 2),
('Coffee', 180.00, 1);
SELECT * FROM Shopping_List;
CREATE TABLE Fridge (
    Item_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_ID INT,
    Product_Name VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    Expiration_Date DATE,
    FOREIGN KEY (Product_ID) REFERENCES Shopping_List(ID)
);
INSERT INTO Fridge (Product_ID, Product_Name, Quantity, Expiration_Date) VALUES
(1, 'Milk', 1, '2026-03-01'),
(2, 'Bread', 1, '2026-02-27'),
(3, 'Eggs', 10, '2026-03-10'),
(4, 'Cheese', 1, '2026-03-20'),
(5, 'Apples', 5, '2026-03-05'),

(NULL, 'Butter', 1, '2026-04-01'),
(NULL, 'Yogurt', 3, '2026-03-02'),
(NULL, 'Juice', 2, '2026-06-15'),
(NULL, 'Sausage', 1, '2026-03-08'),
(NULL, 'Lettuce', 1, '2026-02-28');
SELECT 
    F.Item_ID,
    F.Product_Name,
    S.Price,
    F.Quantity,
    F.Expiration_Date
FROM Fridge F
LEFT JOIN Shopping_List S 
ON F.Product_ID = S.ID;
INSERT INTO Fridge (Product_ID, Product_Name, Quantity, Expiration_Date) VALUES
(6, 'Bananas', 6, '2026-03-12'),
(7, 'Chicken', 1, '2026-03-03'),
(8, 'Rice', 2, '2026-07-01'),
(9, 'Tomatoes', 4, '2026-02-26'),
(10, 'Coffee', 1, '2026-12-31'),
(NULL, 'Ice Cream', 2, '2026-05-01'),
(NULL, 'Fish', 1, '2026-03-04'),
(NULL, 'Cucumber', 3, '2026-02-28'),
(NULL, 'Chocolate', 5, '2026-08-15'),
(NULL, 'Water', 6, '2027-01-01');
SELECT *
FROM Fridge F
WHERE NOT EXISTS (
    SELECT 1
    FROM Shopping_List S
    WHERE S.ID = F.Product_ID
);
SELECT *
FROM Shopping_List
WHERE Price = (SELECT MIN(Price) FROM Shopping_List);
SELECT *
FROM Shopping_List
WHERE Price = (SELECT MAX(Price) FROM Shopping_List);
SELECT ROUND(AVG(Price), 2) AS Average_Price
FROM Shopping_List;
SELECT COUNT(*) AS Fridge_Product_Count
FROM Fridge;
SELECT COUNT(*) AS Shopping_List_Product_Count
FROM Shopping_List;
SELECT SUM(Quantity) AS Total_Products_In_Fridge
FROM Fridge;
SELECT 
    Expiration_Date,
    SUM(Quantity) AS Total_Products_On_Date
FROM Fridge
GROUP BY Expiration_Date
ORDER BY Expiration_Date;
SELECT 
    Expiration_Date,
    Product_Name,
    SUM(Quantity) AS Total_Quantity
FROM Fridge
GROUP BY Expiration_Date, Product_Name
ORDER BY Expiration_Date;
SELECT *
FROM Shopping_List
WHERE Product_Name LIKE 'A%';
ALTER TABLE Fridge
ADD CONSTRAINT fk_product
FOREIGN KEY (Product_ID)
REFERENCES Shopping_List(ID);
INSERT INTO Fridge (Product_ID, Product_Name, Quantity, Expiration_Date) VALUES
(1, 'Milk', 2, '2026-03-05'),
(2, 'Bread', 1, '2026-02-28'),
(3, 'Eggs', 12, '2026-03-12'),
(4, 'Cheese', 1, '2026-03-25'),
(5, 'Apples', 6, '2026-03-07'),

(NULL, 'Ice Cream', 2, '2026-05-01'),
(NULL, 'Fish', 1, '2026-03-04'),
(NULL, 'Cucumber', 3, '2026-02-28'),
(NULL, 'Chocolate', 4, '2026-09-01'),
(NULL, 'Water', 5, '2027-01-01');
SELECT 
    S.ID,
    S.Product_Name,
    S.Price,
    F.Quantity,
    F.Expiration_Date
FROM Shopping_List S
INNER JOIN Fridge F
ON S.ID = F.Product_ID;
SELECT 
    S.ID,
    S.Product_Name,
    S.Price,
    S.Quantity
FROM Shopping_List S
LEFT JOIN Fridge F
ON S.ID = F.Product_ID
WHERE F.Product_ID IS NULL;
CREATE TABLE `Order` (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_ID INT,
    Item_ID INT,
    Date DATE,
    Quantity INT,
    FOREIGN KEY (Product_ID) REFERENCES Shopping_List(ID),
    FOREIGN KEY (Item_ID) REFERENCES Fridge(Item_ID)
);
INSERT INTO `Order` (Product_ID, Item_ID, Date, Quantity)
SELECT 
    S.ID,
    NULL,
    CURDATE(),
    S.Quantity
FROM Shopping_List S
LEFT JOIN Fridge F
ON S.ID = F.Product_ID
WHERE F.Product_ID IS NULL;
INSERT INTO `Order` (Product_ID, Item_ID, Date, Quantity)
SELECT 
    S.ID,
    F.Item_ID,
    CURDATE(),
    F.Quantity
FROM Shopping_List S
INNER JOIN Fridge F
ON S.ID = F.Product_ID;
SELECT 
    O.Order_ID,
    S.Product_Name,
    F.Expiration_Date,
    O.Quantity
FROM `Order` O
INNER JOIN Shopping_List S 
    ON O.Product_ID = S.ID
INNER JOIN Fridge F 
    ON O.Item_ID = F.Item_ID
WHERE F.Expiration_Date < CURDATE();