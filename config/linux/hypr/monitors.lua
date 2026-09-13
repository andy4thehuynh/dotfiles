-- Personal monitor layout. Loaded after Omarchy defaults, replaces them.
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- NOTE: the rules below CONDENSE/squish the internal display when no external
-- monitor is attached (the "auto" fallback string misinterprets scale).
-- Re-enable only when docked, or switch the fallback to a numeric scale first.

-- ThinkPad internal display on the left.
-- hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })

-- LEN P32u-10 external display on the right.
-- hl.monitor({ output = "HDMI-A-2", mode = "3840x2160@30", position = "1920x0", scale = 2 })

-- Fallback for any other monitor.
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
