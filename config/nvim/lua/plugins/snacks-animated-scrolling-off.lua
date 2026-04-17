return {
  "folke/snacks.nvim",
  opts = {
    -- Disable scrolling animations
    scroll = {
      enabled = false,
    },

    -- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images#change-image-save-location
    -- Image path resolving
    image = {
      resolve = function(path, src)
        if require("obsidian.api").path_is_note(path) then
          return require("obsidian.api").resolve_image_path(src)
        end
      end,
    },
  },
}
