# Star Encounter - 星之邂逅

一款二次元角色互动与养成APP，让玩家与虚拟角色建立深度连接。

## 项目简介

Star Encounter 是一款以二次元文化为核心的角色互动应用，玩家可以：
- 与多个原创二次元角色进行对话互动
- 培养角色的好感度和能力
- 探索丰富的故事剧情
- 收集角色羁绊和成就

## 核心特性

- 🎭 **多角色系统** - 每个角色都有独特的性格、背景和对话风格
- 💬 **深度对话** - 基于NLP的对话系统，支持上下文理解和情感分析
- 🎮 **养成系统** - 角色升级、技能解锁、装备收集
- 📖 **剧情驱动** - 分章节的沉浸式故事体验
- 🎨 **精美UI** - 二次元风格界面，流畅动画效果

## 技术栈

- **前端**: Flutter 3.x
- **状态管理**: Provider
- **本地存储**: Hive
- **WebView**: webview_flutter
- **构建工具**: Gradle, GitHub Actions

## 项目结构

```
star-encounter/
├── android/           # Android 配置
├── assets/            # 资源文件
├── docs/              # 文档
├── lib/               # Flutter前端代码
│   ├── models/        # 数据模型
│   ├── screens/       # 页面
│   ├── services/      # 服务层
│   └── widgets/       # 组件
├── .github/           # GitHub Actions
├── BUILD.md           # 构建说明
├── pubspec.yaml       # 依赖配置
└── README.md          # 项目说明
```

## 开发进度

- [x] 项目规划
- [x] 技术选型
- [x] 基础框架搭建
- [x] 数据模型设计
- [x] GitHub Actions 配置
- [x] Android 构建配置
- [ ] 核心功能开发
- [ ] 测试
- [ ] 发布正式版

## 安装与运行

### 本地运行

```bash
# 克隆项目
git clone https://github.com/PheobeAI/star-encounter.git
cd star-encounter

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

### 构建 APK

```bash
# 构建 Debug APK
flutter build apk --debug

# 构建 Release APK
flutter build apk --release
```

## GitHub Actions 自动构建

项目使用 GitHub Actions 自动构建 Android APK。

**详细说明请查看 [BUILD.md](BUILD.md)**

### 触发条件

- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request
- 创建 Tag（以 `v` 开头）

### 下载 APK

1. 进入项目的 **Actions** 页面
2. 选择最新的 workflow run
3. 在底部 **Artifacts** 区域下载 `star-encounter-release`
4. 解压后即可安装使用

## 联系方式

- GitHub: https://github.com/PheobeAI/star-encounter
- Issues: https://github.com/PheobeAI/star-encounter/issues

## 许可证

MIT License
