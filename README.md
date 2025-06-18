# MODEL PAPER 01

## Inventory Management System – SQL Code and Output

This exercise demonstrates creating and testing an Inventory Management System using SQL. The script includes table creation with constraints, valid and invalid data insertions, and relational integrity using foreign keys.

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

-- Add foreign keys to StockMovements
ALTER TABLE StockMovements
ADD FOREIGN KEY(product_id)
REFERENCES Product(product_id);

ALTER TABLE StockMovements
ADD FOREIGN KEY(supplier_id)
REFERENCES Suppliers(supplier_id);

-- 1. Valid insert into Products
INSERT INTO Product (product_id, product_name, price, added_on) 
VALUES (1, 'Laptop', 1200.00, CURRENT_DATE);
-- Output: Query OK, 1 row affected

-- View Product table
SELECT * FROM Product;
-- Output:
-- +------------+--------------+---------+------------+
-- | product_id | product_name | price   | added_on   |
-- +------------+--------------+---------+------------+
-- |          1 | Laptop       | 1200.00 | 2025-06-18 |
-- +------------+--------------+---------+------------+

-- 2. Invalid insert into Products: price <= 0 (should fail)
INSERT INTO Product (product_id, product_name, price, added_on) 
VALUES (2, 'Smartphone', -50.00, CURRENT_DATE);
-- Output: ERROR 4025 (23000): CONSTRAINT `product.price` failed

-- 3. Valid insert into Suppliers
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) 
VALUES (101, 'TechSupply Co.', 'contact@techsupply.com', 2010);
-- Output: Query OK, 1 row affected

-- View Suppliers table
SELECT * FROM Suppliers;
-- Output:
-- +-------------+----------------+------------------------+-----------------+
-- | supplier_id | supplier_name  | contact_email          | establised_year |
-- +-------------+----------------+------------------------+-----------------+
-- |         101 | TechSupply Co. | contact@techsupply.com |            2010 |
-- +-------------+----------------+------------------------+-----------------+

-- 4. Invalid insert into Suppliers: duplicate email (should fail)
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) 
VALUES (102, 'Gadget World', 'contact@techsupply.com', 2012);
-- Output: ERROR 1062 (23000): Duplicate entry for 'contact_email'

-- 5. Invalid insert into Suppliers: year < 2000 (should fail)
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) 
VALUES (103, 'Old Supplier', 'old@supplier.com', 1995);
-- Output: ERROR 4025 (23000): CONSTRAINT `suppliers.establised_year` failed

-- 6. Valid insert into StockMovements
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) 
VALUES (1001, 1, 101, 'IN', 50, CURRENT_DATE);
-- Output: Query OK, 1 row affected

-- 7. Invalid insert into StockMovements: movement_type not 'IN' or 'OUT'
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) 
VALUES (1002, 1, 101, 'INOUT', 10, CURRENT_DATE);
-- Output: ERROR 4025 (23000): CONSTRAINT `stockmovements.movement_type` failed

-- 8. Invalid insert into StockMovements: quantity <= 0
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) 
VALUES (1003, 1, 101, 'OUT', 0, CURRENT_DATE);
-- Output: ERROR 4025 (23000): CONSTRAINT `stockmovements.quantity` failed
