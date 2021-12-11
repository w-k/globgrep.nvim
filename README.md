# globgrep

Extends the [telescope](https://github.com/nvim-telescope/telescope.nvim)'s `live_grep` function to allow
specifying glob patterns in the prompt.

Example prompt: `bar|*.rb,*.rake`. Glob patterns go after the pipe character. To use the pipe in the regex
patterns, escape it with a backslash like this `\|`.

Install using the [vim-plug](https://github.com/junegunn/vim-plug):

```
Plug 'w-k/globgrep.nvim
```

Then set a mapping like this:

```
nmap <leader>>f :lua require'globgrep'.search{}<CR>
```
