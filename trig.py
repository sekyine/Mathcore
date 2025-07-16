
import random
import math

def generate_problem(st):
    angle = random.choice([0, 30, 45, 60, 90])
    if st <= 2:
        question = f"\sin {angle}^\circ"
        answer = str(round(math.sin(math.radians(angle)), 2))
    elif st == 3:
        question = f"\cos {angle}^\circ"
        answer = str(round(math.cos(math.radians(angle)), 2))
    else:
        question = f"\tan {angle}^\circ"
        answer = str(round(math.tan(math.radians(angle)), 2)) if angle != 90 else "undefined"
    return question, answer
