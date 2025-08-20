import streamlit as st
import pandas as pd
import plotly.express as px

# datafile.csv > load > table 출력 > px.box() > st.plotly_chart()

datafile = st.file_uploader("CSV 파일 선택", type="csv")

if datafile is not None:
    df = pd.read_csv(datafile)
    
    st.write("### 데이터 테이블")
    st.dataframe(df) 
  
    st.write("### Box Plot")
    fig = px.box(
    df,
    x='Cylinders',                # x축: 실린더 수
    y='CO2 Emissions(g/km)',      # y축: CO2 배출량
    title='CO2 Emissions by Number of Cylinders'
    )
    st.plotly_chart(fig, use_container_width=True)