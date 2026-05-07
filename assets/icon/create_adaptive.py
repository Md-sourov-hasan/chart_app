from PIL import Image, ImageDraw

# Create adaptive icon (transparent background)
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))  # Transparent background
draw = ImageDraw.Draw(img)

# Draw bar chart (white)
bar_width = 80
bar_spacing = 40
bars_heights = [240, 390, 310, 470, 330]
start_x = (size - (len(bars_heights) * bar_width + (len(bars_heights) - 1) * bar_spacing)) // 2
base_y = size - 200

for i, height in enumerate(bars_heights):
    bar_x = start_x + i * (bar_width + bar_spacing)
    bar_y = base_y - height
    draw.rectangle([bar_x, bar_y, bar_x + bar_width, base_y], fill=(255, 255, 255, 255))

# Draw AI text (white)
text = 'AI'
text_x = size // 2 - 120
text_y = size // 2 - 50
draw.text((text_x, text_y), text, fill=(255, 255, 255, 255))

img.save('app_icon_adaptive.png')
print('Adaptive icon created successfully!')
