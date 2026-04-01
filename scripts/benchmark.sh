#!/bin/bash

# Neovim 启动时间性能测试脚本
# 运行50次并统计最大/最小/平均启动时间

ITERATIONS=50
declare -a times

echo "开始测试 Neovim 启动时间 (共 $ITERATIONS 次)..."
echo "================================"

for i in $(seq 1 $ITERATIONS); do
  # 使用 date 获取纳秒级时间戳
  start=$(date +%s%N)
  
  # 启动 nvim 并立即退出（--headless 加载完整配置但不开 UI）
  nvim --headless -c 'qa!' > /dev/null 2>&1
  
  end=$(date +%s%N)
  
  # 转换为毫秒 (纳秒 -> 毫秒)
  elapsed=$(echo "scale=2; ($end - $start) / 1000000" | bc)
  times+=($elapsed)
  
  printf "\r进度: %d/%d - 本次启动时间: %sms  " $i $ITERATIONS "$elapsed"
done

echo -e "\n================================\n"

# 计算统计数据
total=0
min=${times[0]}
max=${times[0]}

for time in "${times[@]}"; do
  total=$(echo "$total + $time" | bc)
  
  # 比较找最小值
  if (( $(echo "$time < $min" | bc -l) )); then
    min=$time
  fi
  
  # 比较找最大值
  if (( $(echo "$time > $max" | bc -l) )); then
    max=$time
  fi
done

average=$(echo "scale=2; $total / $ITERATIONS" | bc)

echo "测试结果统计:"
echo "================================"
echo "最小启动时间: ${min}ms"
echo "最大启动时间: ${max}ms"
echo "平均启动时间: ${average}ms"
echo "================================"
