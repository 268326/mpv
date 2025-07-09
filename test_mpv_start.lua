-- 简单的mpv启动测试
print("正在测试mpv启动...")
os.execute('"d:\\mpv-lazy\\mpv.exe" --no-config --idle --msg-level=all=debug | findstr /i "stats\|error" | head -10')
print("测试完成。")
