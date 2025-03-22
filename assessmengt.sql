CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL
);

CREATE TABLE OrderDetails (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID) ON DELETE CASCADE,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);

-- List all orders with customer details
SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate, Orders.TotalAmount
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;


-- Get all order details with product names
SELECT OrderDetails.OrderDetailID, Orders.OrderID, OrderDetails.Product, OrderDetails.Quantity, OrderDetails.UnitPrice
FROM OrderDetails
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID;


-- Find total spending per customer
SELECT Customers.CustomerName, SUM(Orders.TotalAmount) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName;


-- Get total number of orders per customer
SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS OrderCount
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName;


-- Find the most ordered product
SELECT OrderDetails.Product, COUNT(OrderDetails.OrderDetailID) AS OrderCount
FROM OrderDetails
GROUP BY OrderDetails.Product
ORDER BY OrderCount DESC
LIMIT 1;

-- Find the highest spending customers
SELECT Customers.CustomerName, SUM(Orders.TotalAmount) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName
ORDER BY TotalSpent DESC
LIMIT 5;



-- Find customers who ordered more than once
SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName
HAVING COUNT(Orders.OrderID) > 1;




-- Get order details including customer names
SELECT Customers.CustomerName, Orders.OrderID, OrderDetails.Product, OrderDetails.Quantity, OrderDetails.UnitPrice
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID;





-- Find average order value per customer
SELECT Customers.CustomerName, AVG(Orders.TotalAmount) AS AvgOrderValue
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName;



-- List all orders placed in the last 30 days
SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate, Orders.TotalAmount
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate >= CURRENT_DATE - INTERVAL '30 days';

