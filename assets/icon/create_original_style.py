from PIL import Image, ImageDraw
import math

# Create original style app icon
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Draw gradient background (blue to purple)
for y in range(size):
    for x in range(size):
        # Calculate gradient from top-left to bottom-right
        factor = (x + y) / (2 * size)
        
        if factor < 0.5:
            r = int(30 + (124 - 30) * factor * 2)    # #1E3A8A to #7C3AED
            g = int(58 + (58 - 58) * factor * 2)
            b = int(138 + (237 - 138) * factor * 2)
        else:
            r = int(124 + (236 - 124) * (factor - 0.5) * 2)  # #7C3AED to #EC4899
            g = int(58 + (72 - 58) * (factor - 0.5) * 2)
            b = int(237 + (153 - 237) * (factor - 0.5) * 2)
        
        # Check if inside rounded rectangle
        center_x, center_y = size // 2, size // 2
        dx = abs(x - center_x)
        dy = abs(y - center_y)
        
        if dx < size // 2 - 184 and dy < size // 2 - 184:
            img.putpixel((x, y), (r, g, b, 255))
        elif dx < size // 2 and dy < size // 2:
            # Check corner curve
            corner_x = dx - (size // 2 - 184)
            corner_y = dy - (size // 2 - 184)
            if corner_x >= 0 and corner_y >= 0:
                if math.sqrt(corner_x**2 + corner_y**2) <= 184:
                    img.putpixel((x, y), (r, g, b, 255))

# Draw white circle for chart container
circle_center = (size // 2, size // 2)
circle_radius = 280
draw.ellipse([circle_center[0] - circle_radius, circle_center[1] - circle_radius,
              circle_center[0] + circle_radius, circle_center[1] + circle_radius], 
             fill=(255, 255, 255, 255))

# Draw bar chart (purple bars)
bar_width = 50
bar_spacing = 20
bars_heights = [150, 250, 200, 300, 225]  # Same heights as original
start_x = circle_center[0] - (len(bars_heights) * bar_width + (len(bars_heights) - 1) * bar_spacing) // 2
base_y = circle_center[1] + 100

for i, height in enumerate(bars_heights):
    bar_x = start_x + i * (bar_width + bar_spacing)
    bar_y = base_y - height
    draw.rectangle([bar_x, bar_y, bar_x + bar_width, base_y], fill=(124, 58, 237, 255))

# Draw AI text (white)
text = 'AI'
text_x = circle_center[0] - 80
text_y = circle_center[1] - 50
draw.text((text_x, text_y), text, fill=(255, 255, 255, 255))

img.save('app_icon.png')
print('Original style app icon created successfully!')
