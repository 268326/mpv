cd "d:\mpv-lazy"
echo "Testing mpv with stats.lua..."
echo "Starting mpv in background..."
start "" "mpv.exe" --no-config --idle --msg-level=all=debug 2>&1 | findstr /i "error stats" | head -10
