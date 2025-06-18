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


CREATE INDEX idx_products_name ON Product(product_name);
Query OK, 0 rows affected (0.030 sec)
Records: 0  Duplicates: 0  Warnings: 0

CREATE INDEX idx_stock_product_movement ON  StockMovements(product_id,movement_type);
Query OK, 0 rows affected (0.019 sec)
Records: 0  Duplicates: 0  Warnings: 0

CREATE INDEX idx_unique_supplier_name ON Suppliers(supplier_name);


 SHOW INDEXES FROM Product;
+---------+------------+-------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table   | Non_unique | Key_name          | Seq_in_index | Column_name  | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+---------+------------+-------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| product |          0 | PRIMARY           |            1 | product_id   | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
| product |          1 | idx_products_name |            1 | product_name | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
+---------+------------+-------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
2 rows in set (0.001 sec)



 SHOW INDEXES FROM Suppliers;
+-----------+------------+--------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table     | Non_unique | Key_name                 | Seq_in_index | Column_name   | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-----------+------------+--------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| suppliers |          0 | PRIMARY                  |            1 | supplier_id   | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
| suppliers |          0 | contact_email            |            1 | contact_email | A         |           1 |     NULL | NULL   | YES  | BTREE      |         |               |
| suppliers |          1 | idx_unique_supplier_name |            1 | supplier_name | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
+-----------+------------+--------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
3 rows in set (0.002 sec)



SHOW INDEXES FROM StockMovements;
+----------------+------------+----------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table          | Non_unique | Key_name                   | Seq_in_index | Column_name   | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+----------------+------------+----------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| stockmovements |          0 | PRIMARY                    |            1 | movement_id   | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
| stockmovements |          1 | idx_stock_product_movement |            1 | product_id    | A         |           1 |     NULL | NULL   | YES  | BTREE      |         |               |
| stockmovements |          1 | idx_stock_product_movement |            2 | movement_type | A         |           1 |     NULL | NULL   | YES  | BTREE      |         |               |
+----------------+------------+----------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
3 rows in set (0.002 sec)



DROP INDEX idx_products_name ON product;
Query OK, 0 rows affected (0.016 sec)
Records: 0  Duplicates: 0  Warnings: 0


SHOW INDEXES FROM StockMovements;
MariaDB [InventoryMangement]> SHOW INDEXES FROM StockMovements;
+----------------+------------+----------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table          | Non_unique | Key_name                   | Seq_in_index | Column_name   | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+----------------+------------+----------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| stockmovements |          0 | PRIMARY                    |            1 | movement_id   | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
| stockmovements |          1 | idx_stock_product_movement |            1 | product_id    | A         |           1 |     NULL | NULL   | YES  | BTREE      |         |               |
| stockmovements |          1 | idx_stock_product_movement |            2 | movement_type | A         |           1 |     NULL | NULL   | YES  | BTREE      |         |               |
+----------------+------------+----------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
3 rows in set (0.001 sec)


DELIMITER //
CREATE PROCEDURE TotalStockIn(IN pid INT, OUT total_in INT)
BEGIN
    SELECT SUM(quantity) INTO total_in
    FROM StockMovements
    WHERE product_id = pid AND movement_type = 'IN';
END 
//DELIMITER ;




DELIMITER //

CREATE PROCEDURE TotalStockOut(IN pid INT, OUT total_out INT)
BEGIN
    SELECT SUM(quantity) INTO total_out
    FROM StockMovements
    WHERE product_id = pid AND movement_type = 'OUT';
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

CREATE PROCEDURE InsertStockMovement(
    IN pid INT,
    IN qty INT,
    IN mtype VARCHAR(10)
)
BEGIN
    INSERT INTO StockMovements(product_id, supplier_id, movement_type, quantity, movement_date)
    VALUES (pid, NULL, mtype, qty, CURRENT_DATE);
END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE UpdateProductPrice(IN pid INT, IN new_price DECIMAL(8,2))
BEGIN
    UPDATE Products SET price = new_price WHERE product_id = pid;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE SupplierProductCount(IN sid INT, OUT product_count INT)
BEGIN
    SELECT COUNT(DISTINCT product_id) INTO product_count
    FROM StockMovements
    WHERE supplier_id = sid;
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

