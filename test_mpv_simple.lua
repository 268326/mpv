-- 测试mpv启动和stats脚本
print("Testing MPV startup with stats script...")

-- 创建一个简单的测试文件
local testfile = io.open("test_startup.txt", "w")
testfile:write("MPV startup test\n")
testfile:close()

-- 执行mpv测试
local result = os.execute('"d:\\mpv-lazy\\mpv.exe" --no-config --idle --msg-level=all=debug --load-scripts=no --script="portable_config\\scripts\\stats.lua" 2>&1 | findstr /i "error\\|stats" | head -20')

print("Test result:", result)
print("Test completed.")

-- 清理测试文件
os.remove("test_startup.txt")
