INSERT INTO Products (product_id, product_name, price, added_on) VALUES
(1, 'Laptop', 1200.00, CURRENT_DATE),
(2, 'Smartphone', 800.00, CURRENT_DATE),
(3, 'Tablet', 450.00, CURRENT_DATE),
(4, 'Monitor', 250.00, CURRENT_DATE),
(5, 'Keyboard', 40.00, CURRENT_DATE),
(6, 'Mouse', 25.00, CURRENT_DATE),
(7, 'Printer', 150.00, CURRENT_DATE),
(8, 'Router', 90.00, CURRENT_DATE),
(9, 'Webcam', 60.00, CURRENT_DATE),
(10, 'External HDD', 110.00, CURRENT_DATE);

INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, established_year) VALUES
(101, 'TechSupply Co.', 'contact@techsupply.com', 2010),
(102, 'Gadget World', 'info@gadgetworld.com', 2012),
(103, 'ElectroMart', 'sales@electromart.com', 2015),
(104, 'Digital Source', 'hello@digitalsource.com', 2020),
(105, 'Hardware Hub', 'support@hardwarehub.com', 2005),
(106, 'Modern Tech', 'contact@moderntech.com', 2018),
(107, 'Device Depot', 'info@devicedepot.com', 2003),
(108, 'Peripheral Plus', 'contact@peripheralplus.com', 2021),
(109, 'NextGen Supplies', 'sales@nextgensupplies.com', 2016),
(110, 'CompuWorld', 'info@compuworld.com', 2008);

INSERT INTO StockMovements (movement_id, product_id, supplier_id, movement_type, quantity, movement_date) VALUES
(1001, 1, 101, 'IN', 50, CURRENT_DATE),
(1002, 2, 102, 'IN', 100, CURRENT_DATE),
(1003, 3, 103, 'IN', 70, CURRENT_DATE),
(1004, 4, 104, 'IN', 30, CURRENT_DATE),
(1005, 5, 105, 'IN', 150, CURRENT_DATE),
(1006, 6, 106, 'IN', 90, CURRENT_DATE),
(1007, 7, 107, 'OUT', 10, CURRENT_DATE),
(1008, 8, 108, 'OUT', 5, CURRENT_DATE),
(1009, 9, 109, 'OUT', 20, CURRENT_DATE),
(1010, 10, 110, 'OUT', 15, CURRENT_DATE);
