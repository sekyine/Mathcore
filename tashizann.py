import random

def generate_problem(st):
    if st == 1:
        a = random.randint(1, 10)
        b = random.randint(1, 10)
        question = f"\\( {a} + {b} = \\ ? \\)"
        answer = f"{a + b}"
    elif st == 2:
        a = random.randint(10, 30)
        b = random.randint(10, 30)
        question = f"\\( {a} + {b} = \\ ? \\)"
        answer = f"{a + b}"
    elif st == 3:
        a =random.randint(30,50)
        b = random.randint(30, 50)
        question = f"\\( {a} + {b} = \\ ? \\)"
        answer = f"{a + b}"
    elif st == 4:
        a = random.randint(50, 70)
        b = random.randint(50, 70)
        question = f"\\( {a} + {b} = \\ ? \\)"
        answer = f"{a + b}"
    elif st == 5:
        a =random.randint(70, 100)
        b = random.randint(70, 100)
        question = f"\\( {a} + {b} = \\ ? \\)"
        answer = f"{a + b}"
    else:
        question = "未定義"
        answer = "未定義"

    return question, answer
        