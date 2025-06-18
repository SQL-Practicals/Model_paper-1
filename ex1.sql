create database InventoryMangement;

use InventoryMangement;

CREATE table Product(
	product_id INT ,
	product_name VARCHAR(100) NOT NULL,
	price DECIMAL(10,2) CHECK(price>0),
	added_on DATE DEFAULT CURRENT_DATE,
	PRIMARY Key(product_id)
);


CREATE TABLE Suppliers(
	supplier_id INT ,
	supplier_name VARCHAR(100) NOT NULL,
	contact_email VARCHAR(100) UNIQUE,
	establised_year INT CHECK(establised_year >= 2000),
	PRIMARY KEY(supplier_id)
);

CREATE TABLE StockMovements(
	movement_id INT,
	product_id INT,
	supplier_id INT,
	movement_type VARCHAR(10) CHECK (movement_type IN ('IN' ,'OUT')),
	quantity INT CHECK (quantity > 0),
	movement_date DATE DEFAULT CURRENT_DATE,
	PRIMARY Key(movement_id)
);


ALTER TABLE StockMovements
ADD FOREIGN KEY(product_id)
REFERENCES Product(product_id);

ALTER TABLE StockMovements
ADD FOREIGN KEY(supplier_id)
REFERENCES Suppliers(supplier_id);


-- 1. Valid insert into Products
INSERT INTO Product (product_id, product_name, price, added_on) 
VALUES (1, 'Laptop', 1200.00, CURRENT_DATE);
Query OK, 1 row affected (0.011 sec)
MariaDB [InventoryMangement]> select * from product;
+------------+--------------+---------+------------+
| product_id | product_name | price   | added_on   |
+------------+--------------+---------+------------+
|          1 | Laptop       | 1200.00 | 2025-06-18 |
+------------+--------------+---------+------------+

-- 2. Invalid insert into Products: price <= 0 (should fail)
INSERT INTO Product (product_id, product_name, price, added_on) 
VALUES (2, 'Smartphone', -50.00, CURRENT_DATE);
ERROR 4025 (23000): CONSTRAINT `product.price` failed for `inventorymangement`.`product`

-- 3. Valid insert into Suppliers
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) 
VALUES (101, 'TechSupply Co.', 'contact@techsupply.com', 2010);
Query OK, 1 row affected (0.006 sec)
MariaDB [InventoryMangement]> select * from Suppliers;
+-------------+----------------+------------------------+-----------------+
| supplier_id | supplier_name  | contact_email          | establised_year |
+-------------+----------------+------------------------+-----------------+
|         101 | TechSupply Co. | contact@techsupply.com |            2010 |
+-------------+----------------+------------------------+-----------------+
1 row in set (0.000 sec)

-- 4. Invalid insert into Suppliers: duplicate email (should fail)
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) 
VALUES (102, 'Gadget World', 'contact@techsupply.com', 2012);
Duplicate entry 'contact@techsupply.com' for key 'contact_email'
 
-- 5. Invalid insert into Suppliers: established_year < 2000 (should fail)
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, establised_year) 
VALUES (103, 'Old Supplier', 'old@supplier.com', 1995);
ERROR 4025 (23000): CONSTRAINT `suppliers.establised_year` failed for `inventorymangement`.`suppliers`

-- 6. Valid insert into StockMovements
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) 
VALUES (1001, 1, 101, 'IN', 50, CURRENT_DATE);
Query OK, 1 row affected (0.007 sec)

-- 7. Invalid insert into StockMovements: movement_type not 'IN' or 'OUT' (should fail)
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) 
VALUES (1002, 1, 101, 'INOUT', 10, CURRENT_DATE);
ERROR 4025 (23000): CONSTRAINT `stockmovements.movement_type` failed for `inventorymangement`.`stockmovements`

-- 8. Invalid insert into StockMovements: quantity <= 0 (should fail)
INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) 
VALUES (1003, 1, 101, 'OUT', 0, CURRENT_DATE);
ERROR 4025 (23000): CONSTRAINT `stockmovements.quantity` failed for `inventorymangement`.`stockmovements`

