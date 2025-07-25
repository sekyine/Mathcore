import random

def generate_problem(st):
    if st == 1:
        # 小さい整数の割り算（割り切れる）
        b = random.randint(1, 5)
        ans = random.randint(1, 5)
        a = b * ans
        question = f"\\( {a} \\div {b} = \\ ? \\)"
        answer = f"{ans}"

    elif st == 2:
        # 少し大きい整数（割り切れる）
        b = random.randint(6, 10)
        ans = random.randint(2, 10)
        a = b * ans
        question = f"\\( {a} \\div {b} = \\ ? \\)"
        answer = f"{ans}"

    elif st == 3:
        # 割り切れない割り算（小数）
        b = random.randint(2, 10)
        a = random.randint(10, 99)
        result = round(a / b, 2)
        question = f"\\( {a} \\div {b} = \\ ? \\)（小数第2位まで）"
        answer = f"{result}"

    elif st == 4:
        # 分数で表す割り算
        b = random.randint(2, 9)
        a = random.randint(2, 9) * b + random.randint(1, b-1)
        question = f"\\( \\frac{{{a}}}{{{b}}} \\) を帯分数にせよ。"
        whole = a // b
        rem = a % b
        answer = f"{whole} \\( \\frac{{{rem}}}{{{b}}} \\)"

    elif st == 5:
        # 式を含む割り算（xを使う）
        a = random.randint(1, 5)
        b = random.randint(1, 5)
        question = f"\\( \\frac{{{a}x}}{{{b}}} \\) を簡単にせよ。"
        answer = f"\\( \\frac{{{a}}}{{{b}}}x \\)"

    else:
        question = "未定義の難易度です"
        answer = "未定義"

    return question, answer
