CREATE TABLE genre (
    genre_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE album (
    album_id INT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    artist_id INT,

constraint Artist_FK
 foreign key (artist_id)
 references artist(artist_id)
 ON DELETE CASCADE
	
);



Create table Track(
track_id int primary Key,
name  Varchar(200) Not Null,
album_id int,
media_type_id int,
genre_id int,
composer varchar(200),
milliseconds int,
bytes int,
unit_price float,

constraint fk_album
 foreign key (album_id)
 references album(album_id)
 ON DELETE CASCADE,

CONSTRAINT fk_genre
        FOREIGN KEY (genre_id)
        REFERENCES genre(genre_id)
        ON DELETE CASCADE
 
);

create table artist(
   artist_id INT Primary Key,
   name Varchar(200)
);

Create table Playlist(
  name varchar(50),
  playlist_id INT Primary Key
);

Create table playlist_track(
  playlist_id INT,
  track_id INT,
  
CONSTRAINT fk_playlist
        FOREIGN KEY (playlist_id)
        REFERENCES Playlist(playlist_id)
        ON DELETE CASCADE
  
)


Create table employee(
employee_id	INT Primary Key ,
last_name Varchar(10),
first_name varchar(10),
title Varchar(50),
reports_to	int,
levels text,
birthdate text,
hire_date text,
address	text,
city Varchar(15),
state_	varchar(5),
country	varchar(10),
postal_code	text,
phone text,
fax	text,
email text
);


Create table customer(
customer_id	INT Primary Key,
first_name	Varchar(50),
last_name Varchar(50),
company	varchar(100),
address Text,
city varchar(30),
state_ varchar(10),
country varchar(30),
postal_code Varchar(50),
texphone Text,	
fax Text,
email Text,
employee_id INT,

CONSTRAINT fk_employee_id
        FOREIGN KEY (employee_id)
        REFERENCES employee(employee_id)
        ON DELETE CASCADE

);

create table invoice(
invoice_id	int Primary Key,
customer_id	 int,
invoice_date timestamp,
billing_address varchar(200),
billing_city varchar(50),
billing_state Varchar(10),
billing_country	 Varchar(50),
billing_postal_code text,
total float,

CONSTRAINT fk_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE

);

Select * from track;

Create table invoice_line(
invoice_line_id	int,
invoice_id	int,
track_id	int,
unit_price float,
quantity int,

CONSTRAINT fk_invoice_id
        FOREIGN KEY (invoice_id)
        REFERENCES invoice(invoice_id)
        ON DELETE CASCADE
);

---1. Customer Analytics
---Which customers have spent the most money on music?

Select C.first_name as Customer_name,
    Sum(i.total) as revenue from customer as c join invoice as i 
	on c.customer_id=I.customer_id group by C.first_name
	order by revenue desc limit 10;


---What is the average customer lifetime value?
Select round(Avg(Cu.revenue) ::numeric, 2) as avg_customer_lifetime_value from
 (Select distinct C.customer_id as Customer_id,
    Sum(i.total ) as revenue from customer as c join invoice as i 
	on c.customer_id=I.customer_id group by C.customer_id ) Cu;

---How many customers have made repeat purchases versus one-time purchases?
Select 
 SUM(CASE WHEN number_of_times_pur = 1 THEN 1 ELSE 0 END) 
        AS one_time_customers,
        
    SUM(CASE WHEN number_of_times_pur > 1 THEN 1 ELSE 0 END) 
        AS repeat_customers from (

Select Distinct c.customer_id  as customer_id , count(distinct i.invoice_date) as number_of_Times_pur
  from customer as c join invoice  as i on c.customer_id=I.customer_id
  group by c.customer_id) cu;

---Which country generates the most revenue per customer?
Select i.billing_country as country,count(distinct c.customer_id ) as customers_count,
   (Sum(i.total)/count(distinct c.customer_id)) as revenue_per_cus
   from customer as c join invoice as i on c.customer_id=I.customer_id
   group by i.billing_country order by revenue_per_cus desc limit 5;
   
---2. Sales & Revenue Analysis

---Which customers haven't made a purchase in the last 6 months?
Select distinct c.Customer_id  as Customer_id,C.first_name || ''|| c.last_name as name
   from Customer as  c join invoice as i on c.customer_id=I.customer_id  group by c.Customer_id
   HAVING MAX(i.invoice_date) IS NULL 
   OR MAX(i.invoice_date) < '2020-06-30';
   
---What is the average value of an invoice (purchase)?
SELECT ROUND(AVG(total)::numeric, 2) AS avg_invoice_value
FROM invoice;

---How much revenue does each sales representative contribute?
Select distinct c.employee_id  as Employee_id,e.first_name|| ' '||e.last_name as Name ,Sum(i.total) as revenue 
 from customer as c join invoice as i on c.customer_id=i.customer_id join employee as e on c.employee_id=e.employee_id
 group by c.employee_id ,e.first_name|| ' '||e.last_name order by Revenue Desc ;

---3. Product & Content Analysis
---Which tracks generated the most revenue?
Select i.track_id as Track_id ,t.name as track_name,round(Sum(i.unit_price)::numeric,2) as revenue 
from invoice_line as i join track as t on i.track_id=t.track_id
group by i.track_id,t.name order by revenue desc limit 10;

---Which albums or playlists are most frequently included in purchases?
 Select t.album_id ,a.title as Album_name ,count(i.track_id) as Frequency from invoice_line as i 
 join track as t on i.track_id=t.track_id join Album as a on a.album_id=t.album_id
 group by t.album_id ,a.title order by Frequency desc limit 10 ;

 ---Are there any tracks or albums that have never been purchased?
SELECT 
    a.album_id,
    a.title AS album_name
FROM album a
WHERE NOT EXISTS (
    SELECT 1
    FROM track t
    JOIN invoice_line il 
        ON t.track_id = il.track_id
    WHERE t.album_id = a.album_id
);

--What is the average price per track across different genres?
Select g.name As genre_name,round(avg(t.unit_price)::numeric,2) as Avg_track_price from
track as  t join genre as g on g.genre_id=t.genre_id group by g.name
order by Avg_track_price desc;


---4. Artist & Genre Performance
---Who are the top 5 highest-grossing artists?

Select ar.artist_id,ar.name ,Sum(i.unit_price) as revenue from invoice_line as i 
 join track as t on i.track_id= t.track_id
 join album  as a on t.album_id=a.album_id 
 join artist as ar on a.artist_id=ar.artist_id
  group by  ar.artist_id,ar.name order by revenue desc limit 5;

---Which music genres are most popular in terms of:
---Number of tracks sold
---Total revenue

Select G.name,Count(distinct t.track_id) as Tracks,Sum(i.unit_price) as revenue
 from invoice_line as i join track as t on t.track_id=i.track_id
 join genre as g on g.genre_id=t.genre_id  group by G.name order by tracks desc
 limit 5; 

---Are certain genres more popular in specific countries?
-->Analyze genre popularity by country
--> Calculate total tracks sold and revenue per genre in each country
-->Identify top-performing genre-country combinations based on sales volume
 Select i.billing_country,g.name,Count(l.track_id) as Trackers_Sold,Round(Sum(l.unit_price)::numeric,2) as revenue
  from invoice_line as l join invoice as i on i.invoice_id=l.invoice_id
  join track as t on l.track_id=t.track_id join genre as g
   on g.genre_id=t.genre_id group by i.billing_country,g.name
   order by trackers_sold Desc,billing_country limit 30 ;

---5. Employee & Operational Efficiency
---Which employees (support representatives) are managing the highest-spending customers?
Select e.employee_id ,e.first_name as Name ,count(cu.customer_id) as Count_of_highest_spending_customers from 
employee as e join 
(Select i.customer_id as Customer_id,c.employee_id , Sum(i.total) as Revenue  from invoice as i
join customer as c on c.customer_id=i.customer_id
group by i.customer_id,c.employee_id  order by i.Customer_id desc limit 10 ) Cu 
on cu.employee_id=e.employee_id
group by e.employee_id ,e.first_name order by count(cu.customer_id) desc;

---What is the average number of customers per employee?
Select count(distinct customer_id)/Count(distinct employee_id) as Avg_no_of_Customer_per_employee 
from Customer ;

---6.Geographic Trends
---Which countries or cities have the highest number of customers?
Select Country, Count(Customer_id) as Customers_count  from Customer
group by country order by customers_count desc limit 5;

---Are there any underserved geographic regions (high users, low sales)?
Select c.Country as Country,count(distinct c.Customer_id ) as Customers ,round(Sum(i.total):: numeric,2) as revenue ,
round((Sum(i.total)/count(distinct c.Customer_id ))::numeric,2) As Avg_per_cust
from invoice as i join customer as c on i.customer_id=c.customer_id
group by c.country order by count(distinct c.Customer_id ) desc, revenue Asc;
------------------------------------------------------------------------------------------------------------
----.Which countries have the most Invoices?

Select billing_country as country ,Count(invoice) as invoices_count from invoice 
group by country order by invoices_count desc limit 10;

-- What are top 3 values of total invoice?
Select invoice_id,round(total:: numeric,2) as Amount from invoice order by total 
desc limit 3;

--- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--     Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.
Select billing_city as City, round(sum(total)::numeric,2) as revenue from invoice
group by city order by revenue  desc limit 1;

--- Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A.


 SELECT DISTINCT
    c.email AS email_id,
    c.first_name,
    c.last_name
FROM customer c
JOIN invoice i 
    ON i.customer_id = c.customer_id
JOIN invoice_line l 
    ON i.invoice_id = l.invoice_id
JOIN track t 
    ON t.track_id = l.track_id
JOIN genre g 
    ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;


---Q7. Let's invite the artists who have written the most rock music in our dataset. 
--     Write a query that returns the Artist name and total track count of the top 10 rock bands.


SELECT 
    ar.name AS artist_name,
    COUNT(t.track_id) AS total_rock_tracks
FROM artist ar
JOIN album al 
    ON ar.artist_id = al.artist_id
JOIN track t 
    ON al.album_id = t.album_id
JOIN genre g 
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY total_rock_tracks DESC
LIMIT 10;



--Return all the track names that have a song length longer than the average song length. 
--     Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
SELECT 
    name,
    milliseconds AS duration_in_milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) 
    FROM track
)
ORDER BY duration_in_milliseconds DESC;

