CREATE DATABASE tutungerie;
USE tutungerie;

CREATE TABLE product_type (
type_id INT PRIMARY KEY,
type_name VARCHAR(255),
product_quantity INT,
total_sales DECIMAL(10,2)
);

CREATE TABLE tutungerie_details (
    tutungerie_id INT PRIMARY KEY,
    tutungerie_name VARCHAR(255),
    tutungerie_address VARCHAR(255),
	tutungerie_restriction_for_minors VARCHAR(255),
	product_type_id INT,
	FOREIGN KEY (product_type_id) REFERENCES product_type(type_id)
);

CREATE TABLE employers (
    employer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    tutungerie_id INT,
	position VARCHAR(255),
	cnp VARCHAR(255),
    FOREIGN KEY (tutungerie_id) REFERENCES tutungerie_details(tutungerie_id)
);


CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    sale_total DECIMAL(10,2),
	sale_taxes DECIMAL(10,2),
	product_type_id INT,
	FOREIGN KEY (product_type_id) REFERENCES product_type(type_id)
);

CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY,
    promotion_name VARCHAR(255),
    promotion_discount DECIMAL(5,2),
    total_product_sold INT 
);

CREATE TABLE products (
	product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_price DECIMAL(10,2),
	product_expiry_date DATE,
	product_production_date DATE,
	product_type_id INT,
    promotion_id INT,
	FOREIGN KEY (product_type_id) REFERENCES product_type(type_id)
);

CREATE TABLE promotions_products (
    promotion_id INT,
    product_id INT,
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE employer_details (
    employer_id INT,
    employer_address VARCHAR(255),
    employer_phone_number VARCHAR(255),
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id)
);

CREATE INDEX product_type_type_id_idx ON product_type(type_id);
CREATE INDEX tutungerie_details_tutungerie_id_idx ON tutungerie_details(tutungerie_id);
CREATE INDEX employers_employer_id_idx ON employers(employer_id);
CREATE INDEX sales_sale_id_idx ON sales(sale_id);
CREATE INDEX promotions_promotion_id_idx ON promotions(promotion_id);
CREATE INDEX products_product_id_idx ON products(product_id);
CREATE INDEX promotions_products_promotion_id_idx ON promotions_products(promotion_id);
CREATE INDEX employer_details_employer_id_idx ON employer_details(employer_id);


INSERT INTO product_type (type_id, type_name, product_quantity, total_sales)
VALUES (1, 'Cigarettes', 500, 0),
(2, 'Cigars', 200, 0),
(3, 'Pipe Tobacco', 150, 0),
(4, 'Pipe', 50,0),
(5,'Vape', 250,0);

INSERT INTO tutungerie_details (tutungerie_id, tutungerie_name, tutungerie_address, tutungerie_restriction_for_minors, product_type_id)
VALUES (1, 'Tutungerie 1', '123 Main St', '18+', 1),
(2, 'Tutungerie 2', '456 Park Ave', '21+', 2),
(3, 'Tutungerie 3', '789 Elm St', '18+', 3),
(4, 'Tutungerie 4', '214 School St', '18+', 4),
(5, 'Tutungerie 5', '97  Long St', '21+', 5);

INSERT INTO employers (employer_id, first_name, last_name, tutungerie_id, position, cnp)
VALUES (1, 'John', 'Doe', 1, 'Manager', '1234567890123'),
(2, 'Jane', 'Smith', 2, 'Assistant Manager', '2345678901234'),
(3, 'Bob', 'Johnson', 3, 'Sales Associate', '3456789012345'),
(4, 'Mike', 'Trump', 4, 'saleperson', '1427332591234'),
(5, 'Vlad', 'Kerekes', 5, 'saleperson', '1121426983675');

INSERT INTO sales (sale_id, sale_date, sale_total, sale_taxes, product_type_id)
VALUES (1, '2022-01-01', 100.00, 8.00, 1),
(2, '2022-01-02', 75.00, 6.00, 2),
(3, '2022-01-03', 50.00, 4.00, 3),
(4, '2022-12-12', 55.00, 5.00, 4),
(5, '2022-06-06', 45, 3.50, 5);  

