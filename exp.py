
import random

def generate_problem(st):
    if st == 1:
        a = random.randint(2, 5)
        b = random.randint(1, 3)
        question = f"{a}^{{{b}}}"
        answer = str(a ** b)
    elif st == 2:
        a = random.randint(1, 100)
        question = f"\log_{{10}} {a}"
        answer = f"log10({a})"
    else:
        a = random.randint(2, 10)
        b = random.randint(1, 3)
        question = f"\log_{{{a}}} {a ** b}"
        answer = str(b)
    return question, answer
