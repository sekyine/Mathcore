import random
from math import gcd

def simplify_fraction(numer, denom):
    """分数を約分"""
    common = gcd(numer, denom)
    return numer // common, denom // common

def generate_problem(st):
    op = random.choice(["+", "-"])  # 足し算か引き算

    if st == 1:
        # 分母が同じ（小さい数）
        denom = random.randint(2, 6)
        a = random.randint(1, denom - 1)
        b = random.randint(1, denom - 1)

    elif st == 2:
        # 分母が同じ（やや大きめ）
        denom = random.randint(5, 10)
        a = random.randint(1, denom - 1)
        b = random.randint(1, denom - 1)

    elif st == 3:
        # 分母が異なるが小さい（通分が必要）
        denom1 = random.randint(2, 6)
        denom2 = random.randint(2, 6)
        numer1 = random.randint(1, denom1 - 1)
        numer2 = random.randint(1, denom2 - 1)

        lcm = denom1 * denom2 // gcd(denom1, denom2)
        a = numer1 * (lcm // denom1)
        b = numer2 * (lcm // denom2)
        denom = lcm

    elif st == 4:
        # 分母が異なる（大きめ）、通分＋約分あり
        denom1 = random.randint(5, 10)
        denom2 = random.randint(5, 10)
        numer1 = random.randint(1, denom1 - 1)
        numer2 = random.randint(1, denom2 - 1)

        lcm = denom1 * denom2 // gcd(denom1, denom2)
        a = numer1 * (lcm // denom1)
        b = numer2 * (lcm // denom2)
        denom = lcm

    elif st == 5:
        # 仮分数（帯分数になる）、通分も必要
        denom1 = random.randint(4, 9)
        denom2 = random.randint(4, 9)
        numer1 = random.randint(denom1, denom1 * 2 - 1)
        numer2 = random.randint(denom2, denom2 * 2 - 1)

        lcm = denom1 * denom2 // gcd(denom1, denom2)
        a = numer1 * (lcm // denom1)
        b = numer2 * (lcm // denom2)
        denom = lcm

    else:
        return "未定義の難易度", "未定義"

    # st=1,2のとき
    if st in [1, 2]:
        if op == "+":
            result_num = a + b
        else:
            result_num = abs(a - b)
        simplified_num, simplified_denom = simplify_fraction(result_num, denom)
    else:
        if op == "+":
            result_num = a + b
        else:
            result_num = abs(a - b)
        simplified_num, simplified_denom = simplify_fraction(result_num, denom)

    # 帯分数の処理（st=5）
    if st == 5 and simplified_num >= simplified_denom:
        whole = simplified_num // simplified_denom
        rem = simplified_num % simplified_denom
        if rem == 0:
            answer = f"{whole}"
        else:
            answer = f"{whole} \\( \\frac{{{rem}}}{{{simplified_denom}}} \\)"
    else:
        answer = f"\\( \\frac{{{simplified_num}}}{{{simplified_denom}}} \\)"

    # 問題文（st=1,2:簡単な形式）
    if st in [1, 2]:
        question = f"\\( \\frac{{{a}}}{{{denom}}} {op} \\frac{{{b}}}{{{denom}}} = \\ ? \\)"
    else:
        question = f"\\( \\frac{{{a}}}{{{denom}}} {op} \\frac{{{b}}}{{{denom}}} = \\ ? \\)"

    return question, answer