INSERT INTO promotions (promotion_id, promotion_name, promotion_discount, total_product_sold)
VALUES (1, 'New Year Sale', 10, 0),
(2, 'Summer Sale', 15, 0),
(3, 'Black Friday', 50, 0),
(4, 'winter sale', 20, 0),
(5, 'Spring sale', 25,0);

INSERT INTO products (product_id, product_name, product_price, product_expiry_date, product_production_date, product_type_id, promotion_id)
VALUES (1, 'Marlboro', 10.00, '2022-12-31','2022-01-01', 1, 1),
(2, 'Cohiba', 20.00, '2022-12-31','2022-01-01', 2, 2),
(3, 'Mac Baren', 15.00, '2022-12-31','2022-01-01', 3, 3),
(4, 'Golden Virginia', 25.00, '2023-11-11', '2022-05-06', 4, 4),
(5, 'Dunhill', 25.00, '2024-01-01', '2022-06-09', 5,5);

INSERT INTO promotions_products (promotion_id, product_id)
VALUES (1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO employer_details (employer_id, employer_address, employer_phone_number)
VALUES (1, '456 Park Ave', '555-555-5555'),
(2, '789 Elm St', '555-555-5556'),
(3, '123 Main St', '555-555-5557'),
(4, '214 School St', '666-666-6656'),
(5, '97  Long St', '444-444-1234');

CREATE VIEW product_summary AS
SELECT p.product_id, p.product_name, p.product_price, t.type_name, p.product_expiry_date, p.product_production_date
FROM products p
JOIN product_type t ON p.product_type_id = t.type_id;

CREATE VIEW employer_summary AS
SELECT e.employer_id, e.first_name, e.last_name, e.position, e.cnp, t.tutungerie_name, d.employer_address, d.employer_phone_number
FROM employers e
JOIN tutungerie_details t ON e.tutungerie_id = t.tutungerie_id
JOIN employer_details d ON e.employer_id = d.employer_id;

CREATE VIEW sales_summary AS
SELECT s.sale_id, s.sale_date, s.sale_total, s.sale_taxes, t.type_name
FROM sales s
JOIN product_type t ON s.product_type_id = t.type_id;


CREATE TRIGGER update_product_type_sales
ON sales
AFTER INSERT
AS
BEGIN
    UPDATE product_type SET total_sales = total_sales + inserted.sale_total, product_quantity = product_quantity - 1
    FROM product_type 
    INNER JOIN inserted ON product_type.type_id = inserted.product_type_id;
END

CREATE TRIGGER prevent_employer_duplicate_cnp
ON employers
AFTER INSERT
AS
BEGIN
    IF EXISTS(SELECT cnp FROM employers WHERE cnp IN (SELECT cnp FROM inserted) GROUP BY cnp HAVING COUNT(cnp) > 1)
    BEGIN
        RAISERROR ('Duplicate CNP', 16, 1);
        ROLLBACK;
    END
END


CREATE TRIGGER check_product_type_id
ON products
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM product_type WHERE type_id IN (SELECT product_type_id FROM inserted))
    BEGIN
        RAISERROR ('Invalid product_type_id', 16, 1);
        ROLLBACK;
    END
END

CREATE PROCEDURE get_product_type_sales (@type_id INT)
AS
BEGIN
    SELECT type_name, product_quantity, total_sales
    FROM product_type
    WHERE type_id = @type_id
END

CREATE PROCEDURE update_product_price (@product_id INT, @new_price DECIMAL(10,2))
AS
BEGIN
    UPDATE products
    SET product_price = @new_price
    WHERE product_id = @product_id
END

CREATE PROCEDURE get_employers_by_tutungerie_id (@tutungerie_id INT)
AS
BEGIN
    SELECT first_name, last_name, position, cnp
    FROM employers
    WHERE tutungerie_id = @tutungerie_id
END


SELECT * FROM sales_summary
SELECT * FROM product_summary
SELECT * FROM employer_summary






