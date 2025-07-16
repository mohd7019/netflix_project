# 🎬 Netflix Movies & TV Shows SQL Analysis
![Database Schema Screenshot](/BrandAssets_Logos_01-Wordmark.jpg)

A comprehensive SQL project analyzing Netflix Movies and TV Shows using **PostgreSQL**. This project covers business-driven data analysis questions using advanced SQL techniques.

---

## 📊 Dataset Schema

**Table: `movies`**

| Column         | Data Type    | Description                           |
|----------------|-------------|---------------------------------------|
| show_id        | VARCHAR(5)  | Unique ID for each content item       |
| type           | VARCHAR(10) | 'Movie' or 'TV Show'                  |
| title          | VARCHAR(250)| Title of the content                  |
| director       | VARCHAR(550)| Director name(s)                      |
| casts          | VARCHAR(1050)| Cast list                            |
| country        | VARCHAR(550)| Country of production                 |
| date_added     | VARCHAR(55) | Date added to Netflix (string format) |
| release_year   | INT         | Year of release                       |
| rating         | VARCHAR(15) | Content rating                        |
| duration       | VARCHAR(15) | Duration (e.g. "90 min", "3 Seasons") |
| listed_in      | VARCHAR(250)| Genre or Category list                |
| description    | VARCHAR(550)| Brief description of the content      |

---

## 📈 Business Questions Solved

- ✅ **Total content count**
- ✅ **Distinct content types (Movie/TV Show)**
- ✅ **Number of Movies vs TV Shows**
- ✅ **Most common content ratings**
- ✅ **Content released in specific years (e.g. 2020)**
- ✅ **Top 5 countries producing the most content**
- ✅ **Longest movie on Netflix**
- ✅ **Content added in the last 5 years**
- ✅ **All content directed by ‘Rajiv Chilaka’**
- ✅ **TV Shows with more than 5 seasons**
- ✅ **Genre-wise content distribution**
- ✅ **Content release trends in India**
- ✅ **All Documentaries listing**
- ✅ **Content without director information**
- ✅ **Movies featuring ‘Salman Khan’ (last 10 years)**
- ✅ **Top 10 Indian actors by movie count**
- ✅ **Categorizing content as ‘good’ or ‘bad’ using description analysis**

---

## 🛠 SQL Techniques Used

- `COUNT()`, `MAX()`, `ROUND()`
- `GROUP BY`, `ORDER BY`, `LIMIT`
- `RANK()`, `ROW_NUMBER()` (Window Functions)
- `WITH` (Common Table Expressions)
- `SPLIT_PART()`, `UNNEST()`, `TRIM()`, `ILIKE`
- `CASE` statements
- `TO_DATE()`, `EXTRACT()`, `INTERVAL`
- Subqueries & CTEs

---

## 📂 Project Structure

```plaintext
project/
├── create_table.sql
├── netflix_analysis_queries.sql
├── README.md
└── screenshots/        # Optional folder for query result screenshots
