--CREATE DATABASE SpotifyAnalytics;

Use SpotifyAnalytics

CREATE TABLE raw_staging (
    title NVARCHAR(500),
    rank INT,
    chart_date DATE,
    artist NVARCHAR(500),
    url NVARCHAR(500),
    region NVARCHAR(100),
    chart NVARCHAR(50),
    trend NVARCHAR(50),
    streams BIGINT
);


select count(*) as total_rows from spotify_sample_balanced

SELECT TOP 10 *
FROM dbo.spotify_sample_balanced;


SELECT 
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM dbo.spotify_sample_balanced;


SELECT 
    chart,
    COUNT(*) AS row_count
FROM dbo.spotify_sample_balanced
GROUP BY chart;


SELECT
    COUNT(*) AS total_rows,
    COUNT(title) AS title_present,
    COUNT(artist) AS artist_present,
    COUNT(region) AS region_present,
    COUNT(chart) AS chart_present,
    COUNT(trend) AS trend_present,
    COUNT(streams) AS streams_present
FROM dbo.spotify_sample_balanced;




UPDATE dbo.spotify_sample_balanced
SET
    title = TRIM(title),
    artist = TRIM(artist),
    region = TRIM(region),
    chart = TRIM(chart),
    trend = TRIM(trend);


    select * from spotify_sample_balanced


--------------------------------sql analysis-------------------------------------------------------- 
   
--Spotify wants to understand how songs are distributed across the different trend categories. 
--How many records belong to each trend category? 
   select trend,count(*) as total_songs from spotify_sample_balanced
   group by trend order by total_songs desc

--Which regions have the most chart entries in our dataset?
   select region,count(*) as total_entries from spotify_sample_balanced
   group by region order by total_entries desc

--Which 10 regions have the highest average rank?
   with cte as(select region,avg(rank) as avg_rank from spotify_sample_balanced
   group by region)
   select top 10 region,avg_rank from cte order by avg_rank 

  -- alternative approach using dense_rank
  -- cte2 as(select * , DENSE_RANK() over(order by avg_rank) as rn from cte)
  -- select * from cte2 where rn<=10

--Among top200 chart entries, which 10 songs have accumulated the highest total number of streams in our dataset?
   with cte as(select title,artist,sum(streams) as total_streams
   from spotify_sample_balanced where chart='top200' group by title,artist )
   select top 10 title,artist,total_streams from cte order by total_streams desc

--Which 10 artists have the highest total streams across all their top200 chart entries in our dataset?
  select top 10 artist,sum(streams) as total_streams from spotify_sample_balanced
  where chart='top200' group by artist
  order by total_streams desc

--For each year, what was the total number of streams recorded in the top200 chart?
  select year(date) as yr,sum(streams) as total_streams from spotify_sample_balanced
  where chart='top200' group by year(date) order by year(date)

--For each year, how many distinct songs appeared in the top200 chart?
  select year(date) as yr,count(distinct title) as distinct_songs from spotify_sample_balanced
  where chart='top200' group by year(date) order by year(date)

--Which artists appeared with the greatest number of distinct songs in the top200 chart across our dataset?
  select top 10 artist,count(distinct title) as distinct_songs from spotify_sample_balanced
  where chart='top200' group by artist order by distinct_songs desc

 --Spotify wants to classify each top200 chart entry based on its rank:

/*Top 10 → rank 1–10
  Top 50 → rank 11–50
  Top 100 → rank 51–100
  Below 100 → rank 101–200

  Find how many chart entries fall into each rank category.*/

  SELECT
    CASE
        WHEN rank <= 10 THEN 'top10'
        WHEN rank <= 50 THEN 'top50'
        WHEN rank <= 100 THEN 'top100'
        ELSE 'Below 100'
    END AS rank_category,
    COUNT(*) AS total_entries
FROM spotify_sample_balanced
GROUP BY
    CASE
        WHEN rank <= 10 THEN 'top10'
        WHEN rank <= 50 THEN 'top50'
        WHEN rank <= 100 THEN 'top100'
        ELSE 'Below 100'
    END;

 --Spotify wants to know the average chart rank for each chart type (top200 vs viral50).

   select * from spotify_sample_balanced

   select chart, avg(rank) as avg_chart_rank from spotify_sample_balanced
   group by chart

--For each chart type, what is the total number of chart entries that moved up, 
--moved down, or stayed in the same position?

  select chart,trend,count(*) as no_of_chart_entries
  from spotify_sample_balanced 
  group by chart,trend


--Chart longevity — which songs have real staying power 

select top 10 title, artist, count(distinct date) as days_charted
from spotify_sample_balanced
where chart='top200'
group by title, artist
order by days_charted desc

--Cumulative streams over time 

with yearly as (
    select year(date) as yr, sum(streams) as yearly_streams
    from spotify_sample_balanced
    where chart='top200'
    group by year(date)
)
select yr, yearly_streams,
    sum(yearly_streams) over (order by yr rows between unbounded preceding and current row) as cumulative_streams
from yearly
order by yr


