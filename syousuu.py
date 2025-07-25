import random

def generate_problem(st):
    op = random.choice(["+", "-"])  # たし算またはひき算

    if st == 1:
        # 小数第1位 × 小数第1位（数値も小さめ）
        a = round(random.uniform(1, 5), 1)
        b = round(random.uniform(1, 5), 1)

    elif st == 2:
        # 小数第2位 × 小数第2位（数値はやや大きめ）
        a = round(random.uniform(1, 10), 2)
        b = round(random.uniform(1, 10), 2)

    elif st == 3:
        # 整数 + 小数／小数 + 整数（バリエーション）
        if random.choice([True, False]):
            a = random.randint(1, 20)
            b = round(random.uniform(0.1, 9.9), 1)
        else:
            a = round(random.uniform(0.1, 9.9), 1)
            b = random.randint(1, 20)

    elif st == 4:
        # 小数第2位までの繰り上がり・繰り下がりを意識
        a = round(random.uniform(10, 50), 2)
        b = round(random.uniform(5, 45), 2)

    elif st == 5:
        # 大きめの値、小数第2位まで、複雑な桁数
        a = round(random.uniform(50, 100), 2)
        b = round(random.uniform(20, 80), 2)

    else:
        return "未定義の難易度", "未定義"

    # 計算処理
    result = round(a + b, 2) if op == "+" else round(a - b, 2)
    question = f"\\( {a} {op} {b} = \\ ? \\)"
    answer = f"{result}"

    return question, answer
