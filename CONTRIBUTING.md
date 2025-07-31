# 贡献指南

感谢您对 ResMan 项目的关注！我们欢迎各种形式的贡献。

## 如何贡献

### 报告问题

如果您发现了问题，请创建一个 Issue 并包含以下信息：

- **操作系统和版本**（Windows 10/11, Ubuntu 20.04, macOS 12.0 等）
- **脚本版本**（从 `resman -v` 获取）
- **错误信息**（完整的错误输出）
- **复现步骤**（详细的操作步骤）
- **预期行为**和**实际行为**

### 提交代码

1. **Fork 本仓库**
2. **创建功能分支**：`git checkout -b feature/amazing-feature`
3. **编写代码**并遵循现有的代码风格
4. **测试您的更改**在目标平台上
5. **提交更改**：`git commit -m "Add amazing feature"`
6. **推送分支**：`git push origin feature/amazing-feature`
7. **创建 Pull Request**

## 开发规范

### 代码风格

**PowerShell (Windows)**:
- 使用 PascalCase 命名函数：`New-ResearchProject`
- 使用 `$CamelCase` 命名变量：`$ProjectName`
- 添加适当的注释和文档

**Bash (Linux/macOS)**:
- 使用 snake_case 命名函数：`new_research_project`
- 使用小写变量名：`project_name`
- 使用 `readonly` 声明常量
- 遵循 ShellCheck 建议

### 跨平台一致性

- **功能完全一致**：所有平台版本必须提供相同的功能
- **用户体验统一**：命令行参数和输出格式保持一致
- **错误处理标准化**：使用统一的错误信息和退出码
- **配置文件兼容**：确保配置文件在平台间通用

### 测试要求

提交代码前请测试：

1. **基本功能**：
   ```bash
   resman -v          # 版本信息
   resman -n "test"   # 创建项目
   resman -l          # 列出项目
   resman -j "test"   # 添加日志
   resman -s "test"   # Git同步
   resman -b "test"   # 备份
   ```

2. **边界情况**：
   - 无效的项目名称
   - 不存在的目录
   - 网络连接问题
   - 权限不足的情况

3. **Git集成**：
   - 有/无 Git CLI 工具的情况
   - 不同的Git平台（GitHub/GitLab）
   - SSH和HTTPS协议

## 开发环境设置

### Windows
```powershell
# 安装 PowerShell 5.1+
# 安装 Git
# 可选：安装 GitHub CLI
winget install GitHub.cli
```

### Linux
```bash
# Ubuntu/Debian
sudo apt install git jq bc rsync shellcheck

# CentOS/RHEL
sudo yum install git jq bc rsync
```

### macOS
```bash
# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装依赖
brew install git jq bc rsync shellcheck
```

## 项目结构

```
resman/
├── resman.ps1          # Windows PowerShell版本
├── resman-linux.sh     # Linux Bash版本
├── resman-macos.sh     # macOS Bash版本
├── README.md           # 主文档
├── CONTRIBUTING.md     # 本文件
├── LICENSE             # MIT许可证
└── CLAUDE.md          # Claude AI开发指引
```

## 发布流程

1. **更新版本号**在所有脚本文件中
2. **更新文档**反映新功能或变更
3. **创建 Git tag**：`git tag v1.x.x`
4. **推送 tag**：`git push origin v1.x.x`
5. **创建 GitHub Release**

## 获取帮助

- **GitHub Issues**：报告问题和功能请求
- **GitHub Discussions**：社区讨论和问题解答
- **邮件**：直接联系维护者

## 行为准则

请遵循以下原则：

- **尊重**所有贡献者和用户
- **包容**不同背景和经验水平的人
- **建设性**地提供反馈和建议
- **专业**地处理分歧和冲突

## 许可证

通过贡献代码，您同意您的贡献将在 MIT 许可证下发布。

---

再次感谢您的贡献！🎉