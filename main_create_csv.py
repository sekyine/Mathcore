import csv
import random
from pathlib import Path

# 各分野の問題生成関数をインポート
from tashizann import generate_problem as generate_tashizann
from hikizann import generate_problem as generate_hikizann
from kakezann import generate_problem as generate_kakezann
from warizann import generate_problem as generate_warizann
from syousuu import generate_problem as generate_syousuu
from bunnsuu import generate_problem as generate_bunnsuu
from large_number import generate_problem as generate_large_number


# 画像フォルダ（画像は分野ごとに名前が対応している想定）
IMAGE_DIR = Path("./app/assets/images/")

# 出力CSVファイル
OUTPUT_CSV = Path("card_create_test.csv")

# 各分野ごとの生成設定
FIELDS = [
    ("足し算", generate_tashizann),
    ("引き算", generate_hikizann),
    ("掛け算", generate_kakezann),
    ("割り算", generate_warizann),
    ("小数(小学校)", generate_syousuu),
    ("分数(小学校)", generate_bunnsuu),
    ("大きい数", generate_large_number)
]

# ランダムに選ぶための設定
EFFECTS = ["attack", "defence", "heal"]

# カードデータ生成
cards = []

for field_name, generator in FIELDS:
    # その分野に対応する画像ファイル一覧を取得
    images = sorted([img.name for img in IMAGE_DIR.glob(f"{field_name}*.png")])
    if not images:
        print(f"[警告] {field_name} の画像が見つかりません。")
        continue

    for st in range(1, 6):  # 難易度 1 ~ 5
        for _ in range(5):  # 各難易度5問
            try:
                question, ans = generator(st)
            except Exception as e:
                print(f"[エラー] {field_name} の難易度 {st} の問題生成に失敗: {e}")
                continue

            image = random.choice(images)
            imans = [str(random.randint(1, 99)) for _ in range(3)]  # ダミー誤答
            effect = random.choice(EFFECTS)
            power = random.randint(1, 10)

            cards.append({
                "image": f"{image}",  # CSVにはファイル名のみを出力
                "st": st,
                "bunya": field_name,
                "question": question,
                "ans": ans,
                "imans1": imans[0],
                "imans2": imans[1],
                "imans3": imans[2],
                "effect_type": effect,
                "power": power
            })

# CSVに書き出し
with OUTPUT_CSV.open("w", newline="", encoding="utf-8-sig") as f:
    writer = csv.DictWriter(f, fieldnames=cards[0].keys())
    writer.writeheader()
    writer.writerows(cards)

print(f"[完了] {len(cards)} 枚のカードを {OUTPUT_CSV} に出力しました。")