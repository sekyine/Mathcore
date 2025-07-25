import random

def generate_problem(st):
    op = random.choice(["+", "-"])  # 足し算 or 引き算

    if st == 1:
        # 2桁 + 2桁（簡単な繰り上がり・繰り下がり）
        a = random.randint(10, 99)
        b = random.randint(10, 99)

    elif st == 2:
        # 3桁 + 3桁（繰り上がり・繰り下がりを意識）
        a = random.randint(100, 999)
        b = random.randint(100, 999)

    elif st == 3:
        # 4桁 + 3桁（桁が異なる組み合わせ）
        a = random.randint(1000, 9999)
        b = random.randint(100, 999)

    elif st == 4:
        # 4桁 + 4桁（繰り上がり多め）
        a = random.randint(1000, 9999)
        b = random.randint(1000, 9999)

    elif st == 5:
        # 5桁 + 4〜5桁（より大きな計算）
        a = random.randint(10000, 99999)
        b = random.randint(1000, 99999)

    else:
        return "未定義の難易度", "未定義"

    # 引き算のとき、a >= b にして負の答えを避ける
    if op == "-" and a < b:
        a, b = b, a

    question = f"\\( {a} {op} {b} = \\ ? \\)"
    answer = f"{a + b if op == '+' else a - b}"
    return question, answer
