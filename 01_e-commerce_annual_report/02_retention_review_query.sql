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

-- 2. 클래식 리텐션 분석
SELECT first_order_month
     , COUNT(DISTINCT customer_id) AS cnt_month0
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) = order_month THEN customer_id END) AS cnt_month1
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) = order_month THEN customer_id END) AS cnt_month2
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) = order_month THEN customer_id END) AS cnt_month3
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) = order_month THEN customer_id END) AS cnt_month4
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) = order_month THEN customer_id END) AS cnt_month5
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) = order_month THEN customer_id END) AS cnt_month6
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) = order_month THEN customer_id END) AS cnt_month7
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) = order_month THEN customer_id END) AS cnt_month8
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) = order_month THEN customer_id END) AS cnt_month9
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) = order_month THEN customer_id END) AS cnt_month10
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) = order_month THEN customer_id END) AS cnt_month11
FROM order_records
GROUP BY 1;

SELECT first_order_month
     , COUNT(DISTINCT customer_id) AS cnt_month0
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month1
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month2
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month3
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month4
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month5
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month6
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month7
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month8
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month9
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month10
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) = order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month11
FROM order_records
GROUP BY 1;

SELECT order_month
     , cnt_orders
     , ROUND(avg_discnt * 100, 2) AS avg_discnt
     , ROUND(avg_discnt * 100 / SUM(avg_discnt) OVER (), 2) AS pct_avg_discnt
FROM (SELECT order_month
		   , COUNT(DISTINCT customer_id) AS cnt_orders
		   , AVG(discount) AS avg_discnt
      FROM order_records
      WHERE first_order_month = '2020-08-01'
      GROUP BY 1) tbl;

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
), aug_records AS (
SELECT order_month
      , aug_orders AS cnt_aug_orders
      , ROUND(aug_orders * 100 / SUM(aug_orders) OVER (), 2) AS pct_aug_orders
FROM (SELECT order_month
           , COUNT(DISTINCT customer_id) AS aug_orders
      FROM order_records
      WHERE first_order_month = '2020-08-01' AND first_order_month != order_month
      GROUP BY 1) tbl
)
SELECT order_month
     , cnt_total_orders
     , ROUND(cnt_total_orders * 100 / SUM(cnt_total_orders) OVER (), 2) AS pct_total_orders
     , cnt_aug_orders
     , pct_aug_orders
FROM (SELECT o.order_month
           , COUNT(DISTINCT o.customer_id) AS cnt_total_orders
           , cnt_aug_orders
           , pct_aug_orders
      FROM order_records o 
      INNER JOIN aug_records a ON o.order_month = a.order_month
      WHERE o.order_month >= '2020-09-01'
      GROUP BY 1) tbl;

-- 3. 롤링 리텐션 분석
SELECT first_order_month
     , COUNT(DISTINCT customer_id) AS cnt_month0
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) <= order_month THEN customer_id END) AS cnt_month1
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) <= order_month THEN customer_id END) AS cnt_month2
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) <= order_month THEN customer_id END) AS cnt_month3
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) <= order_month THEN customer_id END) AS cnt_month4
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) <= order_month THEN customer_id END) AS cnt_month5
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) <= order_month THEN customer_id END) AS cnt_month6
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) <= order_month THEN customer_id END) AS cnt_month7
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) <= order_month THEN customer_id END) AS cnt_month8
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) <= order_month THEN customer_id END) AS cnt_month9
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) <= order_month THEN customer_id END) AS cnt_month10
     , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) <= order_month THEN customer_id END) AS cnt_month11
FROM order_records
GROUP BY 1;

SELECT first_order_month
     , COUNT(DISTINCT customer_id) AS cnt_month0
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month1
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month2
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month3
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month4
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month5
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month6
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month7
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month8
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month9
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month10
     , ROUND(COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) <= order_month THEN customer_id END) * 100 / COUNT(DISTINCT customer_id), 2) AS pct_month11
FROM order_records
GROUP BY 1;
