local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_utils = require "telescope.actions.utils"


local project_files = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Project Files",
    finder = finders.new_oneshot_job({ "find", ".", "-type", "f" }, opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      -- Custom action that runs on selected files
      local run_command = function()
        local selections = {}
        action_utils.map_selections(prompt_bufnr, function(entry, index)
          selections[index] = entry.value
        end)

        actions.close(prompt_bufnr)

        if #selections > 0 then
          print("Selected files:")
          for _, file in ipairs(selections) do
            print("  - " .. file)
          end
        else
          print("No files selected")
        end
      end

      -- Override default <CR> action to run command on selections
      actions.select_default:replace(run_command)

      return true
    end,
  }):find()
end

-- project_files()
