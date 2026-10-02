-- amhub_ui.lua
-- Provides the AM HUB lib API on top of the Tiki Hub SimpleUI library.

local TikiLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/tiki_ui.lua"
))()

assert(type(TikiLib) == "table" and TikiLib.CreateWindow,
    "Tiki UI library failed to load")

local shim = {}

function shim.CreateWindow(_, config)
    config = config or {}
    local win = TikiLib:CreateWindow({
        Title    = config.Title or "AM HUB",
        Subtitle = config.Subtitle or "",
        Size     = UDim2.fromOffset(760, 560),
        Keybind  = config.MinimizeKey or Enum.KeyCode.RightControl,
        ConfigDir = "AMHUB",
        ClampToScreen = true,
    })

    local proxy = { __win = win }

    function proxy:AddTab(name, icon)
        local tab = win:AddTab(name, icon)
        -- AM HUB is flat: one implicit section per tab.
        local section = tab:AddSection("")
        local tp = { __tab = tab, __section = section }

        function tp:AddLabel(text)
            return section:AddLabel(text)
        end

        function tp:AddButton(text, cb)
            return section:AddButton(text, function()
                if type(cb) == "function" then cb() end
            end)
        end

        function tp:AddToggle(text, opts, cb)
            opts = opts or {}
            return section:AddToggle(text, opts.Default and true or false,
                function(v) if type(cb) == "function" then cb(v) end end)
        end

        function tp:AddSlider(text, opts, cb)
            opts = opts or {}
            return section:AddSlider(
                text,
                opts.Min or 0,
                opts.Max or 100,
                opts.Default or 0,
                function(v) if type(cb) == "function" then cb(v) end end,
                opts.Increment or 1
            )
        end

        function tp:AddDropdown(text, opts, cb)
            opts = opts or {}
            return section:AddDropdown(
                text,
                opts.Values or {},
                opts.Default or "",
                function(v) if type(cb) == "function" then cb(v) end end
            )
        end

        function tp:AddTextBox(text, cb)
            return section:AddTextbox(text, "", "Type here...",
                function(v) if type(cb) == "function" then cb(v) end end)
        end

        function tp:AddColorPicker(text, color, cb)
            return section:AddColorpicker(
                text,
                color or Color3.fromRGB(255, 255, 255),
                function(c) if type(cb) == "function" then cb(c) end end
            )
        end

        return tp
    end

    return proxy
end

function shim:Notify(title, text, duration)
    TikiLib:Notify({
        Title    = title or "AM HUB",
        Text     = text or "",
        Duration = duration or 4,
        Kind     = "info",
    })
end

return shim
