from PIL import ImageFont, ImageDraw, Image

font_path = "./Fonts/NotoSerifCJKjp-Regular.otf"
font = ImageFont.truetype(font_path, 40)

# テスト画像に描画
img = Image.new("RGB", (400, 100), "white")
draw = ImageDraw.Draw(img)
draw.text((10, 30), "こんにちは世界", fill="black", font=font)

img.save("test_japanese_font.png")
print("✅ test_japanese_font.png を確認してください")