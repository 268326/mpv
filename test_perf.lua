-- 简化版本的性能统计 - 完全无外部命令
local system_perf_cache = {
    last_update = 0,
    update_interval = 2.0,
    memory_info = "N/A",
    cpu_estimate = "N/A"
}

-- 获取系统内存信息（使用FFI，无外部命令）
local function get_memory_info()
    local success, ffi = pcall(require, "ffi")
    if not success then
        return "N/A (FFI unavailable)"
    end
    
    local success2, result = pcall(function()
        -- 定义Windows API结构
        ffi.cdef[[
            typedef struct {
                uint32_t dwLength;
                uint32_t dwMemoryLoad;
                uint64_t ullTotalPhys;
                uint64_t ullAvailPhys;
                uint64_t ullTotalPageFile;
                uint64_t ullAvailPageFile;
                uint64_t ullTotalVirtual;
                uint64_t ullAvailVirtual;
                uint64_t ullAvailExtendedVirtual;
            } MEMORYSTATUSEX;
            
            bool GlobalMemoryStatusEx(MEMORYSTATUSEX* lpBuffer);
        ]]
        
        local kernel32 = ffi.load("kernel32")
        local mem_status = ffi.new("MEMORYSTATUSEX")
        mem_status.dwLength = ffi.sizeof(mem_status)
        
        if kernel32.GlobalMemoryStatusEx(mem_status) then
            local total_gb = tonumber(mem_status.ullTotalPhys) / (1024 * 1024 * 1024)
            local avail_gb = tonumber(mem_status.ullAvailPhys) / (1024 * 1024 * 1024)
            local used_gb = total_gb - avail_gb
            local usage_percent = tonumber(mem_status.dwMemoryLoad)
            
            return string.format("%d%% (%.1f / %.1f GB)", usage_percent, used_gb, total_gb)
        else
            return "N/A (API failed)"
        end
    end)
    
    if success2 then
        return result
    else
        return "N/A (FFI error)"
    end
end

-- 估算CPU负载（基于mpv性能指标）
local function estimate_cpu_load()
    local frame_drop = mp.get_property_number("frame-drop-count", 0)
    local mistimed = mp.get_property_number("mistimed-frame-count", 0)
    local vo_drop = mp.get_property_number("vo-drop-frame-count", 0)
    local estimated_frames = mp.get_property_number("estimated-frame-count", 1)
    
    if estimated_frames == 0 then
        return "N/A"
    end
    
    -- 基于丢帧率估算负载
    local total_drops = frame_drop + mistimed + vo_drop
    local drop_rate = (total_drops / estimated_frames) * 100
    
    -- 简单的负载估算（丢帧率越高，负载越高）
    local cpu_load = math.min(drop_rate * 10, 100)
    
    -- 如果有音视频解码信息，可以进一步估算
    local hwdec = mp.get_property_string("hwdec-current", "no")
    if hwdec == "no" then
        cpu_load = math.min(cpu_load + 15, 100) -- 软解码增加负载估算
    end
    
    return string.format("~%.0f%%", cpu_load)
end

-- 更新系统性能缓存
local function update_perf_cache()
    local current_time = mp.get_time()
    if current_time - system_perf_cache.last_update < system_perf_cache.update_interval then
        return
    end
    
    system_perf_cache.last_update = current_time
    
    -- 使用FFI获取内存信息（无外部命令）
    system_perf_cache.memory_info = get_memory_info()
    
    -- 估算CPU负载
    system_perf_cache.cpu_estimate = estimate_cpu_load()
end

print("Performance monitoring functions loaded successfully!")
print("Memory info:", get_memory_info())
print("CPU estimate:", estimate_cpu_load())
