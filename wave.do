# wave.do - Questasim波形自动加载配置
# 1. 打开波形窗口
if {[winfo exists .wave]} { destroy .wave }
wave create .wave

# 2. 加载全层级波形（top为你的顶层模块，*表示所有子模块/信号）
add wave -position insertpoint sim:/%TOP_MODULE%/*

# 3. 波形优化设置
wave configure -signalnamewidth 100  # 加宽信号名显示
wave configure -timelineunits ns     # 时间轴单位设为ns
wave refresh                         # 刷新波形

# 4. 自动展开所有信号组
wave expandall