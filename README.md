# Spotify Analytics

SQL Server and Power BI project analyzing Spotify chart trends, song performance, artists, and regional activity.

## Project Overview

In this project, I used SQL Server to model and analyze Spotify chart data and Power BI to build an interactive dashboard.

The analysis looks at song performance, artist presence, regional activity, chart movement, and trends over time.

## Dataset

**Source:** Spotify Charts dataset by Dhruvil Dave, available on Kaggle.

The original dataset is approximately 3.48 GB, so I used a 250,000-row sample for the project.

The sample covers:
- 2017–2021
- 70 regions
- Top 200 and Viral 50 charts
- 250,000 chart observations

## Data Model

The SQL Server database uses a star schema with:

- fact_chart
- dim_song
- dim_date
- dim_region
- dim_chart

## SQL Analysis

The analysis includes:

- Distribution of records by trend category
- Regions with the highest number of chart entries
- Top 10 regions by average chart rank
- Top 10 songs by cumulative streams in the Top 200 chart
- Top 10 artists by cumulative streams in the Top 200 chart
- Yearly total streams in the Top 200 chart
- Yearly number of distinct songs in the Top 200 chart
- Artists with the highest number of distinct songs in the Top 200 chart
- Distribution of Top 200 entries by rank category
- Average rank by chart type
- Chart movement by chart type
- Top songs by observed chart longevity
- Cumulative streams over time

## Power BI Dashboard

The dashboard has four pages:

1. **Overview** — overall streaming activity and chart movement
2. **Songs & Artists** — top songs, artists, and chart longevity
3. **Regional Trends** — regional chart activity and chart composition
4. **Song Deep Dive** — detailed analysis of a selected song

## Tools

- SQL Server
- SQL
- Power BI
- DAX

## Repository Structure

```text
Spotify-repository/
├── README.md
├── Data_Modeling.sql
├── Analysis.sql
│
└── Dashboard/
    ├── Spotify_Analytics.pbix
    └── screenshots/
        ├── overview.png
        ├── songs-artists.png
        ├── regional-trends.png
        └── song-deep-dive.png
