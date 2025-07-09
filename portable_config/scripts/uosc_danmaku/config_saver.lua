-- 配置文件保存功能
-- 这个模块提供将运行时配置保存到uosc_danmaku.conf文件的功能

local msg = require('mp.msg')
local utils = require('mp.utils')

local config_saver = {}

-- 获取配置文件路径
local function get_config_path()
    local config_dir = mp.command_native({"expand-path", "~~/script-opts"})
    return utils.join_path(config_dir, "uosc_danmaku.conf")
end

-- 读取配置文件内容
local function read_config_file()
    local config_path = get_config_path()
    local file = io.open(config_path, "r")
    if not file then
        msg.error("无法打开配置文件: " .. config_path)
        return nil
    end
    
    local content = file:read("*all")
    file:close()
    return content
end

-- 写入配置文件
local function write_config_file(content)
    local config_path = get_config_path()
    local file = io.open(config_path, "w")
    if not file then
        msg.error("无法写入配置文件: " .. config_path)
        return false
    end
    
    file:write(content)
    file:close()
    return true
end

-- 更新配置文件中的特定选项
local function update_config_option(key, value)
    local content = read_config_file()
    if not content then
        return false
    end
    
    -- 创建新的配置行
    local new_line = key .. "=" .. tostring(value)
    
    -- 查找并替换现有的配置行
    local pattern = key .. "=([^\r\n]*)"
    local found = false
    
    content = content:gsub(pattern, function(old_value)
        found = true
        return new_line
    end)
    
    -- 如果没有找到现有配置，添加到文件末尾
    if not found then
        content = content .. "\n" .. new_line .. "\n"
    end
    
    return write_config_file(content)
end

-- 保存多个配置选项
function config_saver.save_options(options_table)
    local success = true
    for key, value in pairs(options_table) do
        if not update_config_option(key, value) then
            success = false
            msg.error("保存配置失败: " .. key .. "=" .. tostring(value))
        else
            msg.info("已保存配置: " .. key .. "=" .. tostring(value))
        end
    end
    return success
end

-- 保存单个配置选项
function config_saver.save_option(key, value)
    if update_config_option(key, value) then
        msg.info("已保存配置: " .. key .. "=" .. tostring(value))
        return true
    else
        msg.error("保存配置失败: " .. key .. "=" .. tostring(value))
        return false
    end
end

return config_saver
