import random

def generate_problem(st):
    if st == 1:
        a = random.randint(1, 5)
        b = random.randint(1, 5)
        question = f"\\( {a} \\times {b} = \\ ? \\)"
        answer = f"{a * b}"
    elif st == 2:
        a = random.randint(6, 10)
        b = random.randint(6, 10)
        question = f"\\( {a} \\times {b} = \\ ? \\)"
        answer = f"{a * b}"
    elif st == 3:
        a = random.randint(10, 15)
        b = random.randint(10, 15)
        question = f"\\( {a} \\times {b} = \\ ? \\)"
        answer = f"{a * b}"
    elif st == 4:
        a = random.randint(15, 17)
        b = random.randint(15, 17)
        question = f"\\( {a} \\times {b} = \\ ? \\)"
        answer = f"{a * b}"
    elif st == 5:
        a = random.randint(17, 20)
        b = random.randint(17, 20)
        question = f"\\( {a} \\times {b} = \\ ? \\)"
        answer = f"{a * b}"
    else:
        question = "未定義"
        answer = "未定義"

    return question, answer
        