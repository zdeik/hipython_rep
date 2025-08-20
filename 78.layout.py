import streamlit as st
import pandas as pd
import plotly.express as px


#layout 요소
# colums는 요소를 왼쪽 -> 오른쪽으로 배치할 수 있다.
col1,col2,col3 = st.columns(3)

with col1:
    st.metric(
    '오늘의 날씨',
    value='35도',
    delta='+3'
    )

with col2:
    st.metric(
    '오늘의 미세먼지',
    value='좋음',
    delta='-30',
    delta_color='inverse'
    )
    
with col3:
    st.metric(
    '오늘의 습도',
    value='보통'
    )

##
st.markdown('---')

data = {
    '이름':['홍길동','김길동','박길동'],
    '나이': [10,20,30]
}
df = pd.DataFrame(data)
st.dataframe(df)

st.divider()

st.table(df)

st.divider()

st.json(data)
st.divider()

st.title("CSV 기반 인터랙티브 Box Plot")

datafile = st.file_uploader("CSV 파일 선택", type="csv")

if datafile is not None:
    df = pd.read_csv(datafile)
    
    st.write("### 데이터 테이블")
    st.dataframe(df)
    
    st.write("### Box Plot 설정")
    
    # 선택 가능한 컬럼 목록
    x_options = df.columns.tolist()
    y_options = df.columns.tolist()
    hue_options = [None] + df.select_dtypes(include='object').columns.tolist()  # 범주형 컬럼만 색상 옵션
    
    # 위젯으로 X, Y, Hue 선택
    x_option = st.selectbox('Select X-axis', options=x_options, index=0)
    y_option = st.selectbox('Select Y-axis', options=y_options, index=1)
    hue_option = st.selectbox('Select Color (Hue)', options=hue_options, index=0)
    
    # Box Plot 생성
    if x_option and y_option:
        if hue_option:
            fig = px.box(
                df,
                x=x_option,
                y=y_option,
                color=hue_option,
                title=f'{y_option} by {x_option}'
            )
        else:
            fig = px.box(
                df,
                x=x_option,
                y=y_option,
                title=f'{y_option} by {x_option}'
            )
        
        st.plotly_chart(fig, use_container_width=False)