---Find how much amount spent by each customer on artists. Write a query to return the customer name, artist name, and total spent.
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    ar.name AS artist_name,
    ROUND(SUM(l.unit_price * l.quantity)::numeric, 2) AS total_spent
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
JOIN invoice_line l 
    ON i.invoice_id = l.invoice_id
JOIN track t 
    ON l.track_id = t.track_id
JOIN album al 
    ON t.album_id = al.album_id
JOIN artist ar 
    ON al.artist_id = ar.artist_id
GROUP BY customer_name, ar.name
ORDER BY customer_name, total_spent DESC;

---We want to find out the most popular music Genre for each country.
WITH country_genre AS (
    SELECT 
        i.billing_country AS country,
        g.name AS genre_name,
        COUNT(l.invoice_line_id) AS purchase_count
    FROM invoice i
    JOIN invoice_line l 
        ON i.invoice_id = l.invoice_id
    JOIN track t 
        ON l.track_id = t.track_id
    JOIN genre g 
        ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.name
)

SELECT country, genre_name, purchase_count
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY country 
               ORDER BY purchase_count DESC
           ) AS rnk
    FROM country_genre
) ranked
WHERE rnk = 1
ORDER BY country;


WITH country_customer AS (
    SELECT 
        i.billing_country AS country,
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        round(SUM(i.total)::numeric,2) AS total_spent
    FROM invoice i
    JOIN customer c 
        ON i.customer_id = c.customer_id
    GROUP BY i.billing_country, c.customer_id, customer_name
)

