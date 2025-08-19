import streamlit as st
st.title('스트림릿 안녕하세요')
name = st.text_input('이름:')
st.write(f"안녕하세요, {name}님!")
