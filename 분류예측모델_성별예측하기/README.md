# 분류 모델 성능 비교 및 선정

본 프로젝트에서는 다양한 분류 모델을 학습하고, 성능을 비교하여 최종적으로 가장 우수한 모델을 선정하였습니다.

## 비교 대상 모델

- Logistic Regression
- Decision Tree Classifier
- Random Forest Classifier
- XGBoost Classifier

---

## 모델 성능 비교 결과

| 모델                    | Accuracy | Precision (Weighted) | Recall (Weighted) | F1-score (Weighted) |
|-------------------------|----------|-----------------------|--------------------|----------------------|
| Logistic Regression     | 0.62     | 0.59                  | 0.62               | 0.53                 |
| Decision Tree Classifier| 0.82     | 0.82                  | 0.82               | 0.82                 |
| **Random Forest Classifier** | **0.83** | **0.84**               | **0.83**            | **0.83**              |
| XGBoost Classifier      | 0.62     | 0.59                  | 0.62               | 0.53                 |

---

## 클래스별 세부 성능 (Random Forest 기준)

| 클래스 | Precision | Recall | F1-score |
|--------|-----------|--------|----------|
| 0      | 0.83      | 0.92   | 0.87     |
| 1      | 0.85      | 0.70   | 0.77     |

---

## 최종 선정 모델: `RandomForestClassifier`

### 선정 이유

- 모든 지표(Accuracy, Precision, Recall, F1-score)에서 **전반적으로 가장 우수한 성능**
- 두 클래스 모두에서 **균형 잡힌 예측 성능**
- 과적합 없이 안정적인 결과 도출

---

## 추가 제안

- 하이퍼파라미터 튜닝 (`GridSearchCV` 또는 `RandomizedSearchCV`)
- 클래스 불균형 완화 기법 적용
  - 예: `class_weight='balanced'`, `SMOTE`, `ADASYN` 등
- 특성 중요도 시각화를 통한 인사이트 도출


