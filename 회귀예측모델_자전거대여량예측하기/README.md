# 자전거 수요 예측 모델 개발 프로젝트 (Bike Sharing Demand Prediction)

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python)](https://www.python.org)
[![Jupyter Notebook](https://img.shields.io/badge/Jupyter-Notebook-orange?logo=jupyter)](https://jupyter.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 프로젝트 소개 (Project Overview)

이 프로젝트는 캐글(Kagle)의 **[Bike Sharing Demand](https://www.kaggle.com/c/bike-sharing-demand/data?select=train.csv)** 데이터를 활용하여, 특정 시간대의 자전거 대여량을 예측하는 머신러닝 모델을 개발하는 것을 목표로 합니다. EDA, 피처 엔지니어링, 모델 비교 및 하이퍼파라미터 튜닝의 전 과정을 거쳐 최적의 예측 모델을 구축했습니다.

최종적으로 **LightGBM (LGBM) 모델**을 사용하여 **Test Set 기준 RMSE 36.61, R² 0.96**의 높은 예측 성능을 달성했습니다.

***

## 기술 스택 (Tech Stack)

프로젝트에 사용된 주요 라이브러리와 도구는 다음과 같습니다.

* **데이터 처리 및 분석:** `Pandas`, `NumPy`
* **시각화:** `Matplotlib`, `Seaborn`
* **머신러닝 모델:**
    * `Scikit-learn`: `LinearRegression`, `RandomForestRegressor`, `GradientBoostingRegressor`
    * `XGBoost`: `XGBRegressor`
    * `LightGBM`: `LGBMRegressor`
* **모델 평가 및 튜닝:** `Scikit-learn`: `train_test_split`, `cross_val_score`, `GridSearchCV`, `RandomizedSearchCV`, `mean_squared_error`, `r2_score`, `mean_squared_log_error`
* **개발 환경:** `Jupyter Notebook`

***

## 프로젝트 수행 과정 (Workflow)

### 1. 데이터 탐색 (Exploratory Data Analysis)

모델링에 앞서 데이터의 특성과 변수 간의 관계를 파악하기 위해 시각화를 포함한 EDA를 수행했습니다.

* **주요 인사이트:**
    * 대여량(`count`)은 **출퇴근 시간(오전 8시, 오후 5-6시)**에 뚜렷한 피크를 보입니다.
    * 월별/계절별 주기성이 있으며, **연도(year)**가 증가함에 따라 전반적인 대여량이 상승하는 추세가 확인되었습니다.
    * 타겟 변수인 `count`의 분포가 오른쪽으로 크게 치우쳐져 있어, 모델 성능 개선을 위해 **로그 변환(Log Transformation)** 적용을 고려했습니다.

<p align="center">
  <img src="https://github.com/user-attachments/assets/b2f2f02e-1913-4cc1-aada-34a56540fe04" width="32%">
  &nbsp;
  <img src="https://github.com/user-attachments/assets/5ff47e25-4f94-4e79-9c42-bd1ee424ba6f" width="32%">
  &nbsp;
  <img src="https://github.com/user-attachments/assets/63729af3-4200-4bb7-90db-4770140edb9a" width="32%">
</p>

### 2. 데이터 전처리 및 피처 엔지니어링

모델의 예측 성능을 높이기 위해 다음과 같은 전처리 및 피처 엔지니어링 과정을 거쳤습니다.

* **날짜 데이터 파싱:** `datetime` 컬럼에서 `year`, `month`, `day`, `hour`, `weekday` 정보를 추출하여 새로운 변수로 추가했습니다.
* **타겟 변수 처리:**
    * EDA 단계에서 `count` 변수의 분포가 왜곡된 것을 확인하고 로그 변환을 테스트했습니다.
    * 하지만 실제 실험 결과, RandomForest, XGBoost, LGBM과 같은 트리 기반 모델들은 타겟 변수의 분포에 강인한 모습을 보였습니다.
    * 오히려 **원본 타겟을 사용했을 때 더 나은 성능(RMSE, R²)을 기록**하여 최종 모델은 **원본 타겟(`count`)을 그대로 사용**하기로 결정했습니다.
* **이상치 제거:** 샘플이 1개뿐인 `weather = 4` (악천후) 데이터를 이상치로 간주하여 제거했습니다.
* **피처 선택 (Feature Selection):**
    * `casual`, `registered`는 타겟 변수인 `count`와 직접적인 관계가 있어 제거했습니다.
    * 초기 랜덤 포레스트 모델의 **변수 중요도(Feature Importance)**를 기반으로 중요도가 낮은 `holiday`, `atemp`, `day` 등의 변수를 제거하여 모델을 단순화하고 성능을 개선했습니다.

### 3. 모델링 및 평가 (Modeling & Evaluation)

5가지 기본 모델의 성능을 교차 검증으로 비교한 후, 상위 모델들의 하이퍼파라미터 튜닝을 진행하여 최종 모델을 선정했습니다.

* **초기 5개 모델 성능 비교 (테스트 데이터 기준):**

| 모델                 | RMSE   | R²     | RMSLE  |
| :------------------- | :----- | :----- | :----- |
| LinearRegression     | 143.59 | 0.3956 | 1.3063 |
| RandomForest         | 42.30  | 0.9475 | **0.3200** |
| GradientBoosting     | 70.02  | 0.8563 | 0.7120 |
| **XGBRegressor** | **38.78** | **0.9559** | 0.4504 |
| **LGBMRegressor**      | 40.42  | 0.9521 | 0.4446 |

* **모델 선택 과정:**
    초기 5개 모델 비교 결과, **XGBoost**와 **LGBM**이 R² 점수에서 가장 높은 성능을 보였습니다.  R²가 높고 RMSE가 낮은 XGBRegressor와 LGBMRegressor를 채택하여 하이퍼 파라미터 조정하였습니다.
    그리고 XGB와 비슷한 성능을 가지고 빠른 학습 속도 장점을 지닌 LGBM을 선정하였습니다.

* **최종 튜닝 모델 성능 비교 (테스트 데이터 기준):**

| 모델                   | 하이퍼파라미터 요약                                                                                                                                                              | CV RMSE     | Test RMSE   | R² 점수      | RMSLE  |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ----------- | ---------- | ------ |
| **XGBRegressor**     | `learning_rate=0.1`, `max_depth=5`, `n_estimators=700`, `subsample=0.8`                                                                                                 | 37.6702     | 37.6436     | 0.9585     | 0.4762 |
| **LGBM #1**          | `learning_rate=0.05`, `max_depth=20`, `n_estimators=500`, `num_leaves=50`                                                                                               | 37.3254     | 37.5303     | 0.9587     | 0.4038 |
| **LGBM #2**          | `learning_rate=0.05`, `max_depth=16`, `n_estimators=650`, `num_leaves=50`                                                                                               | 37.1475     | 37.2402     | 0.9593     | 0.4126 |
| **LGBM Final Model** | `learning_rate=0.05`, `max_depth=15`, `n_estimators=650`, `num_leaves=60`, `min_child_samples=10`, <br>`feature_fraction=0.7`, `bagging_fraction=0.9`, `bagging_freq=5` | **36.1635** | **36.6122** | **0.9607** | 0.4201 |


* **변수 중요도 (Feature Importance):** 피처 선택의 근거로 활용된 초기 랜덤 포레스트 모델의 변수 중요도입니다. `hour`가 예측에 가장 큰 영향을 미치는 변수임을 확인했습니다.
    <img width="877" height="544" alt="Image" src="https://github.com/user-attachments/assets/120c10e6-b6c5-464e-95fc-ebd122ad6e10" />

***

## 결론 및 요약 (Conclusion & Summary)

* **결론:** 다양한 모델 중 **하이퍼파라미터 튜닝을 거친 LightGBM 모델이 Test RMSE 36.61, R² 0.96**으로 가장 우수한 성능을 보였습니다.
* **주요 성공 요인:**
    * `datetime` 변수에서 `hour`, `year` 등 핵심 파생 변수를 생성한 것이 성능 향상에 결정적인 역할을 했습니다.
    * 변수 중요도를 기반으로 한 체계적인 피처 선택이 모델의 효율성과 정확도를 높였습니다.
    * 비선형 관계와 상호작용을 잘 학습하는 부스팅 계열 모델(LGBM, XGBoost)이 선형 모델보다 월등한 성능을 보였습니다.

***

## ✒️ 작성자 (Author)

* ` kiedz `
