# 构建说明

## GitHub Actions 自动构建

本项目使用 GitHub Actions 自动构建 Android APK。

### 触发条件

- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request
- 创建 Tag（以 `v` 开头）

### 构建产物

每次构建完成后，会自动上传以下文件：

1. **Debug APK**: `star-encounter-debug.apk`
2. **Release APK**: `star-encounter-release.apk`

构建产物会保留 30 天。

### 下载构建的 APK

#### 方式 1: 从 GitHub Actions 页面下载

1. 进入项目的 Actions 页面
2. 选择最新的 workflow run
3. 在页面底部找到 "Artifacts" 部分
4. 点击 `star-encounter-release` 下载

#### 方式 2: 从 Release 下载（当有 Tag 时）

1. 进入项目的 Releases 页面
2. 找到对应的版本标签（如 `v1.0.0`）
3. 在附件中下载 `app-release.apk`

### 手动构建

如果需要本地构建，请使用以下命令：

```bash
# 安装依赖
flutter pub get

# 生成代码（如果使用 Hive）
flutter pub run build_runner build --delete-conflicting-outputs

# 构建 Debug APK
flutter build apk --debug

# 构建 Release APK
flutter build apk --release
```

构建产物位于：`build/app/outputs/flutter-apk/`

### 注意事项

1. **网络问题**: 如果遇到 GitHub 连接问题，请检查网络设置
2. **Flutter SDK**: 确保 Flutter SDK 已正确安装
3. **依赖安装**: 首次构建可能需要下载大量依赖，请耐心等待

## 版本管理

使用 Git Tag 来发布新版本：

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

发布 Tag 后，GitHub Actions 会自动创建 Release 并上传 APK。
