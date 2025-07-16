import random

def generate_problem(st):
    if st == 1:
        a = random.randint(1, 5)
        b = random.randint(1, 5)
        question = f"\\( f(x) = {a}x + {b} \\)\nこの関数の導関数を求めよ。"
        answer = f"\\( f'(x) = {a} \\)"
    elif st == 2:
        a = random.randint(1, 5)
        b = random.randint(1, 5)
        question = f"\\( f(x) = {a}x^2 + {b}x \\)\nこの関数の導関数を求めよ。"
        answer = f"\\( f'(x) = {2*a}x + {b} \\)"
    elif st == 3:
        a = random.randint(1, 5)
        x_val = random.randint(1, 5)
        question = f"\\( f(x) = {a}x^2 \\)\nこの関数の x = {x_val} における導関数の値を求めよ。"
        answer = f"{2 * a * x_val}"
    elif st == 4:
        a = random.randint(1, 3)
        b = random.randint(1, 3)
        x_val = random.randint(1, 5)
        question = f"\\( f(x) = {a}x^3 + {b}x^2 \\)\nこの関数の x = {x_val} における導関数の値を求めよ。"
        answer = f"{3*a*x_val**2 + 2*b*x_val}"
    elif st == 5:
        question = "\\( f(x) = (x^2 + 1)^2 \\)\nこの関数の導関数を求めよ。"
        answer = "\\( f'(x) = 4x(x^2 + 1) \\)"
    else:
        question = "未定義"
        answer = "未定義"

    return question, answer
