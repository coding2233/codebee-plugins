# My Tray

一个 CodeBee Lua 插件（由模板生成）。

- `plugin.json` — 清单：`runtime` 为 `lua`，`main` 指向 `main.lua`。
- `main.lua` — 入口，必须 `return` 一个表，可含 `activate(host)` /
  `deactivate()` / `on_event(event)` / `on_tray_event(kind, menu_id)`。

编辑时打开 **帮助 → Lua 插件开发指南**，或用 `Ctrl+Space` 触发 `host.*` API 补全。
