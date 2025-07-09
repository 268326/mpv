local mp = require('mp')
local is_pip_on = false
local store_ontop = false
local store_border = false
local store_size = 0
local store_fullscreen = false

-- 保存当前窗口状态
local function save_window_state()
    store_ontop = mp.get_property_bool('ontop')
    store_border = mp.get_property_bool('border')
    store_size = mp.get_property_number('window-scale')
    store_fullscreen = mp.get_property_bool('fullscreen')
end

local function toggle_pip()
    mp.osd_message("PiP触发")    if not is_pip_on then
        -- 进入画中画模式
        is_pip_on = true
        -- 保存当前状态
        save_window_state()
        
        -- 如果是全屏，先退出全屏
        if mp.get_property_bool('fullscreen') then
            mp.set_property_bool('fullscreen', false)
            -- 等待一小段时间让窗口退出全屏
            mp.add_timeout(0.1, function()
                -- 设置窗口大小和位置
                mp.command('set window-scale 0.25')
                mp.command('set geometry +1500+50')  -- 放在屏幕右上角
            end)
        else
            -- 直接设置窗口大小和位置
            mp.command('set window-scale 0.25')
            mp.command('set geometry +1500+50')  -- 放在屏幕右上角
        end
        
        -- 设置窗口属性
        mp.set_property_bool('ontop', true)
        mp.set_property_bool('border', false)
        mp.set_property_bool('keepaspect', true)
        
        mp.osd_message("PiP模式开启")
    else
        -- 退出画中画模式
        is_pip_on = false
          -- 恢复窗口大小
        if store_size and store_size > 0 then
            mp.command(string.format('set window-scale %f', store_size))
        else
            mp.command('set window-scale 1.0')
        end
        
        -- 恢复原始属性
        mp.set_property_bool('ontop', store_ontop)
        mp.set_property_bool('border', store_border)
        mp.set_property_bool('keepaspect', true)
        
        -- 如果原来是全屏，恢复全屏
        if store_fullscreen then
            mp.set_property_bool('fullscreen', true)
        end
        
        mp.osd_message("PiP模式关闭")
    end
end

-- 在退出时恢复设置
local function reset_prop(info)
    if is_pip_on and info.reason == 'quit' then
        mp.set_property_bool('ontop', store_ontop)
        mp.set_property_bool('border', store_border)
    end
end

-- 注册快捷键和事件
mp.add_key_binding('p', 'toggle-pip', toggle_pip)
mp.register_event('end-file', reset_prop)