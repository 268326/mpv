# MPV 配置文档说明

本目录包含了所有mpv配置相关的说明文档，这些文档已从scripts目录移动到此处，以避免mpv将它们作为脚本加载而导致错误。

## 目录结构

```
docs/
├── scripts/                    # 脚本相关文档
│   ├── 字幕脚本日志说明.md         # 字幕脚本的日志说明
│   ├── sub-assrt/              # sub-assrt字幕脚本文档
│   │   ├── sub-assrt_usage.md       # 使用说明
│   │   └── sub-assrt_modifications.md   # 修改说明
│   └── uosc_danmaku/          # uosc弹幕脚本文档
│       ├── README.md               # 主要说明
│       ├── README_CONFIG_SAVE.md   # 配置保存说明
│       └── LICENSE                 # 许可证文件
└── README.md                  # 本文件
```

## 各脚本说明

### 1. 字幕脚本 (sub-assrt)
- **位置**: `scripts/sub-assrt.lua`
- **配置**: `script-opts/sub_assrt.conf`
- **文档**: `docs/scripts/sub-assrt/`
- **功能**: 自动搜索和下载字幕文件

### 2. 弹幕脚本 (uosc_danmaku)
- **位置**: `scripts/uosc_danmaku/`
- **配置**: `script-opts/uosc_danmaku.conf`
- **文档**: `docs/scripts/uosc_danmaku/`
- **功能**: 弹幕加载和显示

### 3. 其他脚本
- **上下文菜单**: `scripts/contextmenu_plus.lua`
- **画中画**: `scripts/pip.lua`
- **质量菜单**: `scripts/quality-menu.lua`
- **缩略图**: `scripts/thumbfast.lua`
- **赞助块跳过**: `scripts/sponsorblock_minimal.lua`
- **着色器管理**: `scripts/shader-filter-manager.lua`
- **属性保存**: `scripts/save_global_props.lua`

## 注意事项

1. 所有说明文件已从scripts目录移动到docs目录，以避免mpv将它们作为脚本加载
2. 如果需要查看某个脚本的说明，请到对应的docs子目录中查找
3. 配置文件仍然在原来的位置（script-opts目录）
4. 脚本文件仍然在原来的位置（scripts目录）

## 更新日期
2025年7月9日
