import streamlit as st
import pandas as pd
# sidebar, colums, tabs, expander
from PIL import Image

def make_anal_tab():
    tab1, tab2, tab3 = st.tabs(['차트','데이터','설정'])
    with tab1:
        st.subheader('차트 탭')
        st.bar_chart({'데이터':[1,2,3,4,5]})
        
    with tab2:
        st.subheader('데이터 탭')
        st.dataframe({'기준':[1,2,3,4,5],'값':['a','b','c','d','e']})
        
    # 3번째 탭: 체크박스 (활성화 여부), 슬라이더(업데이트 주기 sec)
    with tab3:
        st.subheader('설정 탭')

        is_active = st.checkbox('기능 활성화')

        if is_active:
            update_interval = st.slider('업데이트 주기 (초)', min_value=1, max_value=60, value=10)
            st.success(f'기능이 활성화되었습니다. 업데이트 주기: {update_interval}초')
        else:
            st.warning('기능이 비활성화되었습니다.')



st.title("스트림릿 앱 페이지 구성하기")

st.sidebar.header('웰컴 메뉴')
selected_menu = st.sidebar.selectbox(
    '메뉴선택',['메인','분석','설정']
)

img = Image.open('./sample.jpg')

if selected_menu == '메인':
    st.header('*메인 페이지*')
    st.write('환영합니다.!!')
    col1,col2 = st.columns(2)
    with col1:
        st.image(img, width=300, caption='Image')

    with col2:
        st.image(img, width=300, caption='Image')
    
elif selected_menu == '분석':
    st.subheader('분석 보고서')
    st.write('여기서 데이터를 선택하실 수 있습니다.')
    make_anal_tab()
    
else:
    st.subheader('설정 변경')
    st.write('앱 설정을 수정하실 수 있습니다.')
    
    
if st.sidebar.button('선택'):
    st.sidebar.write('선택을 클릭하셧습니다.')
    
# 슬라이드바 추가0~100, 50
st.divider()
st.subheader("슬라이더")
slider_value = st.slider('값을 선택', min_value=0, max_value=100, value=50)
st.write(f'선택한 값: {slider_value}')

# 확장영역 추가 
st.header('익스팬더 추가')

with st.expander('숨긴 영역'):
    st.write('여기는 보이지 않습니다. 클릭해야 보입니다.')
    