SELECT country, customer_name, total_spent
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY country
               ORDER BY total_spent DESC
           ) AS rnk
    FROM country_customer
) ranked
WHERE rnk = 1
ORDER BY country;

---Who are the most popular artists?
SELECT 
    ar.name AS artist_name,
    COUNT(l.track_id) AS total_tracks_sold
FROM invoice_line l
JOIN track t 
    ON l.track_id = t.track_id
JOIN album al 
    ON t.album_id = al.album_id
JOIN artist ar 
    ON al.artist_id = ar.artist_id
GROUP BY ar.artist_id, ar.name
ORDER BY total_tracks_sold DESC
LIMIT 10;

---Q13. Which is the most popular song?
SELECT 
    t.name AS track_name,
    COUNT(l.track_id) AS times_purchased
FROM invoice_line l
JOIN track t 
    ON l.track_id = t.track_id
GROUP BY t.track_id, t.name
ORDER BY times_purchased DESC
LIMIT 1;

--- What are the average prices of different types of music?
SELECT 
    g.name AS genre_name,
    ROUND(AVG(t.unit_price)::numeric, 2) AS avg_price
FROM track t
JOIN genre g 
    ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.name
ORDER BY avg_price DESC;

--- What are the most popular countries for music purchases?
SELECT 
    i.billing_country AS country,
    COUNT(l.track_id) AS total_tracks_purchased
FROM invoice i
JOIN invoice_line l 
    ON i.invoice_id = l.invoice_id
GROUP BY i.billing_country
ORDER BY total_tracks_purchased DESC;



