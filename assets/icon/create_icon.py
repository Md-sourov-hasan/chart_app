from PIL import Image, ImageDraw

# Create a simple app icon
size = 1024
img = Image.new('RGBA', (size, size), (102, 126, 234, 255))  # Blue background
draw = ImageDraw.Draw(img)

# Draw rounded rectangle corners
corner_radius = 200
draw.rounded_rectangle([0, 0, size, size], radius=corner_radius, fill=(102, 126, 234, 255))

# Draw white circle
circle_center = (size // 2, size // 2)
circle_radius = 280
draw.ellipse([circle_center[0] - circle_radius, circle_center[1] - circle_radius,
              circle_center[0] + circle_radius, circle_center[1] + circle_radius], 
             fill=(255, 255, 255, 255))

# Draw simple bar chart
bar_width = 60
bar_spacing = 30
bars_heights = [180, 300, 240, 360, 270]
start_x = circle_center[0] - (len(bars_heights) * bar_width + (len(bars_heights) - 1) * bar_spacing) // 2
base_y = circle_center[1] + 100

for i, height in enumerate(bars_heights):
    bar_x = start_x + i * (bar_width + bar_spacing)
    bar_y = base_y - height
    draw.rectangle([bar_x, bar_y, bar_x + bar_width, base_y], fill=(118, 75, 162, 255))

# Draw AI text
text = 'AI'
text_x = circle_center[0] - 80
text_y = circle_center[1] + 200
draw.text((text_x, text_y), text, fill=(255, 255, 255, 255))

img.save('app_icon.png')
print('App icon created successfully!')
