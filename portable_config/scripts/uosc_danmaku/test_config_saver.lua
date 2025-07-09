-- 测试配置保存功能
local config_saver = require('config_saver')

-- 测试保存单个选项
local success = config_saver.save_option("displayarea", "0.25")
print("保存 displayarea=0.25 结果:", success)

-- 测试保存多个选项
local options_table = {
    fontsize = "45",
    bold = "true",
    outline = "1.5"
}
local success_multi = config_saver.save_options(options_table)
print("保存多个选项结果:", success_multi)
