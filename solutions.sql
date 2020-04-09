-- Practice Joins
-- 1. Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT *
FROM invoice i
JOIN invoice_line il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;

-- 2. Get the invoice_date, customer first_name and last_name, and total from all invoices.
SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;

-- 3. Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;

-- Support reps are on the employee table.
-- 4. Get the album title and the artist name from all albums.
SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;

-- 5. Get all playlist_track track_ids where the playlist name is Music.
SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';

-- 6. Get all track names for playlist_id 5.
SELECT t.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;


-- 7. Get all track names and the playlist name that they're on ( 2 joins ).
SELECT t.name, p.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;


-- 8. Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
SELECT t.name, a.title
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';


-- Practice nested queries
-- 1. Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT *
FROM invoice
WHERE invoice_id IN ( SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99);

-- 2. Get all playlist tracks where the playlist name is Music.
SELECT *
FROM playlist_track
WHERE playlist_id IN ( SELECT playlist_id FROM playlist WHERE name = 'Music' );

-- 3. Get all track names for playlist_id 5.
SELECT name
FROM track
WHERE track_id IN ( SELECT track_id FROM playlist_track WHERE playlist_id = 5 );

-- 4. Get all tracks where the genre is Comedy.
SELECT *
FROM track
WHERE genre_id IN (SELECT genre_id FROM genre WHERE name = 'Comedy' );

-- 5. Get all tracks where the album is Fireball.
SELECT *
FROM track
WHERE album_id IN ( SELECT album_id FROM album WHERE title = 'Fireball' );

-- 6. Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT *
FROM track
WHERE album_id IN(
  SELECT album_id FROM album WHERE artist_id IN (
  SELECT artist_id FROM artist WHERE name = 'Queen'
 )
);


-- Practice updating Rows
-- 1. Find all customers with fax numbers and set those numbers to null.
UPDATE customer
SET fax = null
WHERE fax IS NOT null;

-- 2. Find all customers with no company (null) and set their company to "Self".
UPDATE customer
SET company = 'Self'
WHERE company IS null;

-- 3. Find the customer Julia Barnett and change her last name to Thompson.
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

-- 4. Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

-- 5. Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = ( SELECT genre_id FROM genre WHERE name = 'Metal' )
AND composer IS null;

-- 6. Refresh your page to remove all database changes.


-- Group by
-- 1. Find a count of how many tracks there are per genre. Display the genre name with the count.
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;

-- 2. Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

-- 3. Find a list of all artists and how many albums they have.
SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

-- Use Distinct
-- 1. From the track table find a unique list of all composers.
SELECT DISTINCT composer
FROM track;

-- 2. From the invoice table find a unique list of all billing_postal_codes.
SELECT DISTINCT billing_postal_code
FROM invoice;

-- 3. From the customer table find a unique list of all companys.
SELECT DISTINCT company
FROM customer;


-- Delete Rows
--  Copy, paste, and run the SQL code from the summary.
-- 1. Delete all 'bronze' entries from the table.
DELETE
FROM practice_delete
WHERE type = 'bronze';

-- 2. Delete all 'silver' entries from the table.
DELETE 
FROM practice_delete 
WHERE type = 'silver';

-- 3. Delete all entries whose value is equal to 150.
DELETE 
FROM practice_delete 
WHERE value = 150;



-- eCommerce Simulation

-- 1. Create 3 tables following the criteria in the summary.
CREATE TABLE users (
user_id SERIAL PRIMARY KEY, 
name VARCHAR(100), 
email VARCHAR(100)
);

CREATE TABLE products (
product_id SERIAL PRIMARY KEY,
name VARCHAR(100),
price NUMERIC
);

CREATE TABLE orders (
order_id SERIAL PRIMARY KEY,
order_num INTEGER,
product_id INTEGER REFERENCES products (product_id)
);

-- 2. Add some data to fill up each table.
-- At least 3 users, 3 products, 3 orders.

INSERT INTO users (name, email)
VALUES 
('Ron', 'Ron1@gmail.com'), 
('Robert', 'Robert@gmail.com'), 
('Arnold', 'Arnold@yahoomail.com');

INSERT INTO products (name, price)
VALUES 
('Macbook Pro', 1500), 
('Apple Watch', 400), 
('Ipad', 700);

INSERT INTO orders (order_num, product_id)
VALUES 
(2, 1), 
(2, 2), 
(1, 3);

-- 3. Run queries against your data.
-- Get all products for the first order.
SELECT * FROM orders
WHERE order_num = 1;

-- Get all orders.
SELECT * FROM orders;

-- Get the total cost of an order ( sum the price of all products on an order ).
SELECT SUM(p.price) FROM orders o
INNER JOIN products p ON p.product_id = o.product_id
WHERE o.order_num = 2;

-- 4. Add a foreign key reference from orders to users.
ALTER TABLE orders
ADD CONSTRAINT user_id FOREIGN KEY (order_num) REFERENCES users(user_id);

-- 5. Update the orders table to link a user to each order.
ALTER TABLE orders
ADD FOREIGN KEY (order_id) REFERENCES users (user_id);

-- 6. Run queries against your data.
-- Get all orders for a user.
SELECT * FROM orders
WHERE order_num = 2;

-- Get how many orders each user has.
SELECT DISTINCT u.name, 
COUNT(DISTINCT o.order_num) 
FROM orders o
INNER JOIN users u 
ON u.user_id = o.order_num
GROUP BY u.name;