# Star Encounter - API 文档

## 基础信息

- **Base URL**: `/api/v1`
- **Content-Type**: `application/json`
- **认证方式**: Bearer Token

## API 端点

### 1. 用户相关

#### 1.1 用户登录
```
POST /users/login
```

**请求参数**:
```json
{
  "username": "string",
  "password": "string"
}
```

**响应**:
```json
{
  "success": true,
  "data": {
    "token": "string",
    "user": {
      "id": "string",
      "username": "string"
    }
  }
}
```

#### 1.2 用户注册
```
POST /users/register
```

**请求参数**:
```json
{
  "username": "string",
  "password": "string",
  "email": "string"
}
```

**响应**:
```json
{
  "success": true,
  "data": {
    "token": "string",
    "user": {
      "id": "string",
      "username": "string"
    }
  }
}
```

### 2. 角色相关

#### 2.1 获取角色列表
```
GET /characters
```

**请求头**:
```
Authorization: Bearer {token}
```

**响应**:
```json
{
  "success": true,
  "data": [
    {
      "id": "string",
      "name": "string",
      "personality": {
        "tag": "string",
        "description": "string"
      },
      "appearance": {
        "height": "string",
        "hair_color": "string",
        "eye_color": "string"
      },
      "stats": {
        "level": 1,
        "exp": 0,
        "affection": 0
      }
    }
  ]
}
```

#### 2.2 获取角色详情
```
GET /characters/:id
```

**响应**:
```json
{
  "success": true,
  "data": {
    "id": "string",
    "name": "string",
    "personality": {...},
    "appearance": {...},
    "stats": {...},
    "skills": [...],
    "inventory": [...]
  }
}
```

### 3. 对话相关

#### 3.1 发送对话消息
```
POST /conversations/send
```

**请求参数**:
```json
{
  "character_id": "string",
  "message": "string",
  "context_id": "string" // 可选
}
```

**响应**:
```json
{
  "success": true,
  "data": {
    "message_id": "string",
    "character_id": "string",
    "reply": {
      "text": "string",
      "emotion": "string",
      "affection_change": 5
    },
    "context_id": "string"
  }
}
```

#### 3.2 获取对话历史
```
GET /conversations/:context_id
```

**响应**:
```json
{
  "success": true,
  "data": [
    {
      "message_id": "string",
      "sender": "user",
      "text": "string",
      "timestamp": "string"
    },
    {
      "message_id": "string",
      "sender": "character",
      "text": "string",
      "emotion": "string",
      "timestamp": "string"
    }
  ]
}
```

### 4. 养成相关

#### 4.1 角色升级
```
POST /characters/:id/levelup
```

**请求参数**:
```json
{
  "exp": 100
}
```

**响应**:
```json
{
  "success": true,
  "data": {
    "level": 2,
    "exp": 50,
    "new_skills": [...]
  }
}
```

#### 4.2 获取技能列表
```
GET /characters/:id/skills
```

**响应**:
```json
{
  "success": true,
  "data": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "level": 1,
      "max_level": 5
    }
  ]
}
```

### 5. 剧情相关

#### 5.1 获取剧情章节
```
GET /story/chapters
```

**响应**:
```json
{
  "success": true,
  "data": [
    {
      "id": "string",
      "title": "string",
      "chapter": 1,
      "unlocked": true
    }
  ]
}
```

#### 5.2 获取剧情内容
```
GET /story/chapters/:id
```

**响应**:
```json
{
  "success": true,
  "data": {
    "id": "string",
    "title": "string",
    "content": "string",
    "choices": [
      {
        "id": "string",
        "text": "string",
        "next_chapter": "string"
      }
    ]
  }
}
```

## 错误码

- `200`: 成功
- `400`: 请求参数错误
- `401`: 未授权
- `404`: 资源不存在
- `500`: 服务器错误

## 分页

所有列表接口支持分页：

```
GET /characters?page=1&limit=20
```

参数:
- `page`: 页码 (默认: 1)
- `limit`: 每页数量 (默认: 20, 最大: 100)
