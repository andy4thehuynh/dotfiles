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
  },

  opts = {
    workspaces = {
      {
        name = "obs",
        path = "/Users/andyhuynh/Library/Mobile Documents/iCloud~md~obsidian/Documents/obs",
      },
    },
    notes_subdir = "01-inbox",
    log_level = vim.log.levels.WARN, -- reduce logging overhead

    daily_notes = {
      folder = "40-daily-notes",
      date_format = "%Y%m%d",
      default_tags = { "daily" },
      template = "00-system/00-01-templates/00-01-02-daily-note-template",
      workdays_only = false,
    },

    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 3, -- increased to reduce completion triggers
    },

    new_notes_location = "notes_subdir",

    templates = {
      subdir = "00-system/00-01-templates",
      date_format = "%Y%m%d",
      time_format = "%H:%M",
      substitutions = {},
    },

    picker = {
      name = "telescope.nvim",
      mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
    },

    attachments = {
      img_folder = "00-system/00-02-assets",
    },

    -- PERFORMANCE: Disable statusline (calculates backlinks on every update)
    statusline = {
      enabled = false,
    },

    -- PERFORMANCE: Disable footer (also calculates backlinks continuously)
    footer = {
      enabled = false,
    },

    -- PERFORMANCE: Disable UI features or increase debounce for large vaults
    ui = {
      enable = true,
      update_debounce = 500, -- increased from 200ms to 500ms
      max_file_length = 2000, -- reduced from 5000 to skip UI on large files
    },

    -- PERFORMANCE: Limit search operations for large vaults
    search = {
      max_lines = 500, -- reduced from 1000
    },

    -- PERFORMANCE: Disable header parsing in backlinks (reduces parsing overhead)
    backlinks = {
      parse_headers = false,
    },
  },

  lazy = false,
  event = "LazyFile",
  version = "*",
}
