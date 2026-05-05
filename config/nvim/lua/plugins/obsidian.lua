-- Candidate vault paths across machines. The first one that exists wins;
-- if none exist (e.g. fresh Linux box with no vault synced yet), the plugin
-- is disabled entirely so it doesn't error out at startup.
local vault_candidates = {
  "/Users/andyhuynh/Library/Mobile Documents/iCloud~md~obsidian/Documents/obs",
  vim.fn.expand("~/obs"),
  vim.fn.expand("~/Documents/obs"),
}

local function existing_vaults()
  local found = {}
  for _, path in ipairs(vault_candidates) do
    if vim.fn.isdirectory(path) == 1 then
      table.insert(found, { name = "obs", path = path })
    end
  end
  return found
end

return {
  "obsidian-nvim/obsidian.nvim",
  enabled = function()
    return #existing_vaults() > 0
  end,

  keys = {
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Display Dailies" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
    { "<leader>onn", "<cmd>ObsidianNewFromTemplate<cr>", desc = "New Note from Template" },
    { "<leader>oml", "i[]()<Esc>F[a", desc = "Markdown Link" },
    { "<leader>onl", "<cmd>ObsidianLinkNew<cr>", desc = "New Link", mode = "v" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday" },
    { "<leader>ott", "<cmd>ObsidianToday<cr>", desc = "Today" },
    { "<leader>otT", "<cmd>ObsidianTomorrow<cr>", desc = "Tomorrow" },
    { "<leader>so", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian" },
    {
      "<leader>ob",
      function()
        local api = require("obsidian.api")
        local search = require("obsidian.search")
        local note = api.current_note(0, {})
        if not note then
          vim.notify("Not inside an Obsidian note", vim.log.levels.WARN)
          return
        end
        -- DEBUG: write to file for full inspection
        local refs = note:get_reference_paths({ urlencode = true })
        local terms = search._build_backlink_search_term(note, nil, nil)
        local debug_out = "Note ID: " .. tostring(note.id) .. "\n"
          .. "Path: " .. tostring(note.path) .. "\n"
          .. "Aliases: " .. vim.inspect(note.aliases) .. "\n"
          .. "Refs: " .. vim.inspect(refs) .. "\n"
          .. "Search terms: " .. vim.inspect(terms) .. "\n"
          .. "Search dir: " .. tostring(Obsidian.dir) .. "\n"
        local f = io.open("/tmp/obsidian-backlinks-debug.txt", "w")
        f:write(debug_out)
        f:close()
        vim.notify("Debug written to /tmp/obsidian-backlinks-debug.txt", vim.log.levels.INFO)
        -- END DEBUG
      end,
      desc = "Backlinks",
    },
    { "<leader>ota", "<cmd>ObsidianTags<cr>", desc = "Tags" },
    { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links" },
    {
      "<leader>oil",
      function()
        Obsidian.picker.find_notes({
          prompt_title = "Insert Link",
          callback = function(path)
            local note = require("obsidian.note").from_file(path)
            local link = note:format_link()
            vim.api.nvim_put({ link }, "", false, true)
          end,
        })
      end,
      desc = "Insert Existing Backlink",
    },
    {
      "<leader>otd",
      function()
        local date = os.date("%Y-%m-%d")
        vim.api.nvim_put({ "[[" .. date .. "]]" }, "", false, true)
      end,
      desc = "Insert Today's Date",
    },
  },

  opts = {
    workspaces = existing_vaults(),
    notes_subdir = "00-Inbox",
    log_level = vim.log.levels.WARN, -- reduce logging overhead

    -- sets frontmatter for notes to filename
    note_id_func = function(title)
      if title ~= nil then
        return title
      end
      return tostring(os.time())
    end,

    daily_notes = {
      folder = "01-Daily",
      date_format = "%Y-%m-%d",
      default_tags = { "daily" },
      template = "05-System/01-Templates/daily-note.md",
      workdays_only = false,
    },

    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 3, -- increased to reduce completion triggers
    },

    new_notes_location = "notes_subdir",

    templates = {
      subdir = "05-System/01-Templates",
      date_format = "%Y-%m-%d",
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
      img_folder = "05-System/02-Attachments",
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
      enable = false, -- disable obsidian.nvim UI to avoid conflicts with render-markdown.nvim
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
