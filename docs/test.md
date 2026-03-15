# Star Encounter - 测试文档

## 测试策略

### 1. 单元测试
- 测试数据模型
- 测试业务逻辑
- 测试工具函数

### 2. 集成测试
- 测试API接口
- 测试数据库操作
- 测试前后端交互

### 3. 端到端测试
- 测试用户完整流程
- 测试跨设备兼容性

## 测试环境

- **前端**: Flutter test
- **后端**: Jest + Supertest
- **数据库**: SQLite (内存模式)
- **CI/CD**: GitHub Actions

## 测试用例

### 1. 用户模块

#### 1.1 用户注册
- [x] 正常注册
- [x] 用户名已存在
- [x] 密码格式错误
- [x] 邮箱格式错误

#### 1.2 用户登录
- [x] 正确登录
- [x] 用户名不存在
- [x] 密码错误

### 2. 角色模块

#### 2.1 角色CRUD
- [x] 创建角色
- [x] 获取角色列表
- [x] 获取角色详情
- [x] 更新角色信息
- [x] 删除角色

#### 2.2 角色属性
- [x] 添加角色属性
- [x] 更新角色属性
- [x] 删除角色属性

### 3. 对话模块

#### 3.1 对话发送
- [x] 发送普通消息
- [x] 发送空消息
- [x] 发送超长消息
- [x] 发送特殊字符

#### 3.2 对话响应
- [x] 正常回复
- [x] 情感分析
- [x] 好感度计算

### 4. 养成模块

#### 4.1 等级系统
- [x] 经验值计算
- [x] 等级提升
- [x] 技能解锁

#### 4.2 技能系统
- [x] 技能添加
- [x] 技能升级
- [x] 技能删除

### 5. 剧情模块

#### 5.1 剧情加载
- [x] 加载章节列表
- [x] 加载章节内容
- [x] 加载剧情分支

#### 5.2 剧情选择
- [x] 正常选择
- [x] 无效选择
- [x] 选择后剧情跳转

## 测试覆盖率目标

- **前端**: > 80%
- **后端**: > 90%
- **整体**: > 85%

## 自动化测试

### 前端测试命令
```bash
flutter test
```

### 后端测试命令
```bash
npm test
```

### 代码覆盖率
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 持续集成

### GitHub Actions 配置
```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
    - name: Install dependencies
      run: flutter pub get
    - name: Run tests
      run: flutter test
    - name: Generate coverage
      run: flutter test --coverage
    - name: Upload coverage
      uses: codecov/codecov-action@v2
```

## 性能测试

### 前端性能测试
- 应用启动时间
- 内存占用
- CPU占用
- 页面切换流畅度

### 后端性能测试
- API响应时间
- 并发处理能力
- 数据库查询性能

### 测试工具
- Flutter Performance Overlay
- Chrome DevTools
- Lighthouse
- Apache Bench (ab)
