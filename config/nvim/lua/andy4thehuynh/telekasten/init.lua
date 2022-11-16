local home_dir = vim.fn.expand("~/.local/share/telekasten")

require('telekasten').setup({
  -- sets telekasten home directory
  home = home_dir,


  -- dir names for special notes (absolute path or subdir name)
  dailies   = home_dir .. '/' .. 'daily',
  weeklies  = home_dir .. '/' .. 'weekly',
  templates = home_dir .. '/' .. 'templates',


  -- Generate note filenames. One of:
  -- "title" (default) - Use title if supplied, uuid otherwise
  -- "uuid" - Use uuid
  -- "uuid-title" - Prefix title by uuid
  -- "title-uuid" - Suffix title with uuid
  new_note_filename = "uuid-title",
  -- file uuid type ("rand" or input for os.date()")
  uuid_type = "%Y%m%d%H%M",
  -- UUID separator
  uuid_sep = "_",


  -- following a link to a non-existing note will NOT create it
  follow_creates_nonexisting = false,
  dailies_create_nonexisting = false,
  weeklies_create_nonexisting = false,


  -- opens telescope prompt for goto_today and goto_thisweek if true
  journal_auto_open = true,


  -- template for new notes (new_note, follow_link)
  -- set to `nil` or do not specify if you do not want a template
  template_new_note = home_dir .. '/' .. 'templates/new_note.md',


  -- template for newly created daily notes (goto_today)
  -- set to `nil` or do not specify if you do not want a template
  template_new_daily = home_dir .. '/' .. 'templates/daily.md',


  -- template for newly created weekly notes (goto_thisweek)
  -- set to `nil` or do not specify if you do not want a template
  template_new_weekly= home_dir .. '/' .. 'templates/weekly.md',


  -- default sort option: 'filename', 'modified'
  sort = "filename",


  -- integrate with calendar-vim
  plug_into_calendar = true,
  calendar_opts = {
    -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
    weeknm = 1,
    -- use monday as first day of week: 1 .. true, 0 .. false
    calendar_monday = 1,
    -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
    calendar_mark = 'left-fit',
  },


  -- telescope actions behavior
  close_after_yanking = false,
  insert_after_inserting = true,


  -- tag notation: '#tag', ':tag:', 'yaml-bare'
  tag_notation = "#tag",


  -- command palette theme: dropdown (window) or ivy (bottom panel)
  command_palette_theme = "dropdown",


  -- tag list theme:
  -- get_cursor: small tag list at cursor; ivy and dropdown like above
  show_tags_theme = "dropdown",


  -- when linking to a note in subdir/, create a [[subdir/title]] link
  -- instead of a [[title only]] link
  subdirs_in_links = true,


  -- template_handling
  -- What to do when creating a new note via `new_note()` or `follow_link()`
  -- to a non-existing note
  -- - prefer_new_note: use `new_note` template
  -- - smart: if day or week is detected in title, use daily / weekly templates (default)
  -- - always_ask: always ask before creating a note
  template_handling = "smart",


  -- path handling:
  --   this applies to:
  --     - new_note()
  --     - new_templated_note()
  --     - follow_link() to non-existing note
  --
  --   it does NOT apply to:
  --     - goto_today()
  --     - goto_thisweek()
  --
  --   Valid options:
  --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
  --              all other ones in home, except for notes/with/subdirs/in/title.
  --              (default)
  --
  --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
  --                    except for notes with subdirs/in/title.
  --
  --     - same_as_current: put all new notes in the dir of the current note if
  --                        present or else in home
  --                        except for notes/with/subdirs/in/title.
  new_note_location = "smart",


  -- should all links be updated when a file is renamed
  rename_update_links = true,


  -- how to preview media files
  -- "telescope-media-files" if you have telescope-media-files.nvim installed
  -- "catimg-previewer" if you have catimg installed
  media_previewer = "telescope-media-files",
})


-- syntax highlighting
vim.cmd[[
  " just blue and gray links
  hi tkLink ctermfg=Blue cterm=bold,underline guifg=blue gui=bold,underline
  hi tkBrackets ctermfg=gray guifg=gray


  " for gruvbox
  hi tklink ctermfg=72 guifg=#689d6a cterm=bold,underline gui=bold,underline
  hi tkBrackets ctermfg=gray guifg=gray

  " real yellow
  hi tkHighlight ctermbg=yellow ctermfg=darkred cterm=bold guibg=yellow guifg=darkred gui=bold
  " gruvbox
  "hi tkHighlight ctermbg=214 ctermfg=124 cterm=bold guibg=#fabd2f guifg=#9d0006 gui=bold

  hi link CalNavi CalRuler
  hi tkTagSep ctermfg=gray guifg=gray
  hi tkTag ctermfg=175 guifg=#d3869B
]]


-- mappings
local function map(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
map("n", "<leader>t", "<cmd>lua require('telekasten').panel()<cr>")
map("n", "<leader>tt", "<cmd>lua require('telekasten').goto_today()<cr>")
map("n", "<leader>ts", "<cmd>lua require('telekasten').search_notes()<cr>")
map("n", "<leader>tp", "<cmd>lua require('telekasten').paste_img_and_link()<cr>")
