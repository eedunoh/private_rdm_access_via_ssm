

-- select your preferred database
USE exploratoryDB;



-- create a table in the database
DROP TABLE IF EXISTS movie_data;

CREATE TABLE movie_data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(50),
    movie_title VARCHAR(100),
    genre VARCHAR(50),
    watch_time_minutes INT,
    watch_date DATETIME,
    device_type VARCHAR(50),
    location VARCHAR(100),
    comment TEXT
);



-- insert values in the newly created table
INSERT INTO movie_data (
    user_id, movie_title, genre, watch_time_minutes,
    watch_date, device_type, location, comment
)
SELECT
    CONCAT('user_', LPAD(FLOOR(RAND() * 1000), 4, '0')) AS user_id,
    ELT(FLOOR(1 + (RAND() * 10)),
        'Inception', 'Titanic', 'Avatar', 'Moana', 'Matrix',
        'Frozen', 'Up', 'The Godfather', 'Interstellar', 'Coco') AS movie_title,
    ELT(FLOOR(1 + (RAND() * 5)),
        'Sci-Fi', 'Animation', 'Drama', 'Action', 'Crime') AS genre,
    FLOOR(80 + (RAND() * 100)) AS watch_time_minutes,
    NOW() - INTERVAL FLOOR(RAND() * 100) DAY AS watch_date,
    ELT(FLOOR(1 + (RAND() * 4)),
        'Smart TV', 'Phone', 'Laptop', 'Tablet') AS device_type,
    ELT(FLOOR(1 + (RAND() * 6)),
        'New York, USA', 'London, UK', 'Berlin, Germany',
        'Lagos, Nigeria', 'Toronto, Canada', 'Tokyo, Japan') AS location,
    ELT(FLOOR(1 + (RAND() * 5)),
        'Great movie!', 'Too long', 'Watched twice', 'Recommended', 'Loved it') AS comment
FROM
    (SELECT 1 FROM dual UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
     UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) t1,
    (SELECT 1 FROM dual UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
     UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) t2
LIMIT 100;



-- interract with the table using SQL
SELECT 
* 
, Row_number() Over (Partition By movie_title Order By watch_date asc) As movie_per_user_order
FROM `movie_data`
