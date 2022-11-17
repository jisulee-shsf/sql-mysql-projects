####
## 01. 데이터 분석 캠프 Week1
#### ► [01_where_nested_subquery_221007]
- Nested SubQuery인 WHERE절의 단일행 ・ 다중행 ・ 다중 컬럼 서브쿼리 출력 실습 
- 단일행 서브쿼리 - 비교 연산자와 1개의 데이터 값이 서브쿼리의 결괏값인 쿼리문 작성
- 다중행 서브쿼리 - 주요 연산자 IN과 다수의 값을 가진 1개의 컬럼이 서브쿼리의 결괏값인 쿼리문 작성
- 다중 컬럼 서브쿼리 - 주요 연산자 IN과 다수의 값을 가진 n개의 컬럼이 서브쿼리의 결괏값인 쿼리문 작성
#### ► [02_from_inline_view_subquery_221007]
- Inline View SubQuery인 FROM절의 서브쿼리를 WITH절 사용 여부에 따라 출력 실습
- WITH절의 경우, 다소 복잡한 FROM절의 서브쿼리를 임시 테이블로 설정해 쿼리의 가독성을 높이고 재사용의 장점을 가짐
- WITH절로 생성된 임시 테이블은 기존 테이블과 동일하게 JOIN 등의 다양한 구문 적용 가능
#### ► [03_select_scala_subquery_221007]
- Scala SubQuery인 SELECT절의 서브쿼리를 WHERE 조건식 여부에 따라 출력 실습
##
#### Nested SubQuery
``` SQL
SELECT column_name
FROM table_name
WHERE column_name [Operator] (SELECT column_name
                              FROM table_name 
                              WHERE condition);
```
#### Inline View SubQuery
``` SQL
SELECT column_name
FROM (SELECT column_name
      FROM table_name
      WHERE condition) AS alias_name
WHERE condition;
```
####  WITH
``` SQL
WITH alias_name1 AS (
...
), alias_nameN AS (
...
)
```
#### Scala SubQuery
``` SQL
SELECT column_name
    , (SELECT column_names 
       FROM table_name 
       WHERE condition)
FROM table_name
WHERE condition;
```
####
