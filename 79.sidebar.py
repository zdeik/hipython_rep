import streamlit as st
import pandas as pd

st.title("스트림릿 앱 페이지 구성하기")

st.sidebar.header('웰컴 메뉴')
selected_menu = st.sidebar.selectbox(
    '메뉴선택',['메인','분석','설정']
)

if selected_menu == '메인':
    st.header('*메인 페이지*')
elif selected_menu == '분석':
    st.subheader('분석 보고서')
else:
    st.subheader('설정 변경')
    
if st.sidebar.button('선택'):
    st.sidebar.write('선택을 클릭하셧습니다.')
