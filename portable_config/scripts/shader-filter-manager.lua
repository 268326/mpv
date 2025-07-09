-- 着色器和滤镜状态管理脚本
-- 保存、恢复和显示着色器滤镜状态

local mp = require 'mp'
local utils = require 'mp.utils'
local msg = require 'mp.msg'

-- 状态存储
local saved_state = {
    glsl_shaders = {},
    vf_filters = {}
}

-- 信息显示状态
local info_displayed = false

-- 保存着色器和滤镜状态
function save_shader_filter_state()
    -- 获取当前GLSL着色器列表
    local current_shaders = mp.get_property_native("glsl-shaders")
    if current_shaders then
        saved_state.glsl_shaders = {}
        for i, shader in ipairs(current_shaders) do
            saved_state.glsl_shaders[i] = shader
        end
    end
    
    -- 获取当前视频滤镜列表
    local current_vf = mp.get_property_native("vf")
    if current_vf then
        saved_state.vf_filters = {}
        for i, filter in ipairs(current_vf) do
            saved_state.vf_filters[i] = filter
        end
    end
    
    local shader_count = current_shaders and #current_shaders or 0
    local filter_count = current_vf and #current_vf or 0
    
    mp.osd_message("已保存状态: " .. shader_count .. " 个着色器, " .. filter_count .. " 个滤镜")
    msg.info("保存着色器和滤镜状态成功")
end

-- 恢复着色器和滤镜状态
function restore_shader_filter_state()
    -- 恢复GLSL着色器
    if saved_state.glsl_shaders then
        -- 先清空现有着色器
        mp.set_property_native("glsl-shaders", {})
        
        -- 恢复保存的着色器
        if #saved_state.glsl_shaders > 0 then
            mp.set_property_native("glsl-shaders", saved_state.glsl_shaders)
        end
    end
    
    -- 恢复视频滤镜
    if saved_state.vf_filters then
        -- 先清空现有滤镜
        mp.set_property_native("vf", {})
        
        -- 恢复保存的滤镜
        if #saved_state.vf_filters > 0 then
            mp.set_property_native("vf", saved_state.vf_filters)
        end
    end
    
    local shader_count = saved_state.glsl_shaders and #saved_state.glsl_shaders or 0
    local filter_count = saved_state.vf_filters and #saved_state.vf_filters or 0
    
    mp.osd_message("已恢复状态: " .. shader_count .. " 个着色器, " .. filter_count .. " 个滤镜")
    msg.info("恢复着色器和滤镜状态成功")
end

-- 显示着色器和滤镜信息
function show_shader_filter_info()
    -- 如果已经显示了，则隐藏信息
    if info_displayed then
        mp.command("show-text \"\" 0")
        info_displayed = false
        msg.info("隐藏着色器和滤镜信息")
        return
    end
    
    local current_shaders = mp.get_property_native("glsl-shaders") or {}
    local current_vf = mp.get_property_native("vf") or {}
    
    local info_text = "=== 当前状态 ===\\n"
    
    -- 显示着色器信息
    info_text = info_text .. "GLSL着色器 (" .. #current_shaders .. " 个):\\n"
    if #current_shaders > 0 then
        for i, shader in ipairs(current_shaders) do
            local shader_name = shader:match("([^/\\]+)%.glsl$") or shader
            info_text = info_text .. "  " .. i .. ". " .. shader_name .. "\\n"
        end
    else
        info_text = info_text .. "  无\\n"
    end
    
    info_text = info_text .. "\\n"
    
    -- 显示滤镜信息
    info_text = info_text .. "视频滤镜 (" .. #current_vf .. " 个):\\n"
    if #current_vf > 0 then
        for i, filter in ipairs(current_vf) do
            local filter_name = filter.name or "unknown"
            info_text = info_text .. "  " .. i .. ". " .. filter_name
            if filter.params then
                local params = {}
                for k, v in pairs(filter.params) do
                    table.insert(params, k .. "=" .. tostring(v))
                end
                if #params > 0 then
                    info_text = info_text .. " [" .. table.concat(params, ", ") .. "]"
                end
            end
            info_text = info_text .. "\\n"
        end
    else
        info_text = info_text .. "  无\\n"
    end
    
    -- 显示保存的状态信息
    info_text = info_text .. "\\n=== 保存的状态 ===\\n"
    local saved_shader_count = saved_state.glsl_shaders and #saved_state.glsl_shaders or 0
    local saved_filter_count = saved_state.vf_filters and #saved_state.vf_filters or 0
    
    info_text = info_text .. "保存的着色器: " .. saved_shader_count .. " 个\\n"
    info_text = info_text .. "保存的滤镜: " .. saved_filter_count .. " 个\\n"
    info_text = info_text .. "\\n(再次按 Ctrl+Alt+i 隐藏信息)"
    
    -- 使用 show-text 命令持续显示信息，这样字体大小会与系统 OSD 保持一致
    mp.command("show-text \"" .. info_text .. "\" 999999")
    info_displayed = true
    msg.info("显示着色器和滤镜信息")
end

-- 注册脚本绑定
mp.register_script_message("save-shader-filter-state", save_shader_filter_state)
mp.register_script_message("restore-shader-filter-state", restore_shader_filter_state)
mp.register_script_message("show-shader-filter-info", show_shader_filter_info)

-- 添加脚本绑定（作为备用方案）
mp.add_key_binding(nil, "save-shader-filter-state", save_shader_filter_state)
mp.add_key_binding(nil, "restore-shader-filter-state", restore_shader_filter_state)
mp.add_key_binding(nil, "show-shader-filter-info", show_shader_filter_info)

msg.info("着色器和滤镜管理脚本已加载")
