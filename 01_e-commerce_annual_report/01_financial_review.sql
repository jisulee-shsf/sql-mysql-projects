-- 1. 임시 테이블 생성
WITH order_records AS (
SELECT r.customer_id
     , r.category
     , r.sub_category
     , r.sales
     , r.discount
     , DATE_FORMAT(r.order_date, '%Y-%m-01') AS order_month
     , DATE_FORMAT(r.order_date, '%Y-%m-%d') AS order_date
     , DATE_FORMAT(c.first_order_date, '%Y-%m-01') AS first_order_month
     , DATE_FORMAT(c.first_order_date, '%Y-%m-%d') AS first_order_date
     , CASE WHEN DATE_FORMAT(c.first_order_date, '%Y-%m-01') != DATE_FORMAT(r.order_date, '%Y-%m-01') THEN 1 ELSE 0 END AS reorder
FROM records r
INNER JOIN customer_stats c ON r.customer_id = c.customer_id
)

-- 2-1. 월별 / 분기별 매출 분석
SELECT order_month
     , ROUND(sum_sales, 2) AS monthly_sales
     , ROUND(sum_sales * 100 / SUM(sum_sales) OVER (), 2) AS pct_monthly_sales
     , ROUND(SUM(sum_sales) OVER (PARTITION BY QUARTER(order_month)), 2) AS quarterly_sales
     , ROUND(SUM(sum_sales) OVER (PARTITION BY QUARTER(order_month)) * 100 / SUM(sum_sales) OVER (), 2) AS pct_quarterly_sales
FROM (SELECT order_month
           , SUM(sales) AS sum_sales
      FROM order_records
      GROUP BY 1) tbl;

-- 2-2. 월별 / 분기별 매출 분석 
SELECT order_month
     , ROUND(sum_sales, 2) AS monthly_sales
     , ROUND(sum_sales * 100 / SUM(sum_sales) OVER (), 2) AS pct_monthly_sales
     , DENSE_RANK() OVER (ORDER BY sum_sales DESC) AS ranking
FROM (SELECT order_month
           , SUM(sales) AS sum_sales
      FROM order_records
      GROUP BY 1) tbl;
     
 -- 3-1. 요일별 매출 분석
SELECT order_month
     , ROUND(SUM(CASE WHEN DAYNAME(order_date) LIKE 'mon%' THEN sales END) * 100 / SUM(sales), 2) AS pct_mon_sales
     , ROUND(SUM(CASE WHEN DAYNAME(order_date) LIKE 'tue%' THEN sales END) * 100 / SUM(sales), 2) AS pct_tue_sales
     , ROUND(SUM(CASE WHEN DAYNAME(order_date) LIKE 'wed%' THEN sales END) * 100 / SUM(sales), 2) AS pct_wed_sales
     , ROUND(SUM(CASE WHEN DAYNAME(order_date) LIKE 'thu%' THEN sales END) * 100 / SUM(sales), 2) AS pct_thu_sales
     , ROUND(SUM(CASE WHEN DAYNAME(order_date) LIKE 'fri%' THEN sales END) * 100 / SUM(sales), 2) AS pct_fri_sales
     , ROUND(SUM(CASE WHEN DAYNAME(order_date) LIKE 'sat%' THEN sales END) * 100 / SUM(sales), 2) AS pct_sat_sales
     , ROUND(SUM(CASE WHEN DAYNAME(order_date) LIKE 'sun%' THEN sales END) * 100 / SUM(sales), 2) AS pct_sun_sales
FROM order_records
GROUP BY 1;

-- 3-2. 요일별 매출 분석 
SELECT order_month
     , ROUND(SUM(CASE WHEN WEEKDAY(order_date) BETWEEN 0 AND 4 THEN sales END) * 100 / SUM(sales), 2) AS pct_mon_to_fri_sales
     , ROUND(SUM(CASE WHEN WEEKDAY(order_date) BETWEEN 5 AND 6 THEN sales END) * 100 / SUM(sales), 2) AS pct_sat_to_sun_sales
FROM order_records
GROUP BY 1;
     
-- 4. 카테고리별 매출 분석  
SELECT category
     , ROUND(SUM(sum_sales) OVER (PARTITION BY category), 2) AS  category_sales
     , ROUND(SUM(sum_sales) OVER (PARTITION BY category) * 100 / SUM(sum_sales) OVER (), 2) AS pct_category_sales
     , sub_category
     , ROUND(sum_sales, 2) AS sub_category_sales
     , ROUND(sum_sales * 100 / SUM(sum_sales) OVER (PARTITION BY category), 2) AS pct_sub_category_sales
FROM (SELECT category 
           , sub_category
           , SUM(sales) AS sum_sales
      FROM order_records
      GROUP BY category, sub_category) tbl
ORDER BY pct_category_sales DESC, pct_sub_category_sales DESC;

-- 5-1. 서브 카테고리별 매출 분석  
SELECT sub_category
     , cnt_orders
     , ROUND(sum_sales / cnt_orders, 2) AS per_sales
     , ROUND(sum_sales, 2) AS sub_category_sales
     , ROUND(sum_sales * 100 / SUM(sum_sales) OVER (), 2) AS pct_sub_category_sales
     , DENSE_RANK() OVER (ORDER BY sum_sales DESC) AS ranking_sales
     , ROUND(sum_discnt, 2) AS sub_category_discnt
     , ROUND(sum_discnt * 100 / SUM(sum_discnt) OVER (), 2) AS pct_sub_category_discnt
     , CASE WHEN sum_discnt >= AVG(sum_discnt) OVER() THEN 1 ELSE 0 END AS above_avg_discnt
     , DENSE_RANK() OVER (ORDER BY sum_discnt DESC) AS ranking_discnt
FROM (SELECT sub_category
           , SUM(sales) AS sum_sales
           , SUM(discount) AS sum_discnt
           , COUNT(customer_id) AS cnt_orders
      FROM order_records
      GROUP BY 1) tbl
ORDER BY ranking_sales;

-- 5-2. 서브 카테고리별 매출 분석  
SELECT sub_category
     , ROUND(sum_discnt, 2) AS sub_category_discnt
     , DENSE_RANK() OVER (ORDER BY sum_discnt DESC) AS ranking_discnt
     , cnt_orders
     , DENSE_RANK() OVER (ORDER BY cnt_orders DESC) AS ranking_orders
     , ROUND(sum_sales, 2) AS sub_category_sales
     , DENSE_RANK() OVER (ORDER BY sum_sales DESC) AS ranking_sales
FROM (SELECT sub_category
           , SUM(sales) AS sum_sales
           , SUM(discount) AS sum_discnt
           , COUNT(customer_id) AS cnt_orders
      FROM order_records
      GROUP BY 1) tbl
ORDER BY ranking_sales;
