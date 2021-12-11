local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values

local globgrep = {}

function get_query_and_glob(prompt)
  query = {}
  glob = {}
  curr = query
  escape = false
  for ch in prompt:gmatch'.' do
    if escape then
      if ch == '|' then
        table.insert(curr, '|')
      else
        table.insert(curr, '\\')
        table.insert(curr, ch)
      end
      escape = false
    elseif ch == '|' then
      curr = glob
    elseif ch == '\\' then
      escape = true
    else
      table.insert(curr, ch)
    end
  end
  return table.concat(query, ''), table.concat(glob, '')
end

globgrep.search = function(opts)
  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local file_mask_grepper = finders.new_job(function(prompt)
    if not prompt or prompt == "" then
      return nil
    end

    query_prompt, glob_prompt = get_query_and_glob(prompt)

    globs = {}
    if glob_prompt ~= '' then
      for glob in string.gmatch(glob_prompt, '([^,]+)') do
        table.insert(globs, "--glob")
        table.insert(globs, glob)
      end
    end

    return vim.tbl_flatten { vimgrep_arguments, globs, "--", query_prompt, "." }
  end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers.new(opts, {
    prompt_title = "Live Grep",
    finder = file_mask_grepper,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.highlighter_only(opts),
  }):find()
end

return globgrep
