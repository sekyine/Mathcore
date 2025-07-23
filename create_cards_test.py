import pandas as pd
from PIL import Image, ImageDraw, ImageFont
import matplotlib.pyplot as plt
from matplotlib import rcParams
from matplotlib.font_manager import FontProperties
import io
import os
import re

print(ImageFont.truetype("./Fonts/NotoSerifCJKjp-Regular.otf", 100))

# LaTeX数式を画像として描画する関数
def render_latex(formula, fontsize=30, color='grey', font_path="./Fonts/NotoSerifCJKjp-Regular.otf"):
    font_prop = FontProperties(fname=font_path)
    fig, ax = plt.subplots(figsize=(5, 1))
    ax.axis('off')
    plt.text(0.5, 0.5, f"${formula}$", fontsize=fontsize, ha='center', va='center', color=color, fontproperties=font_prop)
    buf = io.BytesIO()
    plt.savefig(buf, format='png', bbox_inches='tight', pad_inches=0.2, transparent=True)
    plt.close(fig)
    buf.seek(0)
    return Image.open(buf)

# 読み込みとパスの設定
df = pd.read_csv('card_create_test.csv', encoding='UTF-8')
OUTPUT_DIR = './app/assets/images/'
BACKGROUND_PATH = './app/assets/images/background.png'
FONT_PATH = "./Fonts/NotoSerifCJKjp-Regular.otf"
print("ファイル存在:", os.path.exists(FONT_PATH))  # TrueならOK
font_jp = ImageFont.truetype(FONT_PATH, 40)
print("✅ フォント読み込み成功！")
IMAGE_DIR = './app/assets/images/'
CARD_WIDTH, CARD_HEIGHT = 1080, 1350
os.makedirs(OUTPUT_DIR, exist_ok=True)

output_csv_rows = []

for i, row in df.iterrows():
    
    output_path = os.path.join(OUTPUT_DIR, f"card_{i+1}.png")

    # すでに画像がある場合はスキップ
    #if os.path.exists(output_path):
    #    print(f"スキップ: {output_path} は既に存在します。")
    #    continue

    try:

        # 背景読み込み
        print(f"[読み込み] 背景画像を読み込み中...")
        bg = Image.open(BACKGROUND_PATH).convert("RGBA")
        bg = bg.resize((CARD_WIDTH, CARD_HEIGHT), Image.LANCZOS)  # 背景を指定サイズにリサイズ
        W, H = bg.size #高さHをここで定義

        # キャラ画像読み込み・リサイズして合成
        try:
            image_path = os.path.join(IMAGE_DIR, row['image'])
            print(f"[読み込み] キャラ画像 {row['image']} を読み込み中...")
            char_size = int(H * 0.6)  # 高さの60%サイズに
            char_img = Image.open(image_path).convert("RGBA").resize((char_size, char_size), Image.LANCZOS)
            char_x = (W - char_size) // 2
            char_y = (H - char_size) // 2
            bg.paste(char_img, (char_x, char_y), char_img)
            print(f"[成功] キャラ画像を合成しました。")
        except FileNotFoundError as e:
            print(f"[警告] 行 {i+1}: キャラ画像が見つかりません ({row['image']})。スキップします。")
            continue  # この行だけスキップ

        # LaTeXと日本語の分離
        q_raw = row['question']
        match = re.match(r"\\\((.*?)\\\)\s*(.*)", q_raw, re.DOTALL)
        if match:
            latex = match.group(1).strip()
            japanese = match.group(2).strip()
        else:
            latex = ""
            japanese = q_raw

        # 描画用準備
        draw = ImageDraw.Draw(bg)
        font_st = ImageFont.truetype(FONT_PATH, 40)
        font_q = ImageFont.truetype(FONT_PATH, 40)

        # 左上にレアリティ（★）を表示
        draw.text((70, 60), "★" * int(row['st']), fill='gold', font=font_st)

        # LaTeXで描いた数式画像を貼り付け
        print(f"[描画] LaTeX数式を描画中...")
        latex_img = render_latex(latex, fontsize=42, color='white')
        latex_w, latex_h = latex_img.size
        latex_x = (W - latex_w) // 2
        latex_y = int(H * 0.1)  # 上寄り5%位置
        bg.paste(latex_img, (latex_x, latex_y), latex_img)

        # 日本語描画
        if japanese:

        # テキストサイズを取得して中央配置の座標を計算
            bbox = font_q.getbbox(japanese)
            text_w = bbox[2] - bbox[0]
            text_h = bbox[3] - bbox[1]

            text_x = (W - text_w) // 2
            text_y = latex_y + latex_h + 2  # LaTeX画像の下に表示
            # シャドウ
            draw.text((text_x+2, text_y+2), japanese, fill='black', font=font_q)
            draw.text((text_x, text_y), japanese, fill='white', font=font_q)

        # 保存

        print(f"[保存] カードを保存中: {output_path}")
        bg.save(output_path)
        print(f"生成: {output_path}")

        row_data = row.to_dict()
        row_data["image"] = f"card_{i+1}.png"  # ←ここで上書き
        output_csv_rows.append(row_data)


        # 新しいCSVファイルに保存
        output_csv_path = "card_image_map.csv"
        df_output = pd.DataFrame(output_csv_rows)
        df_output.to_csv(output_csv_path, index=False, encoding='utf-8-sig')
        print(f"[完了] 対応CSVファイルを出力しました: {output_csv_path}")

    except Exception as e:
        print(f"[エラー] 行 {i+1} をスキップ: {e}")
        continue
