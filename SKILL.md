# GitHub Skill - Star Encounter

创建GitHub仓库并管理代码提交。

## 使用方法

```bash
# 创建仓库
gh repo create star-encounter --public --description "二次元角色互动与养成APP"

# 添加远程仓库
cd star-encounter
git remote add origin https://github.com/yourusername/star-encounter.git

# 提交代码
git add .
git commit -m "Initial commit: Star Encounter project"

# 推送到GitHub
git branch -M main
git push -u origin main
```

## 注意事项

- 使用公开仓库方便分享和协作
- 定期提交代码保持版本历史
- 重要更新前创建release tag
