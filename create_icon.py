from PIL import Image, ImageDraw
import os

# 创建一个 1024x1024 的图标
img = Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# 绘制一个简单的圆形背景 (蓝色)
draw.ellipse([0, 0, 1024, 1024], fill=(66, 133, 244, 255))

# 绘制一个星星
# 简单的白色星星形状
points = [
    (512, 150),
    (620, 380),
    (870, 380),
    (680, 540),
    (740, 800),
    (512, 640),
    (284, 800),
    (344, 540),
    (154, 380),
    (404, 380)
]
draw.polygon(points, fill=(255, 255, 255, 255))

# 保存图标
output_path = r'C:\Users\Pheobe\.openclaw\workspaces\WS_Pheobe\projects\star-encounter\assets\images\icon.png'
img.save(output_path, 'PNG')
print(f'Icon created at {output_path}')
