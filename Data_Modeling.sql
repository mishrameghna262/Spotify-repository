CREATE TABLE dim_song (
    song_id INT,
    title NVARCHAR(500),
    artist NVARCHAR(500)
);

with cte as (select distinct title,artist from spotify_sample_balanced)
insert into dim_song(song_id,title,artist)
select ROW_NUMBER() over(order by title,artist) as song_id,
title,artist from cte

SELECT COUNT(*) AS total_songs
FROM dim_song;

SELECT
    COUNT(*) AS rows_in_dim_song,
    COUNT(DISTINCT CONCAT(title, '|', artist)) AS distinct_song_combinations
FROM dim_song;

SELECT title, artist, COUNT(*) AS cnt
FROM dim_song
GROUP BY title, artist
HAVING COUNT(*) > 1;


CREATE TABLE dim_date (
    date_id INT,
    date DATE,
    year INT,
    month INT,
    quarter INT
);



WITH cte AS (
    SELECT DISTINCT
        date AS dt,
        YEAR(date) AS yr,
        MONTH(date) AS mn,
        DATEPART(QUARTER, date) AS qtr
    FROM spotify_sample_balanced
)
INSERT INTO dim_date (date_id, date, year, month, quarter)
SELECT
    ROW_NUMBER() OVER (ORDER BY dt) AS date_id,
    dt,
    yr,
    mn,
    qtr
FROM cte;



SELECT COUNT(*) AS total_dates
FROM dim_date;



SELECT TOP 10 *
FROM dim_date
ORDER BY date_id;


CREATE TABLE dim_region (
    region_id INT,
    region NVARCHAR(100)
);


WITH cte AS (
    SELECT DISTINCT region
    FROM spotify_sample_balanced
)
INSERT INTO dim_region (region_id, region)
SELECT
    ROW_NUMBER() OVER (ORDER BY region) AS region_id,
    region
FROM cte;


SELECT COUNT(*) AS total_regions
FROM dim_region;


SELECT *
FROM dim_region
ORDER BY region_id;


CREATE TABLE dim_chart (
    chart_id INT,
    chart NVARCHAR(50)
);



WITH cte AS (
    SELECT DISTINCT chart
    FROM spotify_sample_balanced
)
INSERT INTO dim_chart (chart_id, chart)
SELECT
    ROW_NUMBER() OVER (ORDER BY chart) AS chart_id,
    chart
FROM cte;


SELECT *
FROM dim_chart
ORDER BY chart_id;


CREATE TABLE fact_chart (
    song_id INT,
    date_id INT,
    region_id INT,
    chart_id INT,
    rank SMALLINT,
    trend NVARCHAR(50),
    streams BIGINT
);


SELECT
    s.title,
    s.artist,
    ds.song_id
FROM spotify_sample_balanced s
JOIN dim_song ds
    ON s.title = ds.title
    AND s.artist = ds.artist;


SELECT COUNT(*) AS matched_rows
FROM spotify_sample_balanced s
JOIN dim_song ds
    ON s.title = ds.title
    AND s.artist = ds.artist;



SELECT
    s.date,
    dd.date_id
FROM spotify_sample_balanced s
JOIN dim_date dd
    ON s.date = dd.date;

    SELECT COUNT(*) AS matched_rows
FROM spotify_sample_balanced s
JOIN dim_date dd
    ON s.date = dd.date;



SELECT
    s.region,
    dr.region_id
FROM spotify_sample_balanced s
JOIN dim_region dr
    ON s.region = dr.region;



select count(*) as matched_rows
from spotify_sample_balanced s join dim_region dr
on s.region=dr.region


SELECT
    s.chart,
    dc.chart_id
FROM spotify_sample_balanced s
JOIN dim_chart dc
    ON s.chart = dc.chart;




select count(*) as matched_rows
from spotify_sample_balanced s join dim_chart dc
on s.chart=dc.chart


SELECT
    ds.song_id,
    dd.date_id,
    dr.region_id,
    dc.chart_id,
    s.rank,
    s.trend
FROM spotify_sample_balanced s
JOIN dim_song ds
    ON s.title = ds.title
    AND s.artist = ds.artist
JOIN dim_date dd
    ON s.date = dd.date
JOIN dim_region dr
    ON s.region = dr.region
JOIN dim_chart dc
    ON s.chart = dc.chart;



INSERT INTO fact_chart
    (song_id, date_id, region_id, chart_id, rank, trend, streams)
SELECT
    ds.song_id,
    dd.date_id,
    dr.region_id,
    dc.chart_id,
    s.rank,
    s.trend,
    s.streams
FROM spotify_sample_balanced s
JOIN dim_song ds
    ON s.title = ds.title
    AND s.artist = ds.artist
JOIN dim_date dd
    ON s.date = dd.date
JOIN dim_region dr
    ON s.region = dr.region
JOIN dim_chart dc
    ON s.chart = dc.chart;


select count(*) from fact_chart


SELECT
    song_id,
    date_id,
    region_id,
    chart_id,
    COUNT(*) AS cnt
FROM fact_chart
GROUP BY
    song_id,
    date_id,
    region_id,
    chart_id
HAVING COUNT(*) > 1;


select * from dim_region where region_id=34

select * from dim_Song where song_id=24554

select * from spotify_sample_balanced where title='No Roots' and region='Italy'


SELECT
    COUNT(*) AS fact_rows,
    COUNT(song_id) AS song_ids,
    COUNT(date_id) AS date_ids,
    COUNT(region_id) AS region_ids,
    COUNT(chart_id) AS chart_ids,
    COUNT(rank) AS ranks,
    COUNT(trend) AS trends,
    COUNT(streams) AS streams
FROM fact_chart;


SELECT
    dc.chart,
    COUNT(*) AS cnt
FROM fact_chart fc
JOIN dim_chart dc
    ON fc.chart_id = dc.chart_id
GROUP BY dc.chart;