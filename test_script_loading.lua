-- 测试脚本加载是否正常
local mp = require 'mp'
local msg = require 'mp.msg'

-- 在mpv启动时显示测试消息
mp.add_hook("on_load", 50, function()
    msg.info("脚本加载测试：所有脚本加载正常")
    mp.osd_message("脚本加载测试：所有脚本加载正常", 3)
end)

msg.info("test_script_loading.lua 已成功加载")
