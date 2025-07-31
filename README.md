# ResMan 研究项目管理工具

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey)](https://github.com/your-username/resman)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)](https://docs.microsoft.com/en-us/powershell/)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green)](https://www.gnu.org/software/bash/)

**ResMan** (Research Manager) 是一个跨平台的研究项目管理工具，专为学术研究和科研工作设计。它集成了项目管理、版本控制、自动备份和研究日志等功能，帮助研究人员高效地组织和管理研究项目。

## 目录
- [特性概览](#特性概览)
- [支持平台](#支持平台)
- [快速开始](#快速开始)
- [详细文档](#详细文档)
- [安装指南](#安装指南)
- [使用示例](#使用示例)
- [配置说明](#配置说明)
- [最佳实践](#最佳实践)
- [故障排除](#故障排除)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

---

## 特性概览

### 🎯 项目结构化管理
- 标准化的研究项目目录结构
- 项目标识和元数据管理
- 智能项目检测和列表显示

### 📚 研究日志系统
- 结构化的研究记录
- 自动Git信息关联
- 时间线追踪

### 🔄 Git版本控制集成
- 自动创建远程仓库 (GitHub/GitLab/Gitee)
- 智能文件过滤和同步
- SSH/HTTPS协议支持

### 💾 自动化备份系统
- 日备份和周备份策略
- 增量备份优化
- 旧备份自动清理

### 📊 项目状态报告
- 自动生成项目概览
- 文件统计和Git状态
- 最近活动追踪

### 🧹 维护工具
- Python缓存清理
- Jupyter检查点清理
- 临时文件管理

## 支持平台

ResMan 提供三个平台特定的脚本版本：

| 平台 | 脚本文件 | 依赖 | 安装方式 |
|------|----------|------|----------|
| **Windows** | `resman.ps1` | PowerShell 5.1+, Git | 内置/可选 Git CLI |
| **Linux** | `resman-linux.sh` | Bash, jq, bc, rsync, git | `apt install` / `yum install` |
| **macOS** | `resman-macos.sh` | Bash, jq, bc, rsync, git | `brew install` |

## 快速开始

### Windows
```powershell
# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 运行脚本
.\resman.ps1 -h

# 创建新项目
.\resman.ps1 -n "my-research-project"
```

### Linux
```bash
# 安装依赖
sudo apt install jq bc rsync git  # Ubuntu/Debian
sudo yum install jq bc rsync git   # CentOS/RHEL

# 设置执行权限
chmod +x resman-linux.sh

# 运行脚本
./resman-linux.sh -h

# 创建新项目
./resman-linux.sh -n "my-research-project"
```

### macOS
```bash
# 安装依赖（使用 Homebrew）
brew install jq bc rsync git

# 设置执行权限
chmod +x resman-macos.sh

# 运行脚本
./resman-macos.sh -h

# 创建新项目
./resman-macos.sh -n "my-research-project"
```

## 详细文档

### 工具概述

**ResMan** 专为研究项目设计，旨在简化研究工作流程，提高科研效率。

### 适用场景

- **学术研究项目**：论文写作、数据分析、实验记录
- **科研团队协作**：代码共享、结果同步、进度追踪
- **长期研究项目**：版本管理、备份策略、知识积累
- **多项目管理**：统一工作流、标准化结构

### 项目结构

ResMan 创建标准化的项目结构：

```
my-project/
├── data/
│   ├── raw/           # 原始数据，不可修改
│   ├── processed/     # 预处理后的数据
│   └── intermediate/  # 中间结果
├── code/              # 源代码
├── results/
│   ├── figures/       # 图表和可视化
│   ├── outcome/       # 主要结果
│   └── reports/       # 报告文档
├── docs/              # 项目文档
├── README.md          # 项目说明
├── research_log.md    # 研究日志
├── data_lineage.json  # 数据处理追踪
├── .resman           # 项目标识文件
└── .gitignore        # Git忽略规则
```

## 安装指南

### 依赖要求

所有平台都需要安装Git作为基础依赖：

**Windows:**
- PowerShell 5.1+ (Windows 10/11 内置)
- Git (必需)
- GitHub CLI (`gh`) 或 GitLab CLI (`glab`) (可选，用于自动创建远程仓库)

**Linux:**
- Bash 4.0+
- `jq` - JSON处理工具
- `bc` - 数学计算工具  
- `rsync` - 文件同步工具
- `git` - 版本控制

**macOS:**
- Bash 4.0+
- `jq` - JSON处理工具
- `bc` - 数学计算工具
- `rsync` - 文件同步工具  
- `git` - 版本控制

### 安装方法

#### Windows
```powershell
# 1. 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. 下载脚本到合适位置
# 推荐创建专用目录：C:\Tools\ResMan\
mkdir "C:\Tools\ResMan"
# 将 resman.ps1 放入该目录

# 3. 永久配置 - 方法一：添加到环境变量PATH
# 打开系统环境变量设置，将 C:\Tools\ResMan 添加到PATH
# 或使用PowerShell命令：
$env:PATH += ";C:\Tools\ResMan"
[Environment]::SetEnvironmentVariable("PATH", $env:PATH, [EnvironmentVariableTarget]::User)

# 3. 永久配置 - 方法二：PowerShell配置文件别名
# 检查配置文件是否存在
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force }
# 添加别名到配置文件
Add-Content $PROFILE 'Set-Alias resman "C:\Tools\ResMan\resman.ps1"'

# 4. 重启PowerShell或重新加载配置
. $PROFILE

# 5. 安装Git CLI工具（可选）
winget install GitHub.cli
# 或
choco install gh

# 6. 验证安装
resman -v
```

#### Linux (Ubuntu/Debian)
```bash
# 1. 安装依赖
sudo apt update
sudo apt install jq bc rsync git

# 2. 下载并安装脚本
# 推荐放置位置：~/bin/ 或 /usr/local/bin/
mkdir -p ~/bin
# 将 resman-linux.sh 放入 ~/bin/ 目录
cp resman-linux.sh ~/bin/resman-linux.sh
chmod +x ~/bin/resman-linux.sh

# 3. 永久配置 - 方法一：符号链接（推荐）
sudo ln -s ~/bin/resman-linux.sh /usr/local/bin/resman

# 3. 永久配置 - 方法二：添加到PATH和别名
# 添加到 ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
echo 'alias resman="$HOME/bin/resman-linux.sh"' >> ~/.bashrc

# 4. 重新加载shell配置
source ~/.bashrc

# 5. 安装Git CLI工具（可选）
# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# 6. 验证安装
resman -v
```

#### Linux (CentOS/RHEL)
```bash
# 1. 安装依赖
sudo yum install epel-release
sudo yum install jq bc rsync git

# 2-6. 后续步骤与Ubuntu/Debian相同
# 参考上面的Ubuntu/Debian安装方法
```

#### macOS
```bash
# 1. 安装Homebrew（如果未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 安装依赖
brew install jq bc rsync git

# 3. 下载并安装脚本
# 推荐放置位置：~/bin/ 或 /usr/local/bin/
mkdir -p ~/bin
# 将 resman-macos.sh 放入 ~/bin/ 目录
cp resman-macos.sh ~/bin/resman-macos.sh
chmod +x ~/bin/resman-macos.sh

# 4. 永久配置 - 方法一：符号链接（推荐）
sudo ln -s ~/bin/resman-macos.sh /usr/local/bin/resman

# 4. 永久配置 - 方法二：添加到PATH和别名
# 对于bash用户，添加到 ~/.bash_profile
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bash_profile
echo 'alias resman="$HOME/bin/resman-macos.sh"' >> ~/.bash_profile

# 对于zsh用户（macOS默认），添加到 ~/.zshrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
echo 'alias resman="$HOME/bin/resman-macos.sh"' >> ~/.zshrc

# 5. 重新加载shell配置
source ~/.bash_profile  # 对于bash用户
source ~/.zshrc         # 对于zsh用户

# 6. 安装Git CLI工具（可选）
brew install gh    # GitHub CLI
# 或
brew install glab  # GitLab CLI

# 7. 验证安装
resman -v
```

### 首次运行

所有平台的首次运行都是相似的：

```bash
# 检查版本和初始化配置
resman -v

# 首次运行会自动引导配置：
# - 研究项目根目录
# - 备份目录
# - Git相关设置
```

### 创建第一个项目

```bash
# 创建新的研究项目
resman -n "my-first-research"

# 项目将自动创建：
# - 标准目录结构
# - Git仓库初始化
# - 远程仓库创建（如果配置）
# - 项目标识文件
```

---

## 功能详解

### 项目管理

#### 项目创建 (`-n, --new`)
创建具有标准结构的新研究项目：

```
my-project/
├── data/
│   ├── raw/           # 原始数据，不可修改
│   ├── processed/     # 预处理后的数据
│   └── intermediate/  # 中间结果
├── code/              # 源代码
├── results/
│   ├── figures/       # 图表和可视化
│   ├── outcome/       # 主要结果
│   └── reports/       # 报告文档
├── docs/              # 项目文档
├── README.md          # 项目说明
├── research_log.md    # 研究日志
├── data_lineage.json  # 数据处理追踪
├── .resman           # 项目标识文件
└── .gitignore        # Git忽略规则
```

#### 项目标记 (`-i, --init`)
将现有文件夹标记为研究项目：
- 创建 `.resman` 标识文件
- 添加基础文档模板
- 保持原有文件结构

#### 项目列表 (`-l, --list`)
显示所有研究项目的概览：
- 项目名称和最后修改时间
- Git状态（同步状态、未提交变更数）
- 只显示包含 `.resman` 标识的项目

### 研究日志系统

#### 添加日志条目 (`-j, --journal`)
交互式添加研究记录：

```markdown
## 2025-01-31 14:30:25

### 工作内容
今日完成了数据预处理流程，处理了地震目录数据，
修复了时间格式解析问题。

### 技术信息
- Git提交: a1b2c3d
- 修改文件: 
  - data_processing.py
  - utils/time_parser.py

---
```

自动包含的信息：
- 时间戳
- Git提交哈希
- 修改文件列表
- 用户输入的工作内容

### Git版本控制

#### 基础同步 (`-s, --sync`)
同步代码和文档到Git，不包含大文件：
- 自动添加：`code/`, `docs/`, `README.md`, `research_log.md`
- 添加处理后的数据：`data/processed/`
- 添加图表和报告：`results/figures/`, `results/reports/`

#### 完全同步 (`-sa, --sync-all`)
包含小型结果文件的完全同步：
- 包含基础同步的所有内容
- 添加小于配置大小限制的结果文件
- 自动跳过大文件并给出提示

#### 交互式提交流程
1. 检查是否有变更需要提交
2. 提示用户输入提交信息
3. 自动推送到远程仓库（如果配置）

### 备份系统

#### 备份策略 (`-b, --backup`)
多层次备份策略：

**日备份**：
- 目标：`{备份根目录}/daily/{时间戳}/`
- 使用增量备份（只复制变更文件）
- 保留天数可配置（默认30天）

**周备份**：
- 目标：`{备份根目录}/weekly/yyyy_week_N/`
- 每周一自动执行完整备份
- 保留90天

**备份选项**：
```powershell
resman -b                    # 备份所有项目
resman -b "specific-project" # 备份指定项目
```

### 项目报告

#### 状态报告 (`-r, --report`)
生成详细的项目状态报告：

```markdown
# ProjectName 项目状态报告

**生成时间**: 2025-01-31 14:30:25

## 项目结构
```
./data
./code
./results
```

## 文件统计
- **data/raw**: 15 个文件, 2.34 MB
- **code**: 8 个文件, 0.45 MB
- **results/figures**: 12 个文件, 5.67 MB

## Git状态
- **分支**: main
- **最新提交**: a1b2c3d 修复数据处理bug
- **未提交变更**: 3 个文件

## 最近活动
### 最近修改文件 (7天内)
- ./code/analysis.py
- ./results/summary.md
```

### 清理工具

#### 中间文件清理 (`-c, --clean`)
清理项目中的临时和中间文件：
- Python缓存：`__pycache__/`, `*.pyc`
- Jupyter检查点：`.ipynb_checkpoints/`
- 临时文件：`*.tmp`, `*.temp`
- 中间数据：`data/intermediate/*.tmp`

### 自动化工作流

#### 完整工作流 (`-a, --auto`)
执行完整的研究工作流程：
1. **添加研究日志**：交互式记录今日工作
2. **同步到Git**：提交代码和文档变更
3. **执行备份**：创建项目备份

这是日常结束研究工作时的推荐流程。

---

## 命令参考

### 基础命令

| 命令 | 长格式 | 说明 | 需要项目名 |
|------|--------|------|-----------|
| `-h` | `--help` | 显示帮助信息 | ❌ |
| `-v` | `--version` | 显示版本信息 | ❌ |
| `-l` | `--list` | 列出所有项目 | ❌ |

### 项目管理

| 命令 | 长格式 | 说明 | 需要项目名 |
|------|--------|------|-----------|
| `-n` | `--new` | 创建新项目 | ✅ |
| `-i` | `--init` | 标记现有文件夹为项目 | ✅ |
| `-r` | `--report` | 生成项目状态报告 | ✅ |
| `-c` | `--clean` | 清理中间文件 | ✅ |

### Git和同步

| 命令 | 长格式 | 说明 | 需要项目名 |
|------|--------|------|-----------|
| `-s` | `--sync` | 同步到Git（基础） | ✅ |
| `-sa` | `--sync-all` | 同步到Git（包含结果） | ✅ |
| `-gs` | `--git-status` | 检查Git工具状态 | ❌ |

### 其他功能

| 命令 | 长格式 | 说明 | 需要项目名 |
|------|--------|------|-----------|
| `-j` | `--journal` | 添加研究日志 | ✅ |
| `-b` | `--backup` | 备份项目 | ❌ (可选) |
| `-a` | `--auto` | 自动化工作流 | ✅ |

## 使用示例

### 基础操作
```bash
# 所有平台使用方式相同
resman -h                           # 查看帮助
resman -l                           # 列出所有项目
resman -n "earthquake-analysis"     # 创建新项目
```

### 日常工作流
```bash
# 记录研究进展
resman -j "earthquake-analysis"     # 添加研究日志

# 同步代码到Git
resman -s "earthquake-analysis"     # 基础同步（代码+文档）
resman -sa "earthquake-analysis"    # 完全同步（包含结果文件）

# 备份项目
resman -b "earthquake-analysis"     # 备份指定项目
resman -b                           # 备份所有项目
```

### Git增强功能
```bash
# 检查Git环境
resman -gs                          # 检查Git CLI工具状态
```

### 自动化工作流
```bash
# 一键完成：日志记录 → Git同步 → 项目备份
resman -a "earthquake-analysis"     
```

### 项目维护
```bash
# 生成项目报告
resman -r "earthquake-analysis"     # 项目状态报告

# 清理中间文件
resman -c "earthquake-analysis"     # 清理临时文件和缓存

# 标记现有文件夹为项目（支持交互式Git初始化）
resman -i "existing-folder"         # 转换现有文件夹
```

## 配置说明

### 配置文件位置

ResMan 在所有平台使用相同的配置文件格式：

**Windows:** `%USERPROFILE%\.research_config.json`  
**Linux/macOS:** `~/.research_config.json`

### 跨平台配置迁移

配置文件格式完全相同，可以直接在平台间复制：

```bash
# 从Windows复制到Linux/macOS
cp /mnt/c/Users/username/.research_config.json ~/.research_config.json

# 或者手动复制配置内容
```

### 平台差异适配

虽然配置文件相同，但路径需要根据平台调整：

```json
{
    // Windows路径
    "RESEARCH_ROOT": "C:\\Users\\username\\research",
    "BACKUP_ROOT": "C:\\Users\\username\\research\\_backup",
    
    // Linux/macOS路径  
    "RESEARCH_ROOT": "/home/username/research",
    "BACKUP_ROOT": "/home/username/research/_backup"
}
```

### 配置项说明

```json
{
  "RESEARCH_ROOT": "C:\\Users\\Username\\research",
  "BACKUP_ROOT": "C:\\Users\\Username\\research\\_backup",
  "BACKUP_KEEP_DAYS": 30,
  "MAX_FILE_SIZE_MB": 100,
  "GIT_AUTO_PUSH": true,
  "DEFAULT_REMOTE": "origin",
  "LOG_LEVEL": "INFO",
  "ENABLE_COLOR": true,
  "CREATED_DATE": "2025-01-31 14:30:25",
  
  "GIT_PLATFORM": "github",
  "GIT_USERNAME": "your-username",
  "GIT_DEFAULT_VISIBILITY": "private",
  "GIT_AUTO_CREATE_REMOTE": true,
  "GIT_CLI_TOOL": "",
  "GIT_SSH_PREFERRED": true
}
```

### 核心配置项

**目录设置**
- `RESEARCH_ROOT`: 研究项目根目录
- `BACKUP_ROOT`: 备份存储目录

**备份策略**
- `BACKUP_KEEP_DAYS`: 日备份保留天数 (默认: 30)
- `MAX_FILE_SIZE_MB`: 同步文件大小限制 (默认: 100MB)

**Git基础配置**
- `GIT_AUTO_PUSH`: 是否自动推送到远程 (默认: true)
- `DEFAULT_REMOTE`: 默认远程仓库名称 (默认: "origin")

### Git增强配置

**平台设置**
- `GIT_PLATFORM`: Git托管平台
  - `"github"`: GitHub
  - `"gitlab"`: GitLab  
  - `"gitee"`: Gitee (码云)

**用户信息**
- `GIT_USERNAME`: Git用户名（用于生成仓库URL）

**仓库设置**
- `GIT_DEFAULT_VISIBILITY`: 默认仓库可见性
  - `"private"`: 私有仓库
  - `"public"`: 公开仓库
- `GIT_AUTO_CREATE_REMOTE`: 创建项目时是否自动创建远程仓库

**连接设置**
- `GIT_SSH_PREFERRED`: 是否优先使用SSH协议 (默认: true)

### 修改配置

**方法1：直接编辑配置文件**
```powershell
notepad %USERPROFILE%\.research_config.json
```

**方法2：重新初始化**
```powershell
# 删除配置文件，下次运行时会重新引导配置
del %USERPROFILE%\.research_config.json
resman -v
```

### 配置验证

```powershell
# 检查Git配置状态
resman -gs

# 测试特定项目的Git配置
resman -gt "project-name"
```

---

## Git增强功能

### 前置条件

**必需工具**
- Git (必须)
- GitHub CLI 或 GitLab CLI (可选，用于自动创建远程仓库)

**安装Git CLI工具**

GitHub CLI:
```powershell
# 使用 winget
winget install GitHub.cli

# 使用 Chocolatey
choco install gh

# 登录GitHub
gh auth login
```

GitLab CLI:
```powershell
# 使用 Scoop
scoop install glab

# 登录GitLab
glab auth login
```

### 自动远程仓库创建

#### 工作原理

1. **检测CLI工具**：自动检测已安装的 `gh` 或 `glab`
2. **选择平台**：根据配置选择对应平台的工具
3. **创建仓库**：使用CLI工具创建远程仓库
4. **配置连接**：自动添加remote origin
5. **推送代码**：将本地代码推送到远程

#### 支持的平台

**GitHub** (使用 `gh` 命令)
```powershell
# 创建私有仓库
gh repo create project-name --private --description "由 resman 创建的研究项目"
```

**GitLab** (使用 `glab` 命令)  
```powershell
# 创建私有仓库
glab repo create project-name --private --description "由 resman 创建的研究项目"
```

**Gitee** (暂不支持CLI，需手动配置)

### 远程仓库URL生成

ResMan 根据配置自动生成仓库URL：

**SSH格式** (GIT_SSH_PREFERRED = true)
```
github: git@github.com:username/project-name.git
gitlab: git@gitlab.com:username/project-name.git
gitee:  git@gitee.com:username/project-name.git
```

**HTTPS格式** (GIT_SSH_PREFERRED = false)
```
github: https://github.com/username/project-name.git
gitlab: https://gitlab.com/username/project-name.git
gitee:  https://gitee.com/username/project-name.git
```

### Git增强命令详解

#### 检查Git状态 (`resman -gs`)

显示当前Git环境信息：
```
[INFO] Git CLI 工具检测结果:
  ✓ gh - gh version 2.40.1 (2024-01-15)
    平台: github
  ✓ glab - glab version 1.36.0 (2024-01-10)
    平台: gitlab

[INFO] 当前Git配置:
  平台: github
  用户名: your-username
  默认可见性: private
  自动创建远程: True
  SSH优先: True
```


### 自动化集成

#### 项目创建时的Git集成

创建新项目时 (`resman -n project-name`)：
1. **初始化本地Git仓库**
2. **创建初始提交**
3. **自动创建远程仓库** (如果启用)
4. **配置远程连接**
5. **推送到远程仓库**

#### 同步时的智能文件过滤

**基础同步** (`resman -s project-name`)：
```gitignore
# 包含的文件
code/
docs/
README.md
research_log.md
data_lineage.json
data/processed/
results/figures/
results/reports/
```

**完全同步** (`resman -sa project-name`)：
- 包含基础同步的所有内容
- 额外包含小于 MAX_FILE_SIZE_MB 的结果文件
- 自动跳过大文件并给出提示

### Git工作流最佳实践

#### 日常工作流程

1. **开始工作**
   ```powershell
   cd C:\research\my-project
   # 进行研究工作...
   ```

2. **记录进展**
   ```powershell
   resman -j "my-project"
   # 输入今日工作内容
   ```

3. **同步代码**
   ```powershell
   resman -s "my-project"
   # 输入提交信息
   ```

4. **备份项目**
   ```powershell
   resman -b "my-project"
   ```

**或者使用自动化工作流**：
```powershell
resman -a "my-project"
# 依次执行：日志记录 → Git同步 → 项目备份
```

#### 分支管理建议

ResMan 默认使用主分支（main/master），建议的分支策略：

**功能开发**：
```powershell
git checkout -b feature/data-analysis
# 开发功能...
resman -j "my-project"  # 记录进展
resman -s "my-project"  # 同步到功能分支
```

**合并到主分支**：
```powershell
git checkout main
git merge feature/data-analysis
resman -s "my-project"  # 同步合并结果
```

---

## 实用示例

### 场景1：地震研究项目

**项目背景**：分析地震目录数据，建立预测模型

#### 1. 项目创建和初始化
```powershell
# 创建项目（自动创建GitHub仓库）
resman -n "earthquake-prediction-2025"

# 检查项目结构
cd C:\research\earthquake-prediction-2025
dir
```

#### 2. 数据准备阶段
```powershell
# 将原始数据放入 data/raw/
copy earthquake_catalog.csv data\raw\

# 记录数据来源
resman -j "earthquake-prediction-2025"
# 输入：获取了USGS地震目录数据，包含2020-2024年的记录
```

#### 3. 数据处理开发
```powershell
# 开发数据处理脚本
# 将脚本保存到 code/data_preprocessing.py

# 运行处理并保存结果到 data/processed/
python code/data_preprocessing.py

# 记录处理步骤
resman -j "earthquake-prediction-2025"
# 输入：完成数据清理，过滤了无效记录，标准化了时间格式
```

#### 4. 模型开发
```powershell
# 开发模型代码
# code/ml_model.py

# 生成结果图表
# 保存到 results/figures/

# 同步代码和小图表
resman -s "earthquake-prediction-2025"
# 输入提交信息：实现了基于SVM的地震预测模型
```

#### 5. 结果分析
```powershell
# 生成分析报告
# results/reports/preliminary_analysis.md

# 记录重要发现
resman -j "earthquake-prediction-2025"
# 输入：模型在测试集上达到0.85的准确率，识别出了3个关键特征

# 完全同步（包含结果文件）
resman -sa "earthquake-prediction-2025"
```

#### 6. 项目总结
```powershell
# 生成项目报告
resman -r "earthquake-prediction-2025"

# 执行完整工作流
resman -a "earthquake-prediction-2025"
# 记录：项目第一阶段完成，准备提交论文
```

### 场景2：现有项目迁移

**项目背景**：将现有的研究文件夹纳入ResMan管理

#### 1. 标记现有项目
```powershell
# 假设已有项目文件夹：C:\my_research\fluid_injection_study
resman -i "fluid_injection_study"
```

#### 2. 整理项目结构
```powershell
cd C:\research\fluid_injection_study

# 手动整理文件到标准结构
mkdir data\raw, data\processed, code, results\figures
move *.csv data\raw\
move *.py code\
move *.png results\figures\
```

#### 3. 初始化Git和远程仓库
```powershell
# 初始化Git（如果还没有）
git init
git add .
git commit -m "项目初始化：迁移现有文件"

# 检查Git状态
resman -gs
```

#### 4. 建立工作流程
```powershell
# 记录迁移过程
resman -j "fluid_injection_study"
# 输入：将现有项目迁移到ResMan管理，重新组织了文件结构

# 同步到远程仓库
resman -s "fluid_injection_study"
```

### 场景3：多项目协作

**项目背景**：团队合作的大型研究项目

#### 1. 克隆和设置
```powershell
# 克隆团队项目
git clone https://github.com/team/seismic-hazard-assessment.git
cd seismic-hazard-assessment

# 标记为ResMan项目
resman -i "seismic-hazard-assessment"
```

#### 2. 个人分支开发
```powershell
# 创建个人分支
git checkout -b feature/risk-calculation

# 开发功能
# 编辑 code/risk_analysis.py

# 使用ResMan记录进展
resman -j "seismic-hazard-assessment"
# 输入：实现了基于概率的风险计算算法

# 同步个人分支
git add .
git commit -m "实现风险计算模块"
git push origin feature/risk-calculation
```

#### 3. 定期备份和报告
```powershell
# 生成个人进展报告
resman -r "seismic-hazard-assessment"

# 备份本地工作
resman -b "seismic-hazard-assessment"
```

### 场景4：长期项目管理

**项目背景**：博士论文研究，需要3-4年持续管理

#### 1. 项目分阶段管理
```powershell
# 主项目
resman -n "phd-thesis-seismology"

# 子项目或章节
resman -n "chapter1-literature-review"
resman -n "chapter2-methodology"
resman -n "chapter3-case-study"
```

#### 2. 定期维护
```powershell
# 每周项目状态检查
resman -l  # 查看所有项目

# 每月生成进展报告
resman -r "phd-thesis-seismology"

# 定期清理
resman -c "phd-thesis-seismology"
```

#### 3. 重要节点备份
```powershell
# 论文提交前的完整备份
resman -sa "phd-thesis-seismology"  # 完全同步
resman -b   # 备份所有项目

# 记录重要节点
resman -j "phd-thesis-seismology"
# 输入：论文初稿完成，准备提交审阅
```

---

## 最佳实践

### 项目组织原则

#### 1. 标准化目录结构
严格遵循ResMan的目录约定：
```
project/
├── data/
│   ├── raw/           # 原始数据，只读，不修改
│   ├── processed/     # 清理后的数据，可版本控制
│   └── intermediate/  # 中间结果，不版本控制
├── code/              # 所有源代码
├── results/
│   ├── figures/       # 图表，可版本控制
│   ├── outcome/       # 主要结果，选择性版本控制
│   └── reports/       # 报告文档，版本控制
└── docs/              # 项目文档和说明
```

#### 2. 文件命名约定
使用描述性的文件名：
```
data/raw/earthquake_catalog_2020_2024.csv
code/01_data_preprocessing.py
code/02_feature_engineering.py  
code/03_model_training.py
results/figures/magnitude_distribution.png
results/reports/monthly_progress_2025_01.md
```

#### 3. 数据管理策略
- **原始数据**：放入 `data/raw/`，从不修改
- **处理数据**：保存到 `data/processed/`，版本控制
- **中间文件**：使用 `data/intermediate/`，不版本控制
- **大文件**：考虑外部存储，使用符号链接

### Git使用最佳实践

#### 1. 提交频率和粒度
```powershell
# 好的做法：小而频繁的提交
git commit -m "修复数据预处理中的时间解析错误"
git commit -m "添加地震强度可视化功能"
git commit -m "更新README文档"

# 避免：大而笼统的提交
git commit -m "各种修改和更新"
```

#### 2. 使用ResMan的同步功能
```powershell
# 日常开发：只同步代码和文档
resman -s "project-name"

# 重要节点：包含结果文件
resman -sa "project-name"

# 使用自动化工作流
resman -a "project-name"  # 包含日志记录
```

#### 3. 分支策略
```powershell
# 功能开发分支
git checkout -b feature/data-visualization
# 开发完成后
resman -s "project-name"  # 同步功能分支
git checkout main
git merge feature/data-visualization
```

### 研究日志最佳实践

#### 1. 定期记录
建议每天结束工作时记录：
```powershell
resman -j "project-name"
```

#### 2. 记录内容建议
```markdown
## 2025-01-31 18:30:00

### 工作内容
- 完成了地震目录数据的质量检查
- 发现并修复了经纬度数据的异常值
- 实现了基于时间窗口的特征提取算法
- 初步结果显示模型准确率有所提升

### 问题和解决方案
- 问题：数据中存在重复记录
- 解决：实现了基于时间和位置的去重算法

### 下一步计划
- 优化特征选择算法
- 进行交叉验证测试
- 准备中期进展报告

### 技术信息
- Git提交: a1b2c3d
- 修改文件: 
  - data_quality_check.py
  - feature_extraction.py
```

#### 3. 重要发现记录
对于重要的研究发现，详细记录：
```markdown
### 重要发现
发现了地震发生前24小时内的微震活动模式：
- 频率增加约30%
- 震级分布呈现特定特征
- 空间聚集性显著增强

这可能成为短期预测的重要指标。
```

### 备份策略最佳实践

#### 1. 多层次备份
- **自动备份**：ResMan日备份和周备份
- **云端同步**：Git远程仓库
- **外部备份**：重要数据的离线备份

#### 2. 备份验证
定期检查备份完整性：
```powershell
# 检查最近的备份
dir C:\research\_backup\daily\ | sort LastWriteTime -Descending | select -First 5

# 验证特定项目的备份
resman -r "project-name"  # 生成报告对比
```

#### 3. 恢复演练
定期测试从备份恢复：
```powershell
# 模拟恢复场景
copy "C:\research\_backup\daily\20250131_120000\my-project" "C:\temp\recovery-test" -Recurse
```

### 团队协作最佳实践

#### 1. 项目标准化
团队统一使用ResMan的项目结构：
```powershell
# 团队成员都使用相同的项目创建方式
resman -n "team-project-seismic-analysis"
```

#### 2. 协作工作流
```powershell
# 每日工作开始
git pull origin main                    # 同步最新代码
resman -j "project-name"               # 记录计划工作

# 每日工作结束  
resman -a "project-name"               # 自动化工作流
git push origin feature/my-branch      # 推送个人分支
```

#### 3. 代码审查集成
```powershell
# 创建Pull Request前
resman -r "project-name"               # 生成项目报告
resman -sa "project-name"              # 完全同步结果
```

### 性能优化建议

#### 1. 大文件管理
对于大型数据文件：
```powershell
# 使用符号链接指向外部存储
mklink /D "C:\research\project\data\large_dataset" "D:\external_storage\dataset"

# 在.gitignore中排除
echo "data/large_dataset/" >> .gitignore
```

#### 2. 备份优化
```powershell
# 配置合理的文件大小限制
# 编辑配置文件设置 MAX_FILE_SIZE_MB
```

#### 3. 清理维护
定期清理中间文件：
```powershell
# 单项目清理
resman -c "project-name"

# 批量清理所有项目
resman -l | ForEach-Object { resman -c $_.Name }
```

## 故障排除

### 常见问题和解决方案

#### 依赖问题

**Linux/macOS: 缺少依赖工具**
```bash
# Ubuntu/Debian
sudo apt install jq bc rsync git

# CentOS/RHEL  
sudo yum install jq bc rsync git

# macOS
brew install jq bc rsync git
```

**Windows: PowerShell执行策略限制**
```powershell
# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 或解除单个脚本阻止
Unblock-File "path\to\resman.ps1"
```

#### Git相关问题

**Git初始化失败**
```bash
# 检查Git安装
git --version

# 手动初始化Git
cd "research/project-name"
git init
git add .
git commit -m "项目初始化"
```

**远程仓库创建失败**
```bash
# 检查CLI工具认证
gh auth status    # GitHub
glab auth status  # GitLab

# 重新登录
gh auth login     # GitHub
glab auth login   # GitLab
```

**问题：远程仓库创建失败**
```
[ERROR] GitHub仓库创建失败
```
*解决方案：*
```powershell
# 检查GitHub CLI安装和认证
gh --version
gh auth status

# 重新登录
gh auth login

# 检查仓库名是否已存在
gh repo list | findstr "project-name"
```

**问题：推送失败**
```
[WARN] 推送到远程仓库失败
```
*解决方案：*
```powershell
cd "C:\research\project-name"

# 检查远程配置
git remote -v

# 检查认证
git config user.name
git config user.email

# 测试连接
resman -gt "project-name"
```

#### 2. 权限问题

**问题：无法创建目录**
```
[ERROR] 无法创建目录: C:\research\project-name
```
*解决方案：*
```powershell
# 检查目录权限
icacls "C:\research"

# 以管理员身份运行PowerShell
# 或选择有写权限的目录
```

**问题：执行策略限制**
```
无法加载文件 resman.ps1，因为在此系统上禁止运行脚本
```
*解决方案：*
```powershell
# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 或者为单个脚本解除阻止
Unblock-File "C:\path\to\resman.ps1"
```

#### 3. 配置问题

**问题：配置文件损坏**
```
[WARN] 配置文件损坏，重新初始化...
```
*解决方案：*
```powershell
# 删除损坏的配置文件
del "%USERPROFILE%\.research_config.json"

# 重新运行初始化
resman -v
```

**问题：路径不存在**
```
[ERROR] 研究根目录不存在: C:\research
```
*解决方案：*
```powershell
# 手动创建目录
mkdir "C:\research"

# 或重新配置路径
del "%USERPROFILE%\.research_config.json"
resman -v
```

#### 4. 备份问题

**问题：备份失败**
```
[ERROR] 备份过程中出现错误
```
*解决方案：*
```powershell
# 检查磁盘空间
Get-PSDrive C

# 检查备份目录权限
Test-Path "C:\research\_backup" -PathType Container

# 手动创建备份目录
mkdir "C:\research\_backup\daily" -Force
mkdir "C:\research\_backup\weekly" -Force
```

#### 5. 项目识别问题

**问题：项目不被识别**
```
[ERROR] 文件夹 project-name 不是有效的研究项目（缺少 .resman 标识文件）
```
*解决方案：*
```powershell
# 检查是否存在标识文件
Test-Path "C:\research\project-name\.resman"

# 重新标记项目
resman -i "project-name"

# 或手动创建标识文件
cd "C:\research\project-name"
echo '{"project_name":"project-name","created_date":"2025-01-31","project_type":"research"}' > .resman
```

### 调试和日志

#### 启用详细日志
编辑配置文件，设置 `LOG_LEVEL` 为 `"DEBUG"`：
```json
{
  "LOG_LEVEL": "DEBUG"
}
```

#### 检查系统状态
```powershell
# 检查所有Git CLI工具
resman -gs

# 检查特定项目状态
resman -gt "project-name"

# 生成项目报告
resman -r "project-name"
```

#### 手动验证操作
```powershell
# 验证项目结构
cd "C:\research\project-name"
tree /F

# 验证Git状态
git status
git remote -v

# 验证备份
dir "C:\research\_backup\daily" | sort LastWriteTime -Descending
```

### 性能问题

#### 大项目处理慢
```powershell
# 排除大文件
echo "*.h5" >> .gitignore
echo "*.hdf5" >> .gitignore
echo "data/large_files/" >> .gitignore

# 使用基础同步模式
resman -s "project-name"  # 而不是 -sa
```

#### 备份速度慢
```powershell
# 检查robocopy参数
# 考虑调整 /R 和 /W 参数

# 排除不必要的目录
# 编辑脚本中的robocopy命令添加 /XD 参数
```

### 权限和路径问题

**无法创建目录**
```bash
# 检查目录权限
ls -la /path/parent/directory  # Linux/macOS
icacls "C:\path\parent"        # Windows

# 选择有写权限的目录，或使用sudo/管理员权限
```

**配置文件损坏**
```bash
# 删除配置文件重新初始化
rm ~/.research_config.json     # Linux/macOS
del "%USERPROFILE%\.research_config.json"  # Windows

# 重新运行初始化
resman -v
```

### 调试技巧

**启用详细输出**
- 查看脚本内的日志函数调用
- 检查Git命令输出
- 验证文件权限和路径

**手动验证**
```bash
# 验证项目结构
tree project-name              # Linux/macOS
tree /F project-name           # Windows

# 验证Git状态
cd project-name
git status
git remote -v
```

---

## 贡献指南

### 开发环境

ResMan 采用模块化设计，易于扩展和维护：

- **Windows版本**: PowerShell 脚本 (`resman.ps1`)
- **Linux版本**: Bash 脚本 (`resman-linux.sh`) 
- **macOS版本**: Bash 脚本 (`resman-macos.sh`)

### 代码结构

所有版本都遵循相同的架构：
- 配置管理模块
- 项目管理功能
- Git集成功能
- 备份系统
- 日志记录系统

### 贡献方式

1. **Fork 本仓库**
2. **创建功能分支** (`git checkout -b feature/amazing-feature`)
3. **提交更改** (`git commit -m 'Add amazing feature'`)
4. **推送分支** (`git push origin feature/amazing-feature`)
5. **创建 Pull Request**

### 开发规范

- 保持跨平台功能一致性
- 遵循现有的代码风格
- 添加适当的错误处理
- 更新相关文档

### Bug 报告

使用 GitHub Issues 报告问题时，请包含：
- 操作系统和版本
- 脚本版本
- 错误信息和日志
- 复现步骤

---

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

### 致谢

感谢所有贡献者和用户的支持！

---

## FAQ常见问题

### Q1: ResMan支持哪些操作系统？
**A:** ResMan 现已支持 Windows、Linux 和 macOS 三个平台，提供功能完全一致的跨平台体验。

### Q2: 可以在没有Git的情况下使用ResMan吗？
**A:** 可以，但会失去版本控制功能。ResMan的项目管理、备份、日志功能仍然可用。

### Q3: 如何更改研究根目录？
**A:** 删除配置文件重新初始化：
- **Windows**: `del "%USERPROFILE%\.research_config.json"`
- **Linux/macOS**: `rm ~/.research_config.json`

然后重新运行 `resman -v` 会引导重新配置。

### Q4: 备份占用存储空间太大怎么办？
**A:** 
- 调整 `BACKUP_KEEP_DAYS` 减少保留天数
- 提高 `MAX_FILE_SIZE_MB` 限制大文件备份
- 手动清理 `_backup` 目录中的旧备份

### Q5: 可以自定义项目目录结构吗？
**A:** 当前版本使用固定的目录结构。您可以在创建项目后手动调整，但建议保持标准结构以确保工具兼容性。

### Q6: 如何在团队中共享ResMan配置？
**A:** 配置文件是用户级别的。建议团队成员使用相同的配置参数，可以共享配置文件模板。

### Q7: ResMan会自动推送到远程仓库吗？
**A:** 默认会自动推送（`GIT_AUTO_PUSH = true`）。您可以在配置中关闭此功能。

### Q8: 如何处理大型数据文件？
**A:** 
- 将大文件放在 `data/raw/` 或 `data/intermediate/`
- 在 `.gitignore` 中排除大文件
- 考虑使用Git LFS或外部存储
- 使用符号链接指向外部存储

### Q9: 可以恢复删除的项目吗？
**A:** 如果有备份，可以从 `_backup` 目录恢复。Git远程仓库也是一个恢复源。

### Q10: 研究日志支持Markdown格式吗？
**A:** 是的，研究日志使用Markdown格式，支持格式化文本、链接、代码块等。

### Q11: 如何批量管理多个项目？
**A:** 
```powershell
# 列出所有项目
resman -l

# 备份所有项目
resman -b

# 批量操作需要脚本循环
resman -l | ForEach-Object { resman -r $_.Name }
```

### Q12: ResMan支持项目模板吗？
**A:** 当前版本使用固定模板。未来版本可能支持自定义项目模板。

### Q13: 如何集成到IDE中？
**A:** 可以在IDE中配置外部工具或任务来调用ResMan命令。例如在VS Code中配置tasks.json。

### Q14: 数据血缘追踪功能如何使用？
**A:** ResMan创建 `data_lineage.json` 文件记录数据处理流程。您需要手动更新此文件来追踪数据变换。

### Q15: 如何处理网络连接问题？
**A:** 
- Git同步失败时会给出警告，不会中断流程
- 可以稍后手动执行 `git push`
- 使用 `resman -gt project-name` 测试连接

### Q16: 三个平台的脚本功能完全一致吗？
**A:** 是的，所有平台版本提供完全相同的功能和用户体验，只是底层实现适配了不同的系统环境。

### Q17: 可以在同一台机器上安装多个版本吗？
**A:** 可以，但建议只使用适合您系统的版本。配置文件在所有版本间共享。

---

## 快速参考

### 命令速查

```bash
# 基础操作
resman -h                    # 帮助信息
resman -v                    # 版本信息  
resman -l                    # 列出项目

# 项目管理
resman -n "project"          # 创建新项目
resman -i "folder"           # 标记现有文件夹
resman -r "project"          # 生成项目报告
resman -c "project"          # 清理临时文件

# 日常工作流
resman -j "project"          # 添加研究日志
resman -s "project"          # Git同步（基础）
resman -sa "project"         # Git同步（完整）
resman -b "project"          # 备份项目
resman -a "project"          # 自动化流程

# Git增强功能
resman -gs                   # 检查Git状态
```

---

## 项目信息

- **版本**: 1.0.0
- **作者**: Maoye  
- **许可证**: MIT
- **支持平台**: Windows, Linux, macOS
- **更新日期**: 2025-07-31

### 相关链接

- [GitHub 仓库](https://github.com/your-username/resman)
- [问题反馈](https://github.com/your-username/resman/issues)
- [贡献指南](https://github.com/your-username/resman/blob/main/CONTRIBUTING.md)

---

**感谢使用 ResMan！**

如果这个工具对您的研究工作有帮助，欢迎给项目加星⭐或分享给其他研究人员。

有任何问题或建议，请通过 GitHub Issues 联系我们。