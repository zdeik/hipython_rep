import streamlit as st
import pandas as pd
import random
from datetime import datetime, timedelta
import uuid

# 페이지 설정
st.set_page_config(
    page_title="톡톡 상담 지원 시스템",
    page_icon="💬",
    layout="wide"
)

# CSS 스타일링
st.markdown("""
<style>
    .main-header {
        text-align: center;
        font-size: 28px;
        font-weight: bold;
        margin: 30px 0;
        color: #2E7D32;
    }
    
    .login-container {
        max-width: 400px;
        margin: 50px auto;
        padding: 40px;
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        border: 1px solid #e0e0e0;
    }
    
    .counselor-card {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        border-left: 4px solid #4CAF50;
        margin: 10px 0;
        border: 1px solid #e0e0e0;
    }
    
    .consultation-info {
        background: #E8F5E8;
        padding: 20px;
        border-radius: 10px;
        margin: 20px 0;
        border: 1px solid #c8e6c9;
    }
    
    .chat-message {
        padding: 12px 16px;
        margin: 8px 0;
        border-radius: 12px;
        max-width: 70%;
        word-wrap: break-word;
    }
    
    .user-message {
        background: #E3F2FD;
        margin-left: 30%;
        border: 1px solid #bbdefb;
    }
    
    .counselor-message {
        background: #F1F8E9;
        margin-right: 30%;
        border: 1px solid #dcedc8;
    }
    
    .stButton > button {
        width: 100%;
        border-radius: 8px;
        border: none;
        padding: 10px;
        font-weight: 500;
    }
    
    .header-info {
        background: #f5f5f5;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
</style>
""", unsafe_allow_html=True)

# 샘플 데이터 생성 함수
@st.cache_data
def generate_sample_data():
    names = ["김민준", "이서연", "박도윤", "정시우", "최예은", "김하준", "이서진", "박건우", "정나연", "최시은",
             "김준서", "이채원", "박지후", "정서율", "최민서", "김하늘", "이도현", "박유진", "정은우", "최소연",
             "김지안", "이하은", "박민준", "정채은", "최연우", "김소율", "이준혁", "박시연", "정하린", "최도훈"]
    
    consultation_topics = [
        "대출 조건 관련 문의", "신용카드 발급 문의", "적금 상품 안내", "주택담보대출 상담", "개인신용 문의",
        "보험 상품 문의", "투자 상품 안내", "해외송금 문의", "인터넷뱅킹 오류", "모바일앱 사용법",
        "계좌개설 문의", "비밀번호 재설정", "카드 분실 신고", "연체 관련 상담", "금리 문의",
        "펀드 투자 상담", "외환 거래 문의", "기업대출 상담", "퇴직연금 문의", "ISA 계좌 문의",
        "체크카드 발급", "통장 재발급", "이체한도 변경", "공과금 자동이체", "급여이체 설정",
        "부동산 담보대출", "전세자금대출", "사업자대출", "학자금대출", "신혼부부대출"
    ]
    
    data = []
    for i in range(35):
        consultation_date = datetime.now() - timedelta(days=random.randint(0, 90))
        data.append({
            "상담자": random.choice(names),
            "상담 내용 요약": random.choice(consultation_topics),
            "상담일": consultation_date.strftime("%Y-%m-%d"),
            "상담 시간": f"{random.randint(9, 17):02d}:{random.randint(0, 59):02d}",
            "상담 ID": str(uuid.uuid4())[:8]
        })
    
    return pd.DataFrame(data)

# 상세 상담 내용 생성
def generate_consultation_detail(summary):
    conversations = [
        {
            "speaker": "고객",
            "message": f"안녕하세요 상담사님. {summary}에 대해 문의드립니다."
        },
        {
            "speaker": "상담사",
            "message": "안녕하세요. 대출 조건이 어떻게 되는지 궁금하시군요."
        },
        {
            "speaker": "고객", 
            "message": "네, 고객님. 소득 증빙과 신용 등급에 따라 조건이 달라질 수 있습니다. 자세한 안내를 도와드리겠습니다."
        }
    ]
    return conversations

# 세션 상태 초기화
if 'page' not in st.session_state:
    st.session_state.page = 'login'
if 'counselor_id' not in st.session_state:
    st.session_state.counselor_id = None
if 'sample_data' not in st.session_state:
    st.session_state.sample_data = generate_sample_data()
if 'selected_consultation' not in st.session_state:
    st.session_state.selected_consultation = None

