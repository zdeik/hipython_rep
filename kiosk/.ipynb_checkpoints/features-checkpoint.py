from utils import get_yes_or_no_input, get_valid_number_input, align_text, print_receipt
import time

# 메뉴 및 데이터 초기화
menu_list = ['초코', '바닐라', '딸기', '우유', '말차', '민트초코']
size_price = {'S': 2000, 'M': 3000, 'L': 4000}
size_list = list(size_price.keys())

cart_list = []
membership_dict = {}
cart = {'user_menu': '', 'user_size': '', 'qty': ''}



# 시작 화면
def start():
    print('=' * 50)
    store_name = 'I Miss You Cram!🍦'
    print(f'        보고싶었어요! {store_name}')
    print('=' * 50)
    cart_list.clear()
    menu_choice()


# 메뉴 선택
def menu_choice():
    while True:
        print("\n📋 메뉴판\n")
        for index, name in enumerate(menu_list):
            print(f'{index + 1}. {name}')

        menu_mul = f"\n원하시는 메뉴를 선택해주세요. (1~{len(menu_list)}, 0:처음으로): "
        menu_index = get_valid_number_input(menu_mul, 0, len(menu_list))  # 예외처리

        if menu_index is None:
            continue  # None일 경우 아무 처리 없이 다시 메뉴 선택

        if menu_index == 0:
            print('\n보고싶을거예요😭\n')
            print('-' * 50)
            start()
            return

        if 1 <= menu_index <= len(menu_list):
            cart['user_menu'] = menu_list[menu_index - 1]
            print('-' * 50)
            size_count()
            return

# 수량 선택
def size_count():
    while True:
        print("\n🍨 사이즈 및 가격\n")
        for i, (size, price) in enumerate(size_price.items()):
            print(f'{i + 1}. 사이즈: {size}, 가격: {price:,}원')
        size_mul = f"\n원하시는 사이즈를 선택해주세요. (1~{len(size_price)}, 0:뒤로가기): "
        size_index = get_valid_number_input(size_mul, 0,3 )## 예외처리 (0~3)

        if size_index is None:
            print("⛔입력 오류⛔ 사이즈 다시 선택하세요.")

        elif size_index == 0:
            print('\n⬅️ 뒤로 돌아갑니다')
            print('-' * 50)
            menu_choice()
            return
        elif 1 <= size_index <= len(size_price):
            cart['user_size'] = size_list[size_index - 1]
            break
    while True:
        qty_mul = "🤟 원하시는 개수를 적어주세요. (0:뒤로가기) \n 10개 이하만 가능!: "
        qty = get_valid_number_input(qty_mul, 0, 10) ## 예외처리 (0~10) 성공
        if qty == None:
            continue
        if qty == 0:
            print('\n⬅️ 사이즈 선택으로 돌아갑니다')
            print('-' * 50)
            size_count()
            return
        if qty > 0:
            cart['qty'] = qty
            break
    print('-' * 50)
    cart_function()

# 장바구니에 추가 및 장바구니 기능 선택
def cart_function():
    item = {
        'user_menu': cart['user_menu'],
        'user_size': cart['user_size'],
        'qty': cart['qty'],
        'price_per_item': size_price[cart['user_size']],
        'total_price': size_price[cart['user_size']] * cart['qty']
    }
    cart_list.append(item)

    print("\n🍦 장바구니에 추가되었습니다! 🍦")
    print_cart()
    print('-' * 50)

    while True:
        cho_mul = "\n1. 계속 쇼핑하기  2. 장바구니 보기 및 결제  3. 장바구니에서 상품 삭제  0. 종료\n선택: "
        choice = get_valid_number_input(cho_mul, 0, 3) ## 예외처리 (0~3)
        if choice == 1:
            menu_choice()
            return
        elif choice == 2:
            show_cart()
            return
        elif choice == 3:
            del_cart()
        elif choice == 0:
            print("\n이용해주셔서 감사합니다! 좋은 하루 되세요! 👋")
            print('-' * 50)
            start()

# 장바구니 상품 삭제
def del_cart():
    if not cart_list:
        print("\n장바구니가 비어 있습니다.")
        return
    print_cart()
    try:
        idx = int(input("삭제할 상품 번호를 입력하세요 (취소하려면 0 입력): "))
        if idx == 0:
            print("삭제를 취소했습니다.")
            return
        if 1 <= idx <= len(cart_list):
            removed = cart_list.pop(idx - 1)
            print(f"{removed['user_menu']} ({removed['user_size']}) x {removed['qty']}개가 장바구니에서 삭제되었습니다.")
        else:
            print("⛔ 유효한 번호를 입력하세요.")
    except ValueError:
        print("⛔ 숫자를 입력해주세요.")

