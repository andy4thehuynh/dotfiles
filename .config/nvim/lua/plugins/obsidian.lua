return {
  "obsidian-nvim/obsidian.nvim",

  keys = {
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Display Dailies" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
    { "<leader>onn", "<cmd>ObsidianNewFromTemplate<cr>", desc = "New Note from Template" },
    { "<leader>onl", "<cmd>ObsidianNewLink<cr>", desc = "New Link" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday" },
    { "<leader>ott", "<cmd>ObsidianToday<cr>", desc = "Today" },
    { "<leader>otT", "<cmd>ObsidianTomorrow<cr>", desc = "Tomorrow" },
    { "<leader>so", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    { "<leader>ota", "<cmd>ObsidianTags<cr>", desc = "Tags" },
    { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links" },
  },

  opts = {
    workspaces = {
      {
        name = "obs",
        path = "/Users/andyhuynh/Library/Mobile Documents/iCloud~md~obsidian/Documents/obs",
      },
    },
    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "01-inbox",
    -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.*".
    log_level = vim.log.levels.INFO,

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "40-daily-notes",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y%m%d", -- e.g. 20251219 is dec 19th 2025
      -- Optional, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%Y%m%d",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daily" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "00-system/00-01-templates/00-01-02-daily-note-template",
      -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
      workdays_only = false,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Enables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Where to put new notes. Valid options are
    -- _ "current_dir" - put new notes in same directory as the current buffer.
    -- _ "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "notes_subdir",

    templates = {
      subdir = "00-system/00-01-templates",
      date_format = "%Y%m%d", -- e.g. 20251219 is dec 19th 2025
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'snacks.pick' or 'mini.pick'.
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
    },

    attachments = {
      img_folder = "00-system/00-02-assets",
    },
  },

  lazy = false, -- init on startup so that you can use obs regardless of filetype
  event = "LazyFile",
  version = "*", -- recommended, use latest release instead of latest commit
  -- ft = "markdown", -- unnecessary if lazy = false
}
