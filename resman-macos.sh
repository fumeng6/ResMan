#!/bin/bash
# =============================================================================
# 研究项目管理集成脚本 (macOS版)
# 功能: Git同步、数据备份、日志记录、项目管理
# 作者: Maoye
# 日期: 2025-07-31
# 版本: macOS Bash 1.0.0
# =============================================================================

set -euo pipefail

# 脚本配置
readonly SCRIPT_VERSION="1.0.0"
readonly CONFIG_FILE="$HOME/.research_config.json"

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# 显示版本信息
show_version() {
    echo -e "${GREEN}"
    cat << 'EOF'
   ____           __  __            
  |  _ \ ___  ___|  \/  | __ _ _ __  
  | |_) / _ \/ __| |\/| |/ _` | '_ \ 
  |  _ <  __/\__ \ |  | | (_| | | | |
  |_| \_\___||___/_|  |_|\__,_|_| |_|
EOF
    echo -e "${NC}"
    cat << EOF

研究管理集成脚本 (macOS版)
版本: $SCRIPT_VERSION
作者: Maoye
日期: 2025-07-31

功能特性:
- 项目结构化管理
- Git版本控制集成
- 自动化备份系统
- 研究日志记录
- 项目状态报告
- 中间文件清理

EOF
}

# 显示帮助信息
show_help() {
    cat << EOF
研究管理集成脚本 (macOS版) v$SCRIPT_VERSION

用法: resman <操作> [项目名称]

操作:
  -h, --help              显示帮助信息
  -v, --version           显示版本信息
  -l, --list              列出所有项目
  -n, --new               创建新项目
  -i, --init              将现有文件夹标记为项目
  -s, --sync              同步项目到Git（不包含大文件）
  -sa, --sync-all         同步项目到Git（包含小结果文件）
  -b, --backup            备份项目（默认备份所有项目）
  -j, --journal           添加研究日志条目
  -r, --report            生成项目状态报告
  -c, --clean             清理中间文件
  -a, --auto              自动化流程（日志+同步+备份）
  
Git 增强功能:
  -gs, --git-status       检查Git CLI工具状态
  
示例:
  resman -n "injection-seismicity-2025"       # 创建新项目（自动创建远程仓库）
  resman -i "existing-folder"                 # 标记现有文件夹为项目（可选Git初始化）
  resman -j "injection-seismicity-2025"       # 添加日志条目
  resman -a "injection-seismicity-2025"       # 执行完整工作流
  resman -b                                    # 备份所有项目
  resman -gs                                  # 检查Git CLI工具状态

EOF
}

# 初始化配置
initialize_config() {
    echo -e "${GREEN}欢迎使用研究项目管理工具！${NC}"
    echo -e "${YELLOW}首次运行需要配置工作目录。${NC}"
    echo ""
    
    # 获取研究根目录
    local default_path="$HOME/research"
    read -p "请输入研究项目根目录路径 (默认: $default_path): " research_root
    research_root=${research_root:-$default_path}
    
    # 验证并创建目录
    if [[ ! -d "$research_root" ]]; then
        if mkdir -p "$research_root"; then
            log_info "已创建目录: $research_root"
        else
            log_error "无法创建目录: $research_root，请检查权限"
            exit 1
        fi
    fi
    
    # 获取备份目录
    local default_backup_path="${research_root}/_backup"
    read -p "请输入备份目录路径 (默认: $default_backup_path): " backup_root
    backup_root=${backup_root:-$default_backup_path}
    
    # 验证并创建备份目录
    if [[ ! -d "$backup_root" ]]; then
        if mkdir -p "$backup_root"; then
            log_info "已创建备份目录: $backup_root"
        else
            log_error "无法创建备份目录: $backup_root，请检查权限"
            exit 1
        fi
    fi
    
    # 保存配置
    cat > "$CONFIG_FILE" << EOF
{
    "RESEARCH_ROOT": "$research_root",
    "BACKUP_ROOT": "$backup_root",
    "BACKUP_KEEP_DAYS": 30,
    "MAX_FILE_SIZE_MB": 100,
    "GIT_AUTO_PUSH": true,
    "DEFAULT_REMOTE": "origin",
    "LOG_LEVEL": "INFO",
    "ENABLE_COLOR": true,
    "CREATED_DATE": "$(date '+%Y-%m-%d %H:%M:%S')",
    "GIT_PLATFORM": "github",
    "GIT_USERNAME": "",
    "GIT_DEFAULT_VISIBILITY": "private",
    "GIT_AUTO_CREATE_REMOTE": true,
    "GIT_CLI_TOOL": "",
    "GIT_SSH_PREFERRED": true
}
EOF
    
    log_info "配置已保存到: $CONFIG_FILE"
    log_info "您可以随时编辑此文件来修改配置。"
    echo ""
}

# 加载配置
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        initialize_config
    fi
    
    if ! jq . "$CONFIG_FILE" > /dev/null 2>&1; then
        log_warn "配置文件损坏，重新初始化..."
        initialize_config
    fi
    
    # 读取配置项
    RESEARCH_ROOT=$(jq -r '.RESEARCH_ROOT' "$CONFIG_FILE")
    BACKUP_ROOT=$(jq -r '.BACKUP_ROOT' "$CONFIG_FILE")
    BACKUP_KEEP_DAYS=$(jq -r '.BACKUP_KEEP_DAYS' "$CONFIG_FILE")
    MAX_FILE_SIZE_MB=$(jq -r '.MAX_FILE_SIZE_MB' "$CONFIG_FILE")
    GIT_AUTO_PUSH=$(jq -r '.GIT_AUTO_PUSH' "$CONFIG_FILE")
    DEFAULT_REMOTE=$(jq -r '.DEFAULT_REMOTE' "$CONFIG_FILE")
    GIT_PLATFORM=$(jq -r '.GIT_PLATFORM' "$CONFIG_FILE")
    GIT_USERNAME=$(jq -r '.GIT_USERNAME' "$CONFIG_FILE")
    GIT_DEFAULT_VISIBILITY=$(jq -r '.GIT_DEFAULT_VISIBILITY' "$CONFIG_FILE")
    GIT_AUTO_CREATE_REMOTE=$(jq -r '.GIT_AUTO_CREATE_REMOTE' "$CONFIG_FILE")
    GIT_SSH_PREFERRED=$(jq -r '.GIT_SSH_PREFERRED' "$CONFIG_FILE")
    
    # 验证必要目录
    if [[ ! -d "$RESEARCH_ROOT" ]]; then
        log_error "研究根目录不存在: $RESEARCH_ROOT"
        log_warn "重新配置..."
        initialize_config
        load_config
    fi
    
    # 创建必要目录
    mkdir -p "$RESEARCH_ROOT" "$BACKUP_ROOT"
}

# 检查项目是否存在
test_project() {
    local project_name="$1"
    
    if [[ -z "$project_name" ]]; then
        log_error "项目名称不能为空"
        exit 1
    fi
    
    local project_path="$RESEARCH_ROOT/$project_name"
    if [[ ! -d "$project_path" ]]; then
        log_error "项目 $project_name 不存在"
        exit 1
    fi
    
    # 检查项目标识文件
    if [[ ! -f "$project_path/.resman" ]]; then
        log_error "文件夹 $project_name 不是有效的研究项目（缺少 .resman 标识文件）"
        log_warn "使用 'resman -i $project_name' 将其标记为项目"
        exit 1
    fi
    
    echo "$project_path"
}

# 获取文件大小（MB） - macOS版本
get_file_size_mb() {
    local file_path="$1"
    if [[ -f "$file_path" ]]; then
        # macOS使用 stat -f%z，Linux使用 stat -c%s
        local size=$(stat -f%z "$file_path" 2>/dev/null)
        if [[ -z "$size" ]]; then
            size=0
        fi
        # 使用 bc 进行浮点数计算
        echo "scale=2; $size / 1048576" | bc
    else
        echo "0"
    fi
}

# 创建新项目
new_research_project() {
    local project_name="$1"
    local project_dir="$RESEARCH_ROOT/$project_name"
    
    if [[ -d "$project_dir" ]]; then
        log_error "项目 $project_name 已存在"
        exit 1
    fi
    
    log_info "创建项目: $project_name"
    
    # 创建目录结构
    local directories=(
        "data/raw"
        "data/processed"
        "data/intermediate"
        "code"
        "results/figures"
        "results/outcome"
        "results/reports"
        "docs"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$project_dir/$dir"
    done
    
    cd "$project_dir"
    
    # 创建README文件
    cat > README.md << EOF
# $project_name

## 项目概述
[项目描述]

## 数据说明
- **raw/**: 原始数据，不可修改
- **processed/**: 预处理后的数据  
- **intermediate/**: 中间结果

## 代码结构
[代码模块说明]

## 实验记录
[实验版本和结果]

## 使用说明
[如何复现结果]

---
创建时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF
    
    # 创建研究日志
    cat > research_log.md << EOF
# $project_name 研究日志

---

## $(date '+%Y-%m-%d')

### 项目初始化
- 创建项目结构
- 初始化Git仓库

---
EOF
    
    # 创建.gitignore
    cat > .gitignore << 'EOF'
# 原始数据文件
data/raw/

# 大型中间文件
data/intermediate/*.h5
data/intermediate/*.hdf5
data/intermediate/*.nc
data/intermediate/*.mat

# 大型结果文件 (>100MB)
results/outcome/*.h5
results/outcome/*.hdf5
results/outcome/*.bin
results/outcome/*.dat

# 临时文件
*.tmp
*.temp
*~

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
.venv/

# Jupyter Notebook
.ipynb_checkpoints/

# IDE
.vscode/
.idea/
*.swp
*.swo

# 系统文件
.DS_Store
Thumbs.db
desktop.ini
EOF
    
    # 创建数据处理追踪文件
    cat > data_lineage.json << EOF
{
    "project": "$project_name",
    "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "data_pipeline": {
        "version": "1.0.0",
        "steps": []
    },
    "last_updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    
    # 创建项目标识文件
    cat > .resman << EOF
{
    "project_name": "$project_name",
    "created_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "created_by": "$(whoami)",
    "resman_version": "$SCRIPT_VERSION",
    "project_type": "research",
    "description": "研究项目标识文件 - 请勿删除"
}
EOF
    
    # 使用增强的Git初始化
    if initialize_git_with_remote "$project_name" "$project_dir"; then
        log_info "项目 $project_name 创建完成"
    else
        log_warn "Git初始化失败，但项目已创建。您可以稍后手动初始化Git"
        log_info "项目 $project_name 创建完成"
    fi
    
    log_info "项目路径: $project_dir"
}

# 将现有文件夹标记为项目
initialize_existing_project() {
    local folder_name="$1"
    
    if [[ -z "$folder_name" ]]; then
        log_error "请指定要标记的文件夹名称"
        exit 1
    fi
    
    local folder_path="$RESEARCH_ROOT/$folder_name"
    
    if [[ ! -d "$folder_path" ]]; then
        log_error "文件夹不存在: $folder_path"
        exit 1
    fi
    
    if [[ -f "$folder_path/.resman" ]]; then
        log_warn "文件夹 '$folder_name' 已经是一个项目"
        return
    fi
    
    log_info "将文件夹 '$folder_name' 标记为项目..."
    
    # 创建项目标识文件
    cat > "$folder_path/.resman" << EOF
{
    "name": "$folder_name",
    "created_date": "$(date '+%Y-%m-%d %H:%M:%S')",
    "created_by": "$(whoami)",
    "resman_version": "$SCRIPT_VERSION",
    "project_type": "existing",
    "description": "从现有文件夹转换的项目",
    "initialized_date": "$(date '+%Y-%m-%d %H:%M:%S')"
}
EOF
    log_info "已创建项目标识文件: .resman"
    
    # 如果不存在README.md，创建一个基础的
    if [[ ! -f "$folder_path/README.md" ]]; then
        cat > "$folder_path/README.md" << EOF
# $folder_name

## 项目描述
这是一个从现有文件夹转换的研究项目。

## 项目信息
- 项目名称: $folder_name
- 创建日期: $(date '+%Y-%m-%d')
- 项目类型: 现有文件夹转换

## 目录结构
请根据需要组织您的项目文件。

## 使用说明
请在此处添加项目的使用说明和相关信息。
EOF
        log_info "已创建基础 README.md 文件"
    fi
    
    # 如果不存在研究日志，创建一个
    if [[ ! -f "$folder_path/research_log.md" ]]; then
        cat > "$folder_path/research_log.md" << EOF
# $folder_name 研究日志

## $(date '+%Y-%m-%d %H:%M:%S') - 项目初始化

### 工作内容
- 将现有文件夹 '$folder_name' 标记为研究项目
- 创建项目标识文件和基础文档

### 备注
项目已纳入 resman 管理系统。

---
EOF
        log_info "已创建研究日志文件"
    fi
    
    # 交互式Git初始化
    cd "$folder_path"
    if [[ ! -d ".git" ]]; then
        echo ""
        read -p "是否要初始化Git仓库? (y/N): " init_git
        if [[ "$init_git" == "y" || "$init_git" == "Y" ]]; then
            if git init &>/dev/null && git add . &>/dev/null && git commit -m "项目初始化: 从现有文件夹转换" &>/dev/null; then
                log_info "Git仓库已初始化"
                
                # 询问是否创建远程仓库
                read -p "是否要创建远程仓库? (y/N): " create_remote
                if [[ "$create_remote" == "y" || "$create_remote" == "Y" ]]; then
                    if new_remote_repository "$folder_name"; then
                        if set_remote_repository "$folder_name"; then
                            if git push -u origin main &>/dev/null || git push -u origin master &>/dev/null; then
                                log_info "项目已推送到远程仓库"
                            else
                                log_warn "推送到远程仓库失败"
                            fi
                        fi
                    fi
                fi
            else
                log_warn "Git初始化失败"
            fi
        fi
    fi
    
    log_info "文件夹 '$folder_name' 已成功标记为项目"
    log_info "项目路径: $folder_path"
    log_info "现在可以使用 resman 命令管理此项目"
}

# 列出所有项目
get_project_list() {
    log_info "当前研究项目:"
    echo ""
    
    if [[ ! -d "$RESEARCH_ROOT" ]]; then
        log_warn "研究根目录不存在: $RESEARCH_ROOT"
        return
    fi
    
    local count=0
    
    for folder in "$RESEARCH_ROOT"/*; do
        if [[ ! -d "$folder" ]]; then
            continue
        fi
        
        local project_name=$(basename "$folder")
        local project_marker_file="$folder/.resman"
        
        # 只有包含.resman标识文件的文件夹才被认为是项目
        if [[ ! -f "$project_marker_file" ]]; then
            continue
        fi
        
        # macOS特定的日期格式
        local last_modified=$(stat -f%Sm -t '%Y-%m-%d' "$folder" 2>/dev/null)
        
        # 检查Git状态
        local git_status=""
        if [[ -d "$folder/.git" ]]; then
            cd "$folder"
            local uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
            if [[ $uncommitted -gt 0 ]]; then
                git_status="($uncommitted 未提交)"
            else
                git_status="(已同步)"
            fi
            cd - > /dev/null
        else
            git_status="(无Git)"
        fi
        
        printf "  %-30s %s %s\n" "$project_name" "$last_modified" "$git_status"
        ((count++))
    done
    
    if [[ $count -eq 0 ]]; then
        log_warn "未找到任何项目"
        echo ""
        echo -e "${YELLOW}提示: 只有包含 .resman 标识文件的文件夹才会被识别为项目${NC}"
        echo -e "${YELLOW}使用 'resman -i [文件夹名]' 将现有文件夹标记为项目${NC}"
    else
        echo ""
        log_info "共找到 $count 个项目"
    fi
}

# 添加研究日志
add_journal_entry() {
    local project_name="$1"
    local project_dir
    project_dir=$(test_project "$project_name")
    local log_file="$project_dir/research_log.md"
    
    echo ""
    echo -e "${BLUE}添加研究日志条目${NC}"
    echo "项目: $project_name"
    echo "日期: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # 获取用户输入
    echo "请输入今日工作内容 (输入完成后按Ctrl+D结束):"
    local work_content
    work_content=$(cat)
    
    if [[ -z "$work_content" ]]; then
        log_warn "工作内容为空，取消添加"
        return
    fi
    
    # 获取Git信息
    cd "$project_dir"
    local git_commit="无Git提交"
    local changed_files="无变更文件"
    
    if [[ -d ".git" ]]; then
        git_commit=$(git rev-parse --short HEAD 2>/dev/null || echo "无Git提交")
        
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        if [[ $commit_count -gt 1 ]]; then
            changed_files=$(git diff --name-only HEAD~1 HEAD 2>/dev/null || echo "无变更文件")
        else
            changed_files="首次提交或无历史记录"
        fi
    else
        git_commit="未初始化Git仓库"
        changed_files="未初始化Git仓库"
    fi
    
    # 添加日志条目
    cat >> "$log_file" << EOF

## $(date '+%Y-%m-%d %H:%M:%S')

### 工作内容
$work_content

### 技术信息
- Git提交: $git_commit
- 修改文件: 
$(echo "$changed_files" | sed 's/^/  - /')

---
EOF
    
    log_info "研究日志已更新"
}

# 检测Git CLI工具
test_git_cli() {
    local detected_tools=()
    
    # 检测 GitHub CLI
    if command -v gh &> /dev/null; then
        local gh_version=$(gh --version | head -n1)
        detected_tools+=("gh|github|$gh_version")
    fi
    
    # 检测 GitLab CLI
    if command -v glab &> /dev/null; then
        local glab_version=$(glab --version)
        detected_tools+=("glab|gitlab|$glab_version")
    fi
    
    printf '%s\n' "${detected_tools[@]}"
}

# 自动创建远程仓库
new_remote_repository() {
    local project_name="$1"
    local platform="${2:-$GIT_PLATFORM}"
    local visibility="${3:-$GIT_DEFAULT_VISIBILITY}"
    
    local git_tools
    readarray -t git_tools < <(test_git_cli)
    
    if [[ ${#git_tools[@]} -eq 0 ]]; then
        log_warn "未检测到Git CLI工具 (gh, glab)"
        return 1
    fi
    
    # 选择合适的工具
    local selected_tool=""
    for tool in "${git_tools[@]}"; do
        IFS='|' read -r name tool_platform version <<< "$tool"
        if [[ "$tool_platform" == "$platform" ]]; then
            selected_tool="$name"
            break
        fi
    done
    
    if [[ -z "$selected_tool" ]]; then
        IFS='|' read -r selected_tool _ _ <<< "${git_tools[0]}"
        log_warn "未找到 $platform 对应的CLI工具，使用 $selected_tool"
    fi
    
    log_info "使用 $selected_tool 创建远程仓库: $project_name"
    
    case "$selected_tool" in
        "gh")
            local visibility_flag
            if [[ "$visibility" == "private" ]]; then
                visibility_flag="--private"
            else
                visibility_flag="--public"
            fi
            
            if gh repo create "$project_name" $visibility_flag --description "由 resman 创建的研究项目"; then
                log_info "GitHub仓库创建成功"
                return 0
            else
                log_error "GitHub仓库创建失败"
                return 1
            fi
            ;;
        "glab")
            local visibility_flag
            if [[ "$visibility" == "private" ]]; then
                visibility_flag="--private"
            else
                visibility_flag="--public"
            fi
            
            if glab repo create "$project_name" $visibility_flag --description "由 resman 创建的研究项目"; then
                log_info "GitLab仓库创建成功"
                return 0
            else
                log_error "GitLab仓库创建失败"
                return 1
            fi
            ;;
        *)
            log_error "不支持的Git CLI工具: $selected_tool"
            return 1
            ;;
    esac
}

# 配置远程仓库
set_remote_repository() {
    local project_name="$1"
    local remote_url="$2"
    local project_dir
    project_dir=$(test_project "$project_name")
    
    cd "$project_dir"
    
    if [[ ! -d ".git" ]]; then
        log_error "项目未初始化Git仓库"
        return 1
    fi
    
    # 如果没有提供URL，根据配置生成
    if [[ -z "$remote_url" ]]; then
        if [[ -z "$GIT_USERNAME" || "$GIT_USERNAME" == "null" ]]; then
            read -p "请输入您的Git用户名: " git_username
            # 更新配置文件
            local temp_config=$(mktemp)
            jq ".GIT_USERNAME = \"$git_username\"" "$CONFIG_FILE" > "$temp_config"
            mv "$temp_config" "$CONFIG_FILE"
            GIT_USERNAME="$git_username"
        fi
        
        # 根据平台生成URL
        case "$GIT_PLATFORM" in
            "github")
                if [[ "$GIT_SSH_PREFERRED" == "true" ]]; then
                    remote_url="git@github.com:${GIT_USERNAME}/${project_name}.git"
                else
                    remote_url="https://github.com/${GIT_USERNAME}/${project_name}.git"
                fi
                ;;
            "gitlab")
                if [[ "$GIT_SSH_PREFERRED" == "true" ]]; then
                    remote_url="git@gitlab.com:${GIT_USERNAME}/${project_name}.git"
                else
                    remote_url="https://gitlab.com/${GIT_USERNAME}/${project_name}.git"
                fi
                ;;
            "gitee")
                if [[ "$GIT_SSH_PREFERRED" == "true" ]]; then
                    remote_url="git@gitee.com:${GIT_USERNAME}/${project_name}.git"
                else
                    remote_url="https://gitee.com/${GIT_USERNAME}/${project_name}.git"
                fi
                ;;
            *)
                log_error "不支持的Git平台: $GIT_PLATFORM"
                return 1
                ;;
        esac
    fi
    
    log_info "配置远程仓库: $remote_url"
    
    # 检查是否已存在origin远程
    if git remote get-url origin &>/dev/null; then
        local existing_remote
        existing_remote=$(git remote get-url origin)
        log_warn "远程仓库origin已存在: $existing_remote"
        read -p "是否要覆盖? (y/N): " choice
        if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
            return 1
        fi
        git remote set-url origin "$remote_url"
    else
        git remote add origin "$remote_url"
    fi
    
    if [[ $? -eq 0 ]]; then
        log_info "远程仓库配置成功"
        return 0
    else
        log_error "远程仓库配置失败"
        return 1
    fi
}

# 增强的Git初始化（用于新项目）
initialize_git_with_remote() {
    local project_name="$1"
    local project_dir="$2"
    local create_remote="${3:-$GIT_AUTO_CREATE_REMOTE}"
    
    cd "$project_dir"
    
    # 初始化Git仓库
    if ! git init &>/dev/null; then
        log_warn "Git初始化失败"
        return 1
    fi
    
    if ! git add . &>/dev/null; then
        log_warn "添加文件失败"
        return 1
    fi
    
    if ! git commit -m "项目初始化: $project_name" &>/dev/null; then
        log_warn "初始提交失败"
        return 1
    fi
    
    log_info "本地Git仓库初始化成功"
    
    # 如果启用了自动创建远程仓库
    if [[ "$create_remote" == "true" ]]; then
        log_info "正在创建远程仓库..."
        
        if new_remote_repository "$project_name"; then
            if set_remote_repository "$project_name"; then
                # 推送到远程
                if git push -u origin main &>/dev/null || git push -u origin master &>/dev/null; then
                    log_info "项目已推送到远程仓库"
                else
                    log_warn "推送到远程仓库失败"
                fi
            fi
        else
            log_warn "远程仓库创建失败，跳过远程配置"
        fi
    fi
    
    return 0
}

# Git同步功能
sync_to_git() {
    local project_name="$1"
    local include_results="${2:-false}"
    local project_dir
    project_dir=$(test_project "$project_name")
    
    cd "$project_dir"
    
    if [[ ! -d ".git" ]]; then
        log_error "项目未初始化Git仓库"
        exit 1
    fi
    
    log_info "同步项目到Git: $project_name"
    
    # 添加代码和文档
    git add code/ docs/ README.md research_log.md data_lineage.json &>/dev/null || true
    # 添加处理后的数据
    git add data/processed/ &>/dev/null || true
    
    if [[ "$include_results" == "true" ]]; then
        log_info "检查结果文件大小..."
        
        # 添加小于限制大小的结果文件
        if [[ -d "results" ]]; then
            find results -type f | while read -r file; do
                local size=$(get_file_size_mb "$file")
                # macOS的bc可能需要不同的比较方式
                if (( $(echo "$size < $MAX_FILE_SIZE_MB" | bc -l) )); then
                    git add "$file" &>/dev/null || true
                    log_debug "添加结果文件: $(basename "$file") (${size}MB)"
                else
                    log_warn "跳过大文件: $(basename "$file") (${size}MB)"
                fi
            done
        fi
    else
        # 只添加图表和报告
        git add results/figures/ results/reports/ &>/dev/null || true
    fi
    
    # 检查是否有变更
    if [[ -z "$(git diff --staged --name-only)" ]]; then
        log_info "没有需要提交的变更"
        return
    fi
    
    # 提交变更
    echo ""
    read -p "请输入提交信息 (留空使用默认信息): " commit_message
    
    if [[ -z "$commit_message" ]]; then
        commit_message="研究进展更新: $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    
    if git commit -m "$commit_message" &>/dev/null; then
        log_info "提交成功"
    else
        log_warn "提交失败"
        return
    fi
    
    # 推送到远程仓库
    if [[ "$GIT_AUTO_PUSH" == "true" ]]; then
        if git remote | grep -q "$DEFAULT_REMOTE"; then
            log_info "推送到远程仓库..."
            local current_branch
            current_branch=$(git branch --show-current)
            if git push "$DEFAULT_REMOTE" "$current_branch" &>/dev/null; then
                log_info "推送成功"
            else
                log_warn "推送失败，请检查远程仓库配置"
            fi
        else
            log_warn "远程仓库 $DEFAULT_REMOTE 不存在"
        fi
    fi
}

# 备份功能
backup_research() {
    local project_name="$1"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    
    # 创建备份目录
    local daily_backup_root="$BACKUP_ROOT/daily"
    local weekly_backup_root="$BACKUP_ROOT/weekly"
    
    mkdir -p "$daily_backup_root" "$weekly_backup_root"
    
    local daily_backup="$daily_backup_root/$timestamp"
    # macOS计算周数的方式
    local week_num=$(( ($(date +%j) - 1) / 7 + 1 ))
    local weekly_backup="$weekly_backup_root/$(date +%Y)_week_$week_num"
    
    if [[ -n "$project_name" ]]; then
        # 备份单个项目
        local project_dir
        project_dir=$(test_project "$project_name")
        log_info "备份项目: $project_name"
        
        local backup_project_dir="$daily_backup/$project_name"
        mkdir -p "$backup_project_dir"
        
        # 使用rsync进行增量备份
        rsync -a --update "$project_dir/" "$backup_project_dir/"
        
        # 周备份（每周一）
        if [[ $(date +%u) -eq 1 ]]; then
            local weekly_project_dir="$weekly_backup/$project_name"
            mkdir -p "$weekly_project_dir"
            rsync -a "$project_dir/" "$weekly_project_dir/"
            log_info "周备份完成"
        fi
    else
        # 备份所有项目
        log_info "备份所有项目..."
        
        for project in "$RESEARCH_ROOT"/*; do
            if [[ ! -d "$project" ]]; then
                continue
            fi
            
            local project_name=$(basename "$project")
            if [[ ! -f "$project/.resman" ]]; then
                continue
            fi
            
            log_debug "备份: $project_name"
            
            local backup_project_dir="$daily_backup/$project_name"
            mkdir -p "$backup_project_dir"
            rsync -a --update "$project/" "$backup_project_dir/"
        done
        
        # 周备份
        if [[ $(date +%u) -eq 1 ]]; then
            log_info "执行周备份..."
            mkdir -p "$weekly_backup"
            rsync -a "$RESEARCH_ROOT/" "$weekly_backup/"
        fi
    fi
    
    # 清理旧备份 - macOS版本
    find "$daily_backup_root" -type d -name "*_*" -mtime +$BACKUP_KEEP_DAYS -exec rm -rf {} + 2>/dev/null || true
    find "$weekly_backup_root" -type d -name "*_week_*" -mtime +90 -exec rm -rf {} + 2>/dev/null || true
    
    log_info "备份完成: $daily_backup"
}

# 生成项目报告
new_project_report() {
    local project_name="$1"
    local project_dir
    project_dir=$(test_project "$project_name")
    
    cd "$project_dir"
    
    log_info "生成项目状态报告: $project_name"
    
    local report_file="project_status_$(date '+%Y%m%d').md"
    
    cat > "$report_file" << EOF
# $project_name 项目状态报告

**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')

## 项目结构
\`\`\`
$(find . -type d -name '.git' -prune -o -name '__pycache__' -prune -o -name '.ipynb_checkpoints' -prune -o -type d -print | head -20 | sort)
\`\`\`

## 文件统计
EOF
    
    # 统计各目录文件数量
    local directories=("data/raw" "data/processed" "data/intermediate" "code" "results/figures" "results/outcome" "results/reports" "docs")
    for dir in "${directories[@]}"; do
        if [[ -d "$dir" ]]; then
            local file_count=$(find "$dir" -type f | wc -l | tr -d ' ')
            local dir_size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            echo "- **$dir**: $file_count 个文件, $dir_size" >> "$report_file"
        fi
    done
    
    cat >> "$report_file" << EOF

## Git状态
EOF
    
    if [[ -d ".git" ]]; then
        local current_branch=$(git branch --show-current 2>/dev/null || echo "未知")
        local last_commit=$(git log -1 --oneline 2>/dev/null || echo "无提交")
        local uncommitted_count=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        
        cat >> "$report_file" << EOF
- **分支**: $current_branch
- **最新提交**: $last_commit
- **未提交变更**: $uncommitted_count 个文件
EOF
    else
        echo "- 未初始化Git仓库" >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

## 最近活动
### 最近修改文件 (7天内)
EOF
    
    # 最近修改的文件 - macOS版本
    find . -type f -mtime -7 -not -path './.git/*' | head -10 | while read -r file; do
        echo "- $file" >> "$report_file"
    done
    
    log_info "报告已生成: $report_file"
}

# 清理中间文件
clear_intermediate_files() {
    local project_name="$1"
    local project_dir
    project_dir=$(test_project "$project_name")
    
    log_info "清理项目中间文件: $project_name"
    
    cd "$project_dir"
    
    # 清理中间数据
    if [[ -d "data/intermediate" ]]; then
        find data/intermediate -name "*.tmp" -delete 2>/dev/null || true
        find data/intermediate -name "*.temp" -delete 2>/dev/null || true
    fi
    
    # 清理Python缓存
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find . -name "*.pyc" -delete 2>/dev/null || true
    
    # 清理Jupyter检查点
    find . -type d -name ".ipynb_checkpoints" -exec rm -rf {} + 2>/dev/null || true
    
    log_info "清理完成"
}

# 自动化工作流
start_auto_workflow() {
    local project_name="$1"
    test_project "$project_name" >/dev/null
    
    log_info "执行自动化工作流: $project_name"
    
    echo ""
    log_info "步骤 1: 添加研究日志"
    add_journal_entry "$project_name"
    
    echo ""
    log_info "步骤 2: 同步到Git"
    sync_to_git "$project_name" false
    
    echo ""
    log_info "步骤 3: 备份项目"
    backup_research "$project_name"
    
    echo ""
    log_info "自动化工作流完成"
}

# 验证项目名称
validate_project_name() {
    local project_name="$1"
    
    if [[ -z "$project_name" ]]; then
        log_error "项目名称不能为空"
        exit 1
    fi
    
    # 检查无效字符
    if [[ "$project_name" =~ [/\<\>:\"\|\\\*\?] ]]; then
        log_error "项目名称包含无效字符: < > : \" / \\ | ? *"
        exit 1
    fi
    
    # 检查长度
    if [[ ${#project_name} -gt 100 ]]; then
        log_error "项目名称过长（最大100字符）"
        exit 1
    fi
}

# 主函数
main() {
    # 检查依赖 - macOS版本
    if ! command -v jq &> /dev/null; then
        log_error "需要安装 jq 工具来处理JSON配置文件"
        log_error "使用 Homebrew 安装: brew install jq"
        log_error "或使用 MacPorts 安装: sudo port install jq"
        exit 1
    fi
    
    if ! command -v bc &> /dev/null; then
        log_error "需要安装 bc 工具来进行数学计算"
        log_error "使用 Homebrew 安装: brew install bc"
        log_error "或使用 MacPorts 安装: sudo port install bc"
        exit 1
    fi
    
    # 加载配置
    load_config
    
    # 解析命令行参数
    local operation="${1:-}"
    local project_name="${2:-}"
    
    # 验证项目名称（如果提供了）
    if [[ -n "$project_name" ]]; then
        validate_project_name "$project_name"
    fi
    
    case "$operation" in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        -l|--list)
            get_project_list
            ;;
        -n|--new)
            if [[ -z "$project_name" ]]; then
                log_error "请指定项目名称"
                exit 1
            fi
            new_research_project "$project_name"
            ;;
        -i|--init)
            if [[ -z "$project_name" ]]; then
                log_error "请指定文件夹名称"
                exit 1
            fi
            initialize_existing_project "$project_name"
            ;;
        -s|--sync)
            if [[ -z "$project_name" ]]; then
                log_error "请指定项目名称"
                exit 1
            fi
            sync_to_git "$project_name" false
            ;;
        -sa|--sync-all)
            if [[ -z "$project_name" ]]; then
                log_error "请指定项目名称"
                exit 1
            fi
            sync_to_git "$project_name" true
            ;;
        -b|--backup)
            backup_research "$project_name"
            ;;
        -j|--journal)
            if [[ -z "$project_name" ]]; then
                log_error "请指定项目名称"
                exit 1
            fi
            add_journal_entry "$project_name"
            ;;
        -r|--report)
            if [[ -z "$project_name" ]]; then
                log_error "请指定项目名称"
                exit 1
            fi
            new_project_report "$project_name"
            ;;
        -c|--clean)
            if [[ -z "$project_name" ]]; then
                log_error "请指定项目名称"
                exit 1
            fi
            clear_intermediate_files "$project_name"
            ;;
        -a|--auto)
            if [[ -z "$project_name" ]]; then
                log_error "请指定项目名称"
                exit 1
            fi
            start_auto_workflow "$project_name"
            ;;
        -gs|--git-status)
            local git_tools
            readarray -t git_tools < <(test_git_cli)
            echo ""
            log_info "Git CLI 工具检测结果:"
            if [[ ${#git_tools[@]} -eq 0 ]]; then
                log_warn "未检测到任何Git CLI工具"
                echo -e "  ${YELLOW}建议安装: GitHub CLI (gh) 或 GitLab CLI (glab)${NC}"
                echo -e "  ${YELLOW}使用 Homebrew: brew install gh 或 brew install glab${NC}"
            else
                for tool in "${git_tools[@]}"; do
                    IFS='|' read -r name platform version <<< "$tool"
                    echo -e "  ${GREEN}✓ $name - $version${NC}"
                    echo -e "    ${BLUE}平台: $platform${NC}"
                done
            fi
            echo ""
            log_info "当前Git配置:"
            echo -e "  ${BLUE}平台: $GIT_PLATFORM${NC}"
            echo -e "  ${BLUE}用户名: ${GIT_USERNAME:-未配置}${NC}"
            echo -e "  ${BLUE}默认可见性: $GIT_DEFAULT_VISIBILITY${NC}"
            echo -e "  ${BLUE}自动创建远程: $GIT_AUTO_CREATE_REMOTE${NC}"
            echo -e "  ${BLUE}SSH优先: $GIT_SSH_PREFERRED${NC}"
            ;;
        "")
            # 无参数时显示简短提示
            echo -e "${GREEN}研究管理集成脚本 (macOS版) v$SCRIPT_VERSION${NC}"
            echo ""
            echo -e "${NC}用法: resman <操作> [项目名称]${NC}"
            echo -e "${YELLOW}使用 'resman -h' 查看详细帮助信息${NC}"
            exit 1
            ;;
        *)
            log_error "未知选项: $operation"
            echo -e "${YELLOW}使用 'resman -h' 查看帮助信息${NC}"
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"