import random

def generate_problem(st):
    if st == 1:
        a = random.randint(5, 10)
        b = random.randint(1, 5)
        question = f"\\( {a} - {b} = \\ ? \\)"
        answer = f"{a - b}"
    elif st == 2:
        a = random.randint(20, 30)
        b = random.randint(10, 20)
        question = f"\\( {a} - {b} = \\ ? \\)"
        answer = f"{a + b}"
    elif st == 3:
        a =random.randint(40, 50)
        b = random.randint(30, 40)
        question = f"\\( {a} - {b} = \\ ? \\)"
        answer = f"{a + b}"
    elif st == 4:
        a = random.randint(60, 70)
        b = random.randint(50, 60)
        question = f"\\( {a} - {b} = \\ ? \\)"
        answer = f"{a + b}"
    elif st == 5:
        a =random.randint(85, 100)
        b = random.randint(70, 85)
        question = f"\\( {a} - {b} = \\ ? \\)"
        answer = f"{a + b}"
    else:
        question = "未定義"
        answer = "未定義"

    return question, answer
        