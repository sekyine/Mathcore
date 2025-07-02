import matplotlib.pyplot as plt
from PIL import Image, ImageDraw, ImageFont
import re
import textwrap


# **背景画像（固定サイズ: 1080×1350）**
background_size = (1080, 1350)
background = Image.open("background.png").convert("RGBA")
character = Image.open("character.png").convert("RGBA")
latex_formula = r"$E=mc^2+ \frac{1}{2}mv^2$"
background = background.resize(background_size)
# **ファイル名を安全な形に変換**
safe_filename = re.sub(r"[^a-zA-Z0-9]", "_", latex_formula) + ".png"


# **長い数式を適切に改行**
wrapped_formula = "\n".join(textwrap.wrap(latex_formula, width=25))  # 25文字ごとに改行


# **数式画像の作成**
fig, ax = plt.subplots(figsize=(8, 3))  # サイズを調整
ax.text(0.5, 0.5, wrapped_formula, fontsize=30, ha='center', va='center')
ax.axis('off')


# **数式画像を保存**
plt.savefig(safe_filename, transparent=True, bbox_inches='tight', pad_inches=0)


# **数式画像を読み込む**
formula_image = Image.open(safe_filename).convert("RGBA")


# **数式画像をリサイズ（幅を背景サイズに合わせる）**
formula_image = formula_image.resize((background_size[0], int(formula_image.height * background_size[0] / formula_image.width)))


# **数式画像を背景の上部に貼り付け**
background.paste(formula_image, (0, 10), formula_image)


# **キャラクター画像を背景の上に貼り付け（中央下部）**
char_x = (background_size[0] - character.width) // 2
char_y = background_size[1] - character.height - 10
background.paste(character, (char_x, char_y), character)


# **左上に数字を描画**
draw = ImageDraw.Draw(background)
font = ImageFont.truetype("arial.ttf", 100)
draw.text((10, 10), "1", fill="black", font=font)


# **数式に対応した出力名で保存**
background.save(safe_filename)