# 로그인 페이지
def login_page():
    st.markdown('<div class="main-header">💬 톡톡 상담 지원 시스템</div>', unsafe_allow_html=True)
    
    col1, col2, col3 = st.columns([1, 2, 1])
    
    with col2:
        with st.container():
            st.markdown("---")
            # 캐릭터 이미지
            st.markdown('<div style="text-align: center; font-size: 60px; margin: 20px 0;">🤖</div>', unsafe_allow_html=True)
            
            st.markdown('<p style="text-align: center; color: #666; margin-bottom: 30px; font-size: 18px;">상담사 로그인</p>', unsafe_allow_html=True)
            
            counselor_number = st.text_input("", placeholder="상담사 번호", help="상담사 번호를 입력하세요")
            
            col_btn1, col_btn2, col_btn3 = st.columns([1, 2, 1])
            with col_btn2:
                if st.button("상담 시작", type="primary"):
                    if counselor_number.strip():
                        st.session_state.counselor_id = counselor_number
                        st.session_state.page = 'main'
                        st.rerun()
                    else:
                        st.error("상담사 번호를 입력해주세요.")
            st.markdown("---")

# 메인 페이지
def main_page():
    # 헤더 정보
    st.markdown('<div class="header-info">', unsafe_allow_html=True)
    col1, col2, col3 = st.columns([2, 2, 2])
    
    with col1:
        st.markdown(f"**👤 상담자:** {st.session_state.counselor_id}")
    
    with col2:
        st.markdown(f"**📅 날짜:** {datetime.now().strftime('%Y/%m/%d')}")
    
    with col3:
        if st.button("상담자 메모"):
            st.info("메모 기능")
    st.markdown('</div>', unsafe_allow_html=True)
    
    # 검색 기능
    col1, col2 = st.columns([5, 1])
    
    with col1:
        search_term = st.text_input("🔍", placeholder="상담 이력 검색", label_visibility="collapsed")
    
    with col2:
        if st.button("📅"):
            st.info("날짜 필터")
    
    # 검색 필터링
    if search_term:
        filtered_data = st.session_state.sample_data[
            (st.session_state.sample_data['상담자'].str.contains(search_term, case=False, na=False)) |
            (st.session_state.sample_data['상담 내용 요약'].str.contains(search_term, case=False, na=False))
        ]
    else:
        filtered_data = st.session_state.sample_data
    
    # 상담 이력 목록
    st.markdown("### 상담 이력")
    
    for idx, row in filtered_data.head(10).iterrows():  # 처음 10개만 표시
        with st.container():
            st.markdown('<div class="counselor-card">', unsafe_allow_html=True)
            
            col1, col2, col3 = st.columns([2, 4, 1])
            
            with col1:
                st.markdown(f"**상담자**")
                st.markdown(f"{row['상담자']}")
            
            with col2:
                st.markdown(f"**상담 내용 요약**")
                st.markdown(f"{row['상담 내용 요약']}")
            
            with col3:
                if st.button("상세", key=f"detail_{idx}"):
                    st.session_state.selected_consultation = row
                    st.session_state.page = 'detail'
                    st.rerun()
            
            st.markdown('</div>', unsafe_allow_html=True)
    
    # 하단 버튼들
    st.markdown("---")
    col1, col2, col3, col4 = st.columns([2, 2, 2, 2])
    
    with col1:
        if st.button("➕ 새 상담", type="primary"):
            st.session_state.page = 'new_consultation'
            st.rerun()
    
    with col4:
        if st.button("⚙️ 로그아웃"):
            st.session_state.counselor_id = None
            st.session_state.page = 'login'
            st.rerun()

# 새 상담 페이지
def new_consultation_page():
    # 헤더
    st.markdown('<div class="header-info">', unsafe_allow_html=True)
    col1, col2, col3 = st.columns([2, 2, 2])
    
    with col1:
        st.markdown(f"**👤 상담자:** {st.session_state.counselor_id}")
    
    with col2:
        st.markdown(f"**📞 상담자:** 박상준")
    
    with col3:
        st.markdown(f"**📅 날짜:** {datetime.now().strftime('%Y/%m/%d')} **⏰ 시간:** {datetime.now().strftime('%H:%M')}")
    st.markdown('</div>', unsafe_allow_html=True)
    
    # 자동 서비스 정보
    st.markdown("---")
    st.markdown('<div style="text-align: center; background: #E8F5E8; padding: 20px; border-radius: 10px; margin: 20px 0;">', unsafe_allow_html=True)
    st.markdown('## 톡톡\'s Auto Service')
    st.markdown('<p style="color: #666; font-size: 16px;">키워드 확인: 대기중</p>', unsafe_allow_html=True)
    st.markdown('</div>', unsafe_allow_html=True)
    
    # 캐릭터
    st.markdown('<div style="text-align: center; font-size: 100px; margin: 40px 0;">😊</div>', unsafe_allow_html=True)
    
    # 상담 종료 버튼
    col1, col2, col3 = st.columns([2, 2, 2])
    
    with col2:
        if st.button("상담 종료", type="primary"):
            st.session_state.page = 'main'
            st.rerun()

