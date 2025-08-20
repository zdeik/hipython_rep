import streamlit as st

##################### button click

def button_write():
    st.write("버튼이 클릭되엇습니다!")

st.button('Reset', type='primary')
st.button('activate', on_click=button_write)

clicked = st.button('activate2', type='primary')
if clicked:
    st.write('버튼2가 클릭되엇습니다.')

#####################
st.header('같은 버튼 여러개 만들기')
#key=
#activate button 5개 primary
for i in range(5):
    st.button(
        'activate',
        type='primary',
        key=f'act_btn{i}'
    )
    
#####################

st.title('스트림릿 안녕하세요')
st.header('haeder')
st.subheader('subheader')


st.write('write 문장입니다') #p
st.text('text문장입니다 ') #div
st.markdown(
    '''
    여기는 메인 텍스트입니다.
    :red[Red], :blue[blue], :green[Green]\n
    **굵게 지정 가능** 그리고 *이탤릭체*로도 표현 할 수 있다.
    '''
)
st.code(
    '''
    st.title('스트림릿 안녕하세요')
    st.header('haeder')
    st.subheader('subheader')
    ''',
    language='python'
)

st.divider()

st.button('Hello',icon="🚨",key='btn1') # secondary type
st.button('Hello', type='primary',key='btn2')
st.button('Hello', type='primary',disabled=True,key='btn3')
st.divider()


