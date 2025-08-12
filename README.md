# ResMan - 研究项目管理工具

一个简洁高效的研究项目管理工具，专为科研工作者设计，提供项目结构化管理、Git版本控制和自动化备份功能。

## ✨ 核心功能

- **📁 项目管理** - 标准化项目结构，自动创建目录和文件
- **🔄 Git集成** - 智能同步代码和文档，本地版本控制
- **🛠️ 简化配置** - 自动检查Git配置，简化项目初始化流程
- **💾 自动备份** - 定期备份项目数据，防止数据丢失
- **📝 研究日志** - 记录研究进展和重要发现
- **🧹 文件清理** - 清理临时文件和缓存，保持项目整洁

## 🚀 快速开始

### Windows
```powershell
# 下载脚本
# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 运行脚本（首次运行会自动配置）
.\resman.ps1 -v

# 创建新项目
.\resman.ps1 -n "my-research-project"
```

### Linux
```bash
# 安装依赖
sudo apt install jq bc git  # Ubuntu/Debian
sudo yum install jq bc git  # CentOS/RHEL

# 设置执行权限
chmod +x resman.sh

# 运行脚本（首次运行会自动配置）
./resman.sh -v

# 创建新项目
./resman.sh -n "my-research-project"
```

## 📖 使用指南

### 基础操作
```bash
# 查看帮助
resman -h

# 列出所有项目
resman -l

# 创建新项目（自动Git初始化）
resman -n "project-name"

# 将现有文件夹转为项目
resman -i "existing-folder"
```

### 日常工作流
```bash
# 添加研究日志
resman -j "project-name"

# 同步到Git（代码+文档）
resman -s "project-name"

# 完整同步（包含结果文件）
resman -sa "project-name"

# 备份项目
resman -b "project-name"

# 一键工作流（日志+同步+备份）
resman -a "project-name"
```

### 项目维护
```bash
# 生成项目报告
resman -r "project-name"

# 清理临时文件
resman -c "project-name"

# 检查Git状态
resman -gs
```

## 📁 项目结构

ResMan创建的标准项目结构：

```
project-name/
├── README.md              # 项目说明
├── research_log.md        # 研究日志
├── data/
│   ├── raw/              # 原始数据
│   ├── processed/        # 处理后数据
│   └── intermediate/     # 中间数据
├── code/                 # 代码文件
├── results/
│   ├── figures/          # 图表
│   └── reports/          # 报告
├── docs/                 # 文档
├── .gitignore           # Git忽略文件
├── data_lineage.json    # 数据血缘
└── .resman              # 项目标识
```

## ⚙️ 配置说明

配置文件位置：
- **Windows**: `%USERPROFILE%\.research_config.json`
- **Linux**: `~/.research_config.json`

主要配置项：
```json
{
  "RESEARCH_ROOT": "/path/to/research",
  "BACKUP_ROOT": "/path/to/backup",
  "BACKUP_KEEP_DAYS": 30,
  "GIT_AUTO_PUSH": true
}
```

## 🔧 安装配置

### 依赖要求

**Windows**:
- PowerShell 5.1+
- Git

**Linux**:
- Bash
- jq, bc, git

### 永久安装

**Windows**:
```powershell
# 方法1：添加到PATH
$env:PATH += ";C:\Tools\ResMan"
[Environment]::SetEnvironmentVariable("PATH", $env:PATH, [EnvironmentVariableTarget]::User)

# 方法2：PowerShell别名
Add-Content $PROFILE 'Set-Alias resman "C:\Tools\ResMan\resman.ps1"'
```

**Linux**:
```bash
# 1. 推荐将脚本放置在个人bin目录
mkdir -p ~/bin
# 将下载的 resman.sh 移动并重命名
cp resman.sh ~/bin/resman
chmod +x ~/bin/resman

# 2. 确保 ~/bin 在您的 PATH 环境变量中
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 🤝 Git集成

ResMan专注于本地研究流程管理：

1. **本地Git初始化** - 创建项目时自动初始化本地Git仓库
2. **智能同步** - 根据文件类型智能选择同步内容
3. **用户配置** - 自动检查和配置Git用户信息
4. **版本控制** - 支持本地版本历史管理和备份

**注意**: 远程仓库需要手动创建，然后使用 `git remote add origin <url>` 连接

## 📋 命令参考

| 命令 | 功能 | 示例 |
|------|------|------|
| `-h` | 显示帮助 | `resman -h` |
| `-v` | 显示版本 | `resman -v` |
| `-l` | 列出项目 | `resman -l` |
| `-n` | 创建新项目 | `resman -n "project"` |
| `-i` | 初始化现有文件夹 | `resman -i "folder"` |
| `-j` | 添加研究日志 | `resman -j "project"` |
| `-s` | Git同步（基础） | `resman -s "project"` |
| `-sa` | Git同步（完整） | `resman -sa "project"` |
| `-b` | 备份项目 | `resman -b "project"` |
| `-r` | 生成报告 | `resman -r "project"` |
| `-c` | 清理文件 | `resman -c "project"` |
| `-a` | 自动化流程 | `resman -a "project"` |
| `-gs` | Git配置信息 | `resman -gs` |

## 🐛 常见问题

**Q: Git初始化失败？**  
A: 检查Git用户配置，运行 `git config --global user.name` 和 `git config --global user.email`

**Q: 如何连接远程仓库？**  
A: 项目创建后，手动在GitHub/GitLab等平台创建仓库，然后使用 `git remote add origin <url>` 连接

**Q: 如何推送到远程仓库？**  
A: 连接远程仓库后，使用 `git push -u origin main` 进行首次推送

**Q: 权限错误？**  
A: 确保对目标目录有写权限，Windows用户可能需要以管理员身份运行

**Q: 配置文件损坏？**  
A: 删除配置文件重新运行脚本：`rm ~/.research_config.json`

---

**版本**: 1.0.0 | **作者**: Maoye | **许可证**: MIT