# 장바구니 보기 및 결제
def show_cart():
    if not cart_list:
        print("\n장바구니가 비어 있습니다.")
        print('-' * 50)
        start()
        return
    print_cart()
    print('-' * 50)

    while True:
        ask_mul = '1. 결제하기  2. 계속 쇼핑하기  0. 종료하기 '
        choice = get_valid_number_input(ask_mul, 0, 2) ## 예외처리 (0~3)
        if choice == 1:
            total = sum(item['total_price'] for item in cart_list)
            print(f"\n총 결제 금액: {total:,}원")

            answer = get_yes_or_no_input("결제하시겠습니까? (yes/no): ") #예외처리 (yes or no)
            if answer not in ['yes', 'no']:
                print("yes 또는 no만 입력해주세요.")
                continue
            elif answer == 'no':
                print("주문이 취소되었습니다.\n")
                return start()

            # 멤버십 적립 처리
            handle_membership()
            print("결제가 완료되었습니다. 감사합니다! 🍦\n")
            print("""⠀
            로딩중~~⠀⠀⠀
            。　 ඞ 。　 . •⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀
    ⠀🍨⠀⠀⠀⠀⢀⣶⣿⣿⣿⣿⣿⣿⣶⡄⠀⠀🍦
    ⠀⠀⠀⠀⠤⢀⠀⢸⠛⠋⠘⠛⠃⠙⢻⣿⣿⠀⠀⠀
    ⠀⠀⡌⠀⠀⠀⢣⢸⠀⠘⠀⠀⠘⠀⠀⢁⡹⠀⠀⠀     🍧
    ⠀⠀⠲⡖⠒⠒⡷⠀⡱⠤⣀⣁⣀⠤⠤⡈⠀⠀⠀⠀
    ⠀⠀⠀⠹⡄⡼⡀⣻⡜⠀⠀⠀⢀⠴⠦⢌⡆⠀⠀⠀🍫
    ⠀⠀⠀⠀⠙⠁⠈⠉⣷⣶⣶⣶⣾⣦⣤⠎⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠘⠒⠒⠈⠓⠒⠊⠀⠀⠀⠀⠀
  결제 중입니다 😍
    """)

            time.sleep(3)
            print('=' * 50)


            print("결제가 완료되었습니다. 감사합니다! 🍦\n")
            print_receipt("I Miss You Cram!🍦", cart_list)
            cart_list.clear()
            start()
            return

        elif choice == 2:
            return menu_choice()
        elif choice == 0:
            print("\n이용해주셔서 감사합니다! 좋은 하루 되세요! 👋")
            start()

# 장바구니 출력
def print_cart():
    if not cart_list:
        print("\n장바구니가 비어 있습니다.")
        return
    print("\n🛒 현재 장바구니:")
    for i, item in enumerate(cart_list, 1):
        print(f"{i}. {item['user_menu']} ({item['user_size']}) x {item['qty']}개 - {item['total_price']:,}원")
    total = sum(item['total_price'] for item in cart_list)
    print(f"총 합계: {total:,}원")
    print('-' * 50)

# 멤버십 적립 함수
def handle_membership():
    global last_membership
    while True:
            member = input("멤버십을 적립하시겠습니까? (yes/no): ").strip().lower()
            if member not in ['yes', 'no']:
                print("yes 또는 no만 입력해주세요.")
                continue

            if member == 'no':
                print("멤버십 적립을 건너뜁니다.\n")
                last_membership = False
                break

            print("멤버십 적립을 선택하셨습니다.")

            while True:
                member_ship = input("전화 번호를 11자리를 입력하세요: ").strip()
                last_membership = member_ship

                # 유효성 검사(11자리 여부, 숫자 여부)
                if len(member_ship) != 11 or not member_ship.isdigit():
                    print("전화번호가 올바르지 않습니다. 11자리 숫자만 입력해주세요.")
                    continue

                # 포인트 적립
                if member_ship in membership_dict:
                    # 기존 회원: 1포인트 추가
                    membership_dict[member_ship] += 1
                    print(f"기존 ({member_ship}) 번호로 포인트를 적립했습니다. 적립 포인트: {membership_dict[member_ship]} Point\n")
                else:
                    # 신규 회원: 포인트 1점으로 초기화
                    membership_dict[member_ship] = 1
                    print(f"새로운 ({member_ship}) 번호로 멤버십이 생성되었습니다. 적립 포인트: {membership_dict[member_ship]} Point\n")

                return

