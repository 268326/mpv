-- 测试CPU和GPU使用率获取的简单脚本
local function test_cpu_usage()
    local cpu_usage = "N/A"
    print("Testing CPU usage...")
    
    -- 尝试使用PowerShell命令获取CPU使用率
    local handle = io.popen('powershell -Command "Get-Counter \\\"\\Processor(_Total)\\% Processor Time\\\" -SampleInterval 1 -MaxSamples 1 | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | ForEach-Object { [math]::Round($_, 1) }" 2>nul')
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result and result:match("%d+") then
            cpu_usage = result:match("([%d%.]+)") .. "%"
            print("CPU usage (PowerShell): " .. cpu_usage)
        else
            print("PowerShell CPU method failed")
        end
    end
    
    -- 如果PowerShell失败，尝试使用wmic
    if cpu_usage == "N/A" then
        local handle2 = io.popen('wmic cpu get loadpercentage /value 2>nul')
        if handle2 then
            local result2 = handle2:read("*a")
            handle2:close()
            if result2 then
                local usage = result2:match("LoadPercentage=(%d+)")
                if usage then
                    cpu_usage = usage .. "%"
                    print("CPU usage (wmic): " .. cpu_usage)
                end
            end
        end
    end
    
    if cpu_usage == "N/A" then
        print("CPU usage: Unable to detect")
    end
    
    return cpu_usage
end

local function test_gpu_usage()
    local gpu_usage = "N/A"
    print("Testing GPU usage...")
    
    -- 尝试使用nvidia-smi命令获取GPU使用率
    local handle = io.popen('nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>nul')
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result and result:match("%d+") then
            gpu_usage = result:match("(%d+)") .. "%"
            print("GPU usage (nvidia-smi): " .. gpu_usage)
        else
            print("nvidia-smi GPU method failed")
        end
    end
    
    -- 如果nvidia-smi失败，尝试使用PowerShell获取GPU信息
    if gpu_usage == "N/A" then
        local handle2 = io.popen('powershell -Command "Get-Counter \\\"\\GPU Engine(_Total)\\Utilization Percentage\\\" -SampleInterval 1 -MaxSamples 1 2>nul | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | ForEach-Object { [math]::Round($_, 1) }" 2>nul')
        if handle2 then
            local result2 = handle2:read("*a")
            handle2:close()
            if result2 and result2:match("%d+") then
                gpu_usage = result2:match("([%d%.]+)") .. "%"
                print("GPU usage (PowerShell): " .. gpu_usage)
            else
                print("PowerShell GPU method failed")
            end
        end
    end
    
    if gpu_usage == "N/A" then
        print("GPU usage: Unable to detect")
    end
    
    return gpu_usage
end

local function test_memory_usage()
    local memory_usage = "N/A"
    print("Testing Memory usage...")
    
    -- 使用PowerShell获取内存使用情况
    local handle = io.popen('powershell -Command "$mem = Get-CimInstance -ClassName Win32_OperatingSystem; $total = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 2); $free = [math]::Round($mem.FreePhysicalMemory / 1MB, 2); $used = $total - $free; $percent = [math]::Round(($used / $total) * 100, 1); Write-Output \\\"$percent%% ($used / $total GB)\\\"" 2>nul')
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result and result:match("%d+") then
            memory_usage = result:gsub("[\r\n]", "")
            print("Memory usage (PowerShell): " .. memory_usage)
        else
            print("PowerShell memory method failed")
        end
    end
    
    -- 如果PowerShell失败，尝试使用wmic
    if memory_usage == "N/A" then
        local handle2 = io.popen('wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /value 2>nul')
        if handle2 then
            local result2 = handle2:read("*a")
            handle2:close()
            if result2 then
                local total = result2:match("TotalVisibleMemorySize=(%d+)")
                local free = result2:match("FreePhysicalMemory=(%d+)")
                if total and free then
                    local total_mb = math.floor(tonumber(total) / 1024)
                    local used_mb = math.floor((tonumber(total) - tonumber(free)) / 1024)
                    local usage_percent = math.floor((used_mb / total_mb) * 100)
                    memory_usage = string.format("%d%% (%d / %d MB)", usage_percent, used_mb, total_mb)
                    print("Memory usage (wmic): " .. memory_usage)
                end
            end
        end
    end
    
    if memory_usage == "N/A" then
        print("Memory usage: Unable to detect")
    end
    
    return memory_usage
end

print("=== Testing System Performance Detection ===")
test_cpu_usage()
test_gpu_usage()
test_memory_usage()
print("=== Test Complete ===")
