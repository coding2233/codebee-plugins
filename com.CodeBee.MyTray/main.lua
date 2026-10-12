-- My Tray — 独立常驻托盘：全局快捷键 + 快捷入口。
-- plugin.json 的 contributes.tray.standalone = true 时由宿主进程运行，
-- 关闭 CodeBee 后托盘与全局快捷键仍然可用。

local M = {}
local H = nil

-- 生成一个 16x16 RGBA 图标，避免依赖二进制资源。
local function build_icon()
    local w, h = 16, 16
    local out = {}
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local r, g, b, a = 18, 18, 24, 255
            local dx, dy = x - 7.5, y - 7.5
            if dx * dx + dy * dy <= 52 then
                r, g, b = 240, 200, 40
                if y == 5 or y == 8 or y == 11 then
                    r, g, b = 40, 30, 12
                end
            end
            out[#out + 1] = string.char(r, g, b, a)
        end
    end
    return table.concat(out)
end

function M.activate(host)
    H = host

    if not host.tray_show_data(16, 16, build_icon(), "My Tray") then
        host.log("warn", "tray icon could not be created")
    end
    host.tray_set_menu({
        { id = "open",   label = "Open CodeBee" },
        { id = "folder", label = "Open Plugin Folder" },
        { separator = true },
        { id = "greet",  label = "Say Hello" },
        { id = "quit",   label = "Quit Tray" }
    })

    host.register_command("com.codebee.mytray.open", "My Tray: Open CodeBee", function()
        host.show_app()
    end)
    host.register_command("com.codebee.mytray.greet", "My Tray: Say Hello", function()
        host.show_message("My Tray", "Hello from My Tray!")
    end)
    host.register_command("com.codebee.mytray.quit", "My Tray: Quit Tray", function()
        host.quit()
    end)

    -- 系统级全局快捷键（仅独立托盘宿主中生效）。
    if not host.register_global_hotkey("Ctrl+Alt+C", "com.codebee.mytray.open") then
        host.log("warn", "global hotkey Ctrl+Alt+C not registered")
    end
    host.register_global_hotkey("Ctrl+Alt+H", "com.codebee.mytray.greet")
end

function M.on_tray_event(kind, menu_id)
    if not H then return end
    if kind == "hotkey" then
        H.run_command(menu_id)
    elseif kind == "left_click" or menu_id == "open" then
        H.show_app()
    elseif menu_id == "folder" then
        H.open_path(H.plugin_dir)
    elseif menu_id == "greet" then
        H.run_command("com.codebee.mytray.greet")
    elseif menu_id == "quit" then
        H.quit()
    end
end

function M.deactivate()
    if H then H.tray_hide() end
end

return M
