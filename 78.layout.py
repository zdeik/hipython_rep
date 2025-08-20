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