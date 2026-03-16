from PIL import Image, ImageDraw

sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192
}

base_path = r'C:\Users\Pheobe\.openclaw\workspaces\WS_Pheobe\projects\star-encounter\android\app\src\main\res'

for folder, size in sizes.items():
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 蓝色圆形背景
    draw.ellipse([0, 0, size, size], fill=(66, 133, 244, 255))
    
    # 白色星星 (简化版)
    center = size // 2
    radius = size * 0.35
    
    # 画一个简单的十字星
    points = [
        (center, center - radius),  # 上
        (center + radius * 0.3, center - radius * 0.3),
        (center + radius, center - radius * 0.3),  # 右上
        (center + radius * 0.4, center),
        (center + radius, center + radius * 0.3),  # 右下
        (center, center + radius * 0.6),  # 下
        (center - radius, center + radius * 0.3),  # 左下
        (center - radius * 0.4, center),
        (center - radius, center - radius * 0.3),  # 左上
        (center - radius * 0.3, center - radius * 0.3),
    ]
    draw.polygon(points, fill=(255, 255, 255, 255))
    
    path = f'{base_path}\\{folder}\\ic_launcher.png'
    img.save(path, 'PNG')
    print(f'Created {path}')
