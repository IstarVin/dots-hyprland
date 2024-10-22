return {
  "nvim-telescope/telescope.nvim",
  opts = function()
    return {
      defaults = {
        -- I'm adding this `find_command` based on this reddit discussion
        -- https://www.reddit.com/r/neovim/comments/1egczrs/comment/lfsotjx/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        -- However, it doesn't work, also tried without the setup function
        -- require("telescope").setup({
        --   pickers = {
        --     find_files = {
        --       find_command = { "rg", "--files", "--sortr=modified" },
        --     },
        --   },
        -- }),
        -- When I search for stuff in telescope, I want the path to be shown
        -- first, this helps in files that are very deep in the tree and I
        -- cannot see their name.
        -- Also notice the "reverse_directories" option which will show the
        -- closest dir right after the filename
        -- path_display = {
        --   filename_first = {
        --     reverse_directories = true,
        --   },
        -- },
        mappings = {
          n = {
            -- I'm used to closing buffers with "d" from bufexplorer
            ["d"] = require("telescope.actions").delete_buffer,
            -- I'm also used to quitting bufexplorer with q instead of escape
            ["q"] = require("telescope.actions").close,
          },
        },
      },
    }
  end,
}
