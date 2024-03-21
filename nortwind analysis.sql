-- SIMPLE QUERY
-- 1. Berasal dari negara mana sajakah para pelanggan yang terdata? Negara mana yang memiliki customer terbanyak?
SELECT DISTINCT Country FROM customers ORDER BY Country;
SELECT Country, COUNT(CustomerID) AS TotalCustomer FROM customers GROUP BY Country ORDER BY TotalCustomer DESC;

-- 2. Produk apa saja yang dijual, berapa banyak produknya, dan apa saja kategori yang tersedia?
SELECT ProductName FROM products;
SELECT COUNT(*) FROM products;
SELECT CategoryName, Description FROM categories;

-- STRING AND DATE FUNCTIONS
-- 1. Bagaimana cara untuk mendapatkan nama panjang karyawan? (Dibatasi 10 karyawan)
SELECT CONCAT_WS(" ", LastName, FirstName) AS Full_Name FROM employees LIMIT 10;

-- 2. Berapa lama rentang waktu (dalam hari) dari data yang tersedia? Dimulai sejak tanggal berapa hingga kapan?
SELECT DATEDIFF(MAX(OrderDate), MIN(OrderDate)) AS rentang_waktu FROM orders;
SELECT MAX(OrderDate), MIN(OrderDate) FROM orders;

-- 3. Ada berapa transaksi yang terjadi pada kuartal ke-4 tahun 1996?
SELECT COUNT(*) AS Jumlah_Transaksi_Q4_1996 FROM orders WHERE QUARTER(OrderDate) = 4 AND YEAR(OrderDate) = 1996;

-- 4. Siapa karyawan tertua dan termuda? Berikan datanya!
-- tertua
SELECT * FROM employees WHERE BirthDate = (SELECT MIN(BirthDate) FROM employees);
-- termuda
SELECT * FROM employees WHERE BirthDate = (SELECT MAX(BirthDate) FROM employees);

-- JOINS AND HAVING
-- 1. Berapakah jumlah pesanan pada bulan Agustus 1996?
SELECT COUNT(*) AS jumlah_pesanan_Agustus1996 FROM orders
WHERE OrderDate LIKE "1996-08-%";

-- 2. Siapa sajakah customer pada periode tersebut?
SELECT DISTINCT CustomerName FROM customers c INNER JOIN orders o ON c.CustomerID = o.CustomerID
WHERE OrderDate LIKE "1996-08-%" ORDER BY CustomerName;

-- 3. Siapa customer yang paling sering memesan pada periode tersebut?
SELECT c.CustomerName, COUNT(o.CustomerID) AS TotalOrder
FROM customers c JOIN orders o ON c.CustomerID = o.CustomerID
WHERE OrderDate LIKE "1996-08-%"
GROUP BY o.CustomerID
ORDER BY TotalOrder DESC;

-- 4. Berapa jumlah pesanan yang dibuat oleh customer bernama "QUICK-Stop" di bulan September 1996?
SELECT c.CustomerName, COUNT(o.CustomerID) AS Total_Number_of_Orders
FROM customers c INNER JOIN orders o ON c.CustomerID=o.CustomerID
WHERE OrderDate LIKE "1996-09-%" AND CustomerName = "QUICK-Stop"
ORDER BY Total_Number_of_Orders;

-- 5. Berapa jumlah uang yang dibayar oleh customer bernama "QUICK-Stop" di bulan Agustus sampai September 1996?
SELECT c.CustomerID, c.CustomerName, SUM(p.Price * od.Quantity) AS Total_Uang
FROM customers c
	LEFT JOIN orders o ON c.CustomerID = o.CustomerID
	LEFT JOIN orderdetails od ON o.OrderID = od.OrderID
	LEFT JOIN products p ON od.ProductID = p.ProductID
WHERE c.CustomerName = "QUICK-Stop" AND o.OrderDate BETWEEN "1996-08-01" AND "1996-09-30"
GROUP BY c.CustomerID;

-- 6. Bagaimana tren jumlah penjualan pada kuartal 4 di tahun 1996?
SELECT MONTH(OrderDate) AS month_1996, 
	SUM(p.Price * od.Quantity) AS Jumlah_Penjualan_Q4_1996
FROM orders o 
	INNER JOIN orderdetails od ON o.OrderID = od.OrderID
	INNER JOIN products p ON od.ProductID = p.ProductID
WHERE QUARTER(OrderDate) = 4 AND YEAR(OrderDate) = 1996
GROUP BY month_1996 ORDER BY month_1996;

-- 7. Berapa rata-rata sales per bulan pada tahun 1996?
SELECT MONTH(OrderDate) AS month_1996, AVG(Price*Quantity) AS avg_monthly_sales
FROM orderdetails od
	JOIN products p ON p.ProductID = od.ProductID
	JOIN orders o ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 1996
GROUP BY month_1996 ORDER BY month_1996;

-- 8. Siapa pelanggan yang melakukan pembelian lebih dari 5 kali sejak bulan Oktober 1996?
SELECT c.CustomerName, COUNT(o.OrderID) AS Jumlah_Pesanan FROM customers c
	LEFT JOIN orders o ON c.CustomerID = o.CustomerID
WHERE OrderDate >= "1996-10-1"
GROUP BY c.CustomerName HAVING COUNT(OrderID) > 5 ORDER BY Jumlah_Pesanan;

-- 9. Apa produk yang paling banyak dibeli?
SELECT p.ProductName, SUM(p.Price * od.Quantity) AS Sales
FROM Products p INNER JOIN orderdetails od
ON od.ProductID = p.ProductID
GROUP BY p.ProductName ORDER BY Sales DESC;