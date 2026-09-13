-- Personal input overrides. Loaded after Omarchy defaults.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
  input = {
    -- Swap Alt/Super so external keyboards match ThinkPad muscle memory;
    -- Caps Lock acts as Ctrl.
    kb_options = "altwin:swap_alt_win,ctrl:nocaps",

    repeat_rate = 40,
    repeat_delay = 600,

    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.4,
    },
  },
})

-- External keyboard: Super/Alt behave as the OS expects (no swap).
hl.device({
  name = "iqunix-mg65-bt2-keyboard",
  kb_options = "altwin:alt_super_win,ctrl:nocaps",
})

hl.device({
  name = "logitech-mx-master-3s",
  natural_scroll = true,
})

-- Scroll faster in the terminal.
o.window("(Alacritty|foot)", { scroll_touchpad = 1.5 })
