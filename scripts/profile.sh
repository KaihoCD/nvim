#!/bin/bash

# Neovim 启动模块耗时分析脚本
# 使用 --startuptime 记录每个 require/sourcing 的加载时间，排序后输出 Top N

TOP_N=${1:-20}
LOG_FILE="/tmp/nvim-profile-$$.log"

echo "正在采集启动时间数据..."
nvim --headless --startuptime "$LOG_FILE" -c 'qa!' > /dev/null 2>&1

# startuptime 格式（有self时间的行，三列数字）：
#   clock  self+sourced  self:  require('xxx')
#   clock  self+sourced  self:  sourcing /path/to/file

echo ""
echo "Top $TOP_N 最耗时条目（按自身耗时排序）："
echo "================================================================"
printf "%-10s %-12s %s\n" "自身(ms)" "含子项(ms)" "模块"
echo "----------------------------------------------------------------"

awk '
  # 匹配有三列数字的行（require 和 sourcing 都是这种格式）
  /^[0-9]+\.[0-9]+  [0-9]+\.[0-9]+  [0-9]+\.[0-9]+:/ {
    # $1=clock, $2=self+sourced, $3=self（末尾带冒号）
    self_str = $3
    sub(/:$/, "", self_str)
    self = self_str + 0
    total_with_children = $2 + 0

    # 拼回描述部分（第4列之后）
    desc = ""
    for (i = 4; i <= NF; i++) desc = desc (i == 4 ? "" : " ") $i

    printf "%s %s %s\n", self_str, $2, desc
  }
' "$LOG_FILE" \
  | sort -rn \
  | head -n "$TOP_N" \
  | awk '{
    printf "%-10s %-12s %s\n", $1, $2, substr($0, length($1)+length($2)+3)
  }'

echo ""
echo "----------------------------------------------------------------"
echo "按大模块分组汇总（自身耗时，不含子项）："
echo "----------------------------------------------------------------"

awk '
  /^[0-9]+\.[0-9]+  [0-9]+\.[0-9]+  [0-9]+\.[0-9]+:/ {
    self_str = $3; sub(/:$/, "", self_str); self = self_str + 0

    desc = ""
    for (i = 4; i <= NF; i++) desc = desc (i == 4 ? "" : " ") $i

    if      (desc ~ /require\('"'"'core/)          core_ms    += self
    else if (desc ~ /require\('"'"'utils/)          utils_ms   += self
    else if (desc ~ /require\('"'"'modules/)        modules_ms += self
    else if (desc ~ /require\('"'"'plugins/)        plugins_ms += self
    else if (desc ~ /require\('"'"'devtools/)       devtools_ms+= self
    else if (desc ~ /require\('"'"'vim\./)          vim_ms     += self
    else if (desc ~ /nvim\/runtime/)                runtime_ms += self
    else                                            other_ms   += self
    total_ms += self
  }
  END {
    printf "  core/         : %7.3f ms\n", core_ms
    printf "  modules/      : %7.3f ms\n", modules_ms
    printf "  plugins/      : %7.3f ms\n", plugins_ms
    printf "  devtools/     : %7.3f ms\n", devtools_ms
    printf "  utils/        : %7.3f ms\n", utils_ms
    printf "  vim 内置       : %7.3f ms\n", vim_ms
    printf "  nvim runtime  : %7.3f ms\n", runtime_ms
    printf "  其他           : %7.3f ms\n", other_ms
    printf "  ─────────────────────────\n"
    printf "  合计           : %7.3f ms\n", total_ms
  }
' "$LOG_FILE"

echo ""
echo "完整日志: $LOG_FILE"