# 상담 상세 페이지
def consultation_detail_page():
    if st.session_state.selected_consultation is None:
        st.session_state.page = 'main'
        st.rerun()
        return
    
    consultation = st.session_state.selected_consultation
    
    # 헤더
    st.markdown('<div class="header-info">', unsafe_allow_html=True)
    col1, col2 = st.columns([2, 2])
    
    with col1:
        st.markdown(f"**👤 상담자:** {consultation['상담자']}")
    
    with col2:
        st.markdown(f"**📅 상담일:** {consultation['상담일']}")
    st.markdown('</div>', unsafe_allow_html=True)
    
    # 상담 요약 정보
    st.markdown('<div class="consultation-info">', unsafe_allow_html=True)
    st.markdown("### 상담 요약 정보")
    st.markdown(f"**상담 요약:** {consultation['상담 내용 요약']}")
    st.markdown('</div>', unsafe_allow_html=True)
    
    # 대화 내용
    st.markdown("---")
    st.markdown("### 상담 내용")
    
    conversations = generate_consultation_detail(consultation['상담 내용 요약'])
    
    for conv in conversations:
        if conv['speaker'] == '고객':
            st.markdown(f'<div class="chat-message user-message"><strong>박상준</strong><br>{conv["message"]}</div>', unsafe_allow_html=True)
        else:
            st.markdown(f'<div class="chat-message counselor-message"><strong>김민준</strong><br>{conv["message"]}</div>', unsafe_allow_html=True)
    
    # 하단 버튼
    st.markdown("---")
    col1, col2, col3 = st.columns([2, 2, 2])
    
    with col2:
        if st.button("목록으로", type="primary"):
            st.session_state.page = 'main'
            st.rerun()

# 메인 실행 함수
def main():
    if st.session_state.page == 'login':
        login_page()
    elif st.session_state.page == 'main':
        main_page()
    elif st.session_state.page == 'new_consultation':
        new_consultation_page()
    elif st.session_state.page == 'detail':
        consultation_detail_page()

# 앱 실행
if __name__ == "__main__":
    main()


# import streamlit as st
# import pandas as pd
# from typing import List, Dict

# # === 샘플 데이터/함수 (실제 구현 시 벡터DB+LLM 연동) ===
# def mock_vector_search(query: str, top_k: int = 5) -> List[Dict]:
#     # 임시 데이터: 실제 검색 결과 대신 사용
#     return [
#         {
#             "title": f"문서 {i} 제목",
#             "source": f"소상공인시장진흥공단",
#             "published_date": f"2025-0{i}-01",
#             "url": f"https://example.com/doc{i}",
#             "score": round(0.9 - i*0.1,2),
#             "chunk_text": f"이것은 문서 {i}의 샘플 청크 텍스트입니다."
#         } for i in range(1, top_k+1)
#     ]

# def mock_llm_answer(query: str, context: List[Dict]) -> str:
#     answer = f"사용자 질문: {query}\n\n요약 답변:\n"
#     for c in context:
#         answer += f"- ({c['score']}) {c['chunk_text']}\n"
#     answer += "\n출처:\n"
#     for c in context:
#         answer += f"- {c['title']} — {c['source']}, {c['published_date']}. {c['url']}\n"
#     return answer

# # === Streamlit UI ===
# st.title("소상공인 대출 상담 RAG 데모")
# st.write("RAG 기반 질문 답변 시스템 - 포트폴리오용 테스트 UI")

# # 사용자 질문 입력
# user_query = st.text_input("질문을 입력하세요:")

# if user_query:
#     st.subheader("검색된 관련 문서")
#     search_results = mock_vector_search(user_query)
#     df_results = pd.DataFrame(search_results)[['title','source','published_date','url','score']]
#     st.dataframe(df_results)

#     st.subheader("LLM 기반 답변")
#     answer_text = mock_llm_answer(user_query, search_results)
#     st.text_area("답변 및 출처", answer_text, height=300)
