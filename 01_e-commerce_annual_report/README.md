####
## Topic
- E-Commerce dataset을 활용한 Annual report 작성
####
## Objectives
- SQL 고급 문법을 활용해 복잡한 연산의 데이터를 추출하는 쿼리 작성
- 추출된 데이터 결과를 Python 라이브러리로 다수의 데이터 시각화 진행
- AARRR / Cohort / Retention 분석을 반영한 논지 전개
####
## Process
- SQL 고급 문법을 활용해 복잡한 연산의 데이터를 추출하는 쿼리 작성
     <div align="left"><img src="https://img.shields.io/badge/[ MySQL ]-JOIN / GROUP BY / Pivot Table / SubQuery / Window Function-4479A1"/><br>  

- 추출된 데이터 결과를 Python 라이브러리로 다수의 데이터 시각화 진행

     <div align="left"><img src="https://img.shields.io/badge/[ Python ]-pandas / matplotlib / seaborn-3776AB"/>
     <img src="https://img.shields.io/badge/[ Data Visualization ]-catplot / histplot / lineplot / heatmap / pie-3776AB"/> 

- AARRR / Cohort / Retention / Correlation 분석을 반영한 논지 전개

     <div align="left"><img src="https://img.shields.io/badge/[ Analysis ]-Classic Retention / Rolling Retention / Correlation-darkgreen"/><br>
####
## Timeline
- 221107~220727 : CV 관련 사전 실습 진행 > 'dl-cv-practice' repository 참고
- 220728~220730 : domain 파악을 위한 서칭 및 진행 pipeline 설정
- 220731~220801 : 1차 코드 작성 완료
- 220802 : 강사님과 피드백 면담 진행 / 최종 코드 작성 완료
- 220803~220804 : 발표자료 작성 및 제출
- 220805 : 발표 진행
####
## Contents
- Download the dataset : Kaggle API를 활용해 dataset 다운로드
- Explore the data : image / mask 경로 추출 로직 함수화 및 시각화 진행
- K-Means clustering : cluster center에 기반한 clustering 진행
- Create a dataframe : image_id / image & mask 경로 / cluster 정보 포함된 dataframe 생성
- Visualize the data : cluster(stainded & bright-field & fluorescence)에 따른 시각화 진행
- Find and draw contours : 단일 mask에 대한 외곽선 정보 추출 연습
- Get annotation information : 전체 mask의 polygon & bounding box 정보 추출 로직 함수화
- Convert the dataset to COCO format : 추출된 annotation 정보를 활용해 COCO format 변환 로직 함수화
- Visualize the data using pycocotools : COCO API를 활용해 instance segementation 시각화 진행
<img src="https://user-images.githubusercontent.com/109773795/183776882-572ee620-287c-4867-8b63-01ac0c32370c.png" width="950" height="150"/>
<img src="https://user-images.githubusercontent.com/109773795/183776651-838bf36e-336c-4bb2-86e0-2031f8f1a663.png" width="950" height="150"/>

####
## Afterthoughts
- domain knowledge가 없음에도 불구하고, 새롭게 접하는 data를 세부적으로 분석하는 과정이 매우 흥미로웠습니다.
- COCO dataset 변환 과정을 통해, COCO format의 다양한 annotation 정보를 상세히 이해할 수 있었습니다.
- annotation 정보를 바탕으로, instance segmentation 진행 과정을 다양하게 실습할 수 있었습니다.
####
## Reference
- [[Kaggle] United States E-Commerce records 2020](https://www.kaggle.com/datasets/ammaraahmad/us-ecommerce-record-2020)
####
