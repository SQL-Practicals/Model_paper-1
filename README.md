# MODEL PAPER 01

## Inventory Management System – Full SQL Implementation

This practical demonstrates how to build an Inventory Management System using SQL with tables, constraints, foreign keys, insert operations, indexes, and stored procedures.

```sql
-- Create database
CREATE DATABASE InventoryMangement;
USE InventoryMangement;

-- Create Product table
CREATE TABLE Product(
	product_id INT,
	product_name VARCHAR(100) NOT NULL,
	price DECIMAL(10,2) CHECK(price > 0),
	added_on DATE DEFAULT CURRENT_DATE,
	PRIMARY KEY(product_id)
);

-- Create Suppliers table
CREATE TABLE Suppliers(
	supplier_id INT,
	supplier_name VARCHAR(100) NOT NULL,
	contact_email VARCHAR(100) UNIQUE,
	establised_year INT CHECK(establised_year >= 2000),
	PRIMARY KEY(supplier_id)
);

-- Create StockMovements table
CREATE TABLE StockMovements(
	movement_id INT,
	product_id INT,
	supplier_id INT,
	movement_type VARCHAR(10) CHECK (movement_type IN ('IN', 'OUT')),
	quantity INT CHECK (quantity > 0),
	movement_date DATE DEFAULT CURRENT_DATE,
	PRIMARY KEY(movement_id)
);

-- Add foreign keys
ALTER TABLE StockMovements ADD FOREIGN KEY(product_id) REFERENCES Product(product_id);
ALTER TABLE StockMovements ADD FOREIGN KEY(supplier_id) REFERENCES Suppliers(supplier_id);

-- Insert and Output Section

-- Valid insert into Product
INSERT INTO Product (product_id, product_name, price, added_on) VALUES (1, 'Laptop', 1200.00, CURRENT_DATE);
-- Output: Query OK, 1 row affected

-- Select from Product
SELECT * FROM Product;
-- Output:
-- +------------+--------------+---------+------------+
-- | product_id | product_name | price   | added_on   |
-- +------------+--------------+---------+------------+
-- |          1 | Laptop       | 1200.00 | 2025-06-18 |
-- +------------+--------------+---------+------------+

-- Invalid insert into Product (price <= 0)
INSERT INTO Product (product_id, product_name, price, added_on) VALUES (2, 'Smartphone', -50.00, CURRENT_DATE);
-- ERROR 4025 (23000): CONSTRAINT `product.price` failed

-- Valid insert into Suppliers
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) VALUES (101, 'TechSupply Co.', 'contact@techsupply.com', 2010);
-- Output: Query OK, 1 row affected

-- Select from Suppliers
SELECT * FROM Suppliers;
-- Output:
-- +-------------+----------------+------------------------+-----------------+
-- | supplier_id | supplier_name  | contact_email          | establised_year |
-- +-------------+----------------+------------------------+-----------------+
-- |         101 | TechSupply Co. | contact@techsupply.com |            2010 |
-- +-------------+----------------+------------------------+-----------------+

-- Invalid insert into Suppliers (duplicate email)
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) VALUES (102, 'Gadget World', 'contact@techsupply.com', 2012);
-- Duplicate entry 'contact@techsupply.com' for key 'contact_email'

-- Invalid insert into Suppliers (year < 2000)
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) VALUES (103, 'Old Supplier', 'old@supplier.com', 1995);
-- ERROR 4025 (23000): CONSTRAINT `suppliers.establised_year` failed

-- Valid insert into StockMovements
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) VALUES (1001, 1, 101, 'IN', 50, CURRENT_DATE);
-- Output: Query OK, 1 row affected

-- Invalid insert (invalid movement_type)
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) VALUES (1002, 1, 101, 'INOUT', 10, CURRENT_DATE);
-- ERROR 4025 (23000): CONSTRAINT `stockmovements.movement_type` failed

-- Invalid insert (quantity <= 0)
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) VALUES (1003, 1, 101, 'OUT', 0, CURRENT_DATE);
-- ERROR 4025 (23000): CONSTRAINT `stockmovements.quantity` failed

-- Index Creation
CREATE INDEX idx_products_name ON Product(product_name);
CREATE INDEX idx_stock_product_movement ON StockMovements(product_id, movement_type);
CREATE INDEX idx_unique_supplier_name ON Suppliers(supplier_name);

-- Show indexes
SHOW INDEXES FROM Product;
SHOW INDEXES FROM Suppliers;
SHOW INDEXES FROM StockMovements;

-- Drop index
DROP INDEX idx_products_name ON Product;

-- Show indexes after drop
SHOW INDEXES FROM StockMovements;

-- Stored Procedures

DELIMITER //
CREATE PROCEDURE TotalStockIn(IN pid INT, OUT total_in INT)
BEGIN
    SELECT SUM(quantity) INTO total_in FROM StockMovements WHERE product_id = pid AND movement_type = 'IN';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE TotalStockOut(IN pid INT, OUT total_out INT)
BEGIN
    SELECT SUM(quantity) INTO total_out FROM StockMovements WHERE product_id = pid AND movement_type = 'OUT';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE NetStockBalance(IN pid INT, OUT net_stock INT)
BEGIN
    DECLARE total_in INT;
    DECLARE total_out INT;
    CALL TotalStockIn(pid, total_in);
    CALL TotalStockOut(pid, total_out);
    SET net_stock = IFNULL(total_in, 0) - IFNULL(total_out, 0);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertStockMovement(IN pid INT, IN qty INT, IN mtype VARCHAR(10))
BEGIN
    INSERT INTO StockMovements(product_id, supplier_id, movement_type, quantity, movement_date)
    VALUES (pid, NULL, mtype, qty, CURRENT_DATE);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateProductPrice(IN pid INT, IN new_price DECIMAL(8,2))
BEGIN
    UPDATE Product SET price = new_price WHERE product_id = pid;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SupplierProductCount(IN sid INT, OUT product_count INT)
BEGIN
    SELECT COUNT(DISTINCT product_id) INTO product_count FROM StockMovements WHERE supplier_id = sid;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ProductsBySupplier(IN sname VARCHAR(100), OUT total INT)
BEGIN
    SELECT COUNT(DISTINCT sm.product_id) INTO total
    FROM StockMovements sm
    JOIN Suppliers s ON sm.supplier_id = s.supplier_id
    WHERE s.supplier_name = sname;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AdjustSupplierID(INOUT sid INT)
BEGIN
    IF sid < 1000 THEN
        SET sid = sid + 1000;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE StockMovementsByProduct(IN pid INT)
BEGIN
    SELECT * FROM StockMovements WHERE product_id = pid;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteStockByProduct(IN pid INT)
BEGIN
    DELETE FROM StockMovements WHERE product_id = pid;
END //
DELIMITER ;
