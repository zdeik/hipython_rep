#my_project\main_app.py

#방법1
# import magic_calc

# result_add = magic_calc.basic_ops.add(10,5)
# print(result_add)


# #방법2
# from magic_calc import basic_ops, advanced_ops
# result_sub = basic_ops.subtract(100, 30)
# print(result_sub)


# 방법 3: 패키지 내 모듈에서 특정 함수 직접 임포트
# from magic_calc.basic_ops import multiply, divide
# from magic_calc.advanced_ops import power

# print("\n--- 방법 3: multiply, divide, power 직접 사용 ---")
# result_mul = multiply(7, 8)
# print(f"7 * 8 = {result_mul}")
