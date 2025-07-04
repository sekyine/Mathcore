import pandas as pd
from PIL import Image, ImageDraw, ImageFont
import matplotlib.pyplot as plt
import io
import os

# LaTeX数式を画像として描画する関数
def render_latex(formula, fontsize=30, color='grey'):
    fig, ax = plt.subplots(figsize=(5, 1))
    ax.axis('off')
    plt.text(0.5, 0.5, f"${formula}$", fontsize=fontsize, ha='center', va='center')
    buf = io.BytesIO()
    plt.savefig(buf, format='png', bbox_inches='tight', pad_inches=0.2, transparent=True)
    plt.close(fig)
    buf.seek(0)
    return Image.open(buf)

# 読み込みとパスの設定
df = pd.read_csv('card_create.csv', encoding='shift_jis')
OUTPUT_DIR = './app/assets/images/output_cards'
BACKGROUND_PATH = './app/assets/images/background.png'
FONT_PATH = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'  # 適宜変更
IMAGE_DIR = './app/assets/images/'
CARD_WIDTH, CARD_HEIGHT = 1080, 1350
os.makedirs(OUTPUT_DIR, exist_ok=True)

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

        # 描画用準備
        draw = ImageDraw.Draw(bg)
        font_st = ImageFont.truetype(FONT_PATH, 40)
        font_q = ImageFont.truetype(FONT_PATH, 30)

        # 左上にレアリティ（★）を表示
        draw.text((40, 30), "★" * int(row['st']), fill='gold', font=font_st)

        # LaTeXで描いた数式画像を貼り付け
        print(f"[描画] LaTeX数式を描画中...")
        latex_img = render_latex(row['question'], color='grey')
        latex_w, latex_h = latex_img.size
        latex_x = (W - latex_w) // 2
        latex_y = int(H * 0.1)  # 上寄り5%位置
        bg.paste(latex_img, (latex_x, latex_y), latex_img)

        # 保存

        print(f"[保存] カードを保存中: {output_path}")
        bg.save(output_path)
        print(f"生成: {output_path}")

    except Exception as e:
        print(f"[エラー] 行 {i+1} をスキップ: {e}")
        continue
