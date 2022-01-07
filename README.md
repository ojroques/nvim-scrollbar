# nvim-scrollbar

A simple and fast scrollbar for Neovim. It is deliberately feature-less and will
remain so.

![demo](./demo.gif)

## Installation
With [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use {'ojroques/nvim-scrollbar'}
```

With [paq-nvim](https://github.com/savq/paq-nvim):
```lua
paq {'ojroques/nvim-scrollbar'}
```

## Usage
In your *init.lua*:
```lua
require('scrollbar').setup {}
```

If you're using a *.vimrc* or *init.vim*:
```vim
lua require('scrollbar').setup {}
```

## Configuration
You can pass options to the `setup()` function. Here are all available options
with their default settings:
```lua
M.options = {
  symbol_bar = {' ', 'TermCursor'},  -- Bar symbol and highlight group
  symbol_track = {},                 -- Track symbol and highlight group (leave empty to not draw the track)
  priority = 10,                     -- Priority of scrollbar (low value = high priority)
  exclude_buftypes = {},             -- Buftypes to exclude
  exclude_filetypes = {              -- Filetypes to exclude
    'qf',
  },
  render_events = {                  -- Events triggering the redraw of the bar
    'BufWinEnter',
    'CmdwinLeave',
    'TabEnter',
    'TermEnter',
    'TextChanged',
    'VimResized',
    'WinEnter',
    'WinScrolled',
  },
}
```

## Related plugins
* [petertriho's nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar): a
  scrollbar for Neovim with more features.
* [vim-scrollstatus](https://github.com/ojroques/vim-scrollstatus): a Vim plugin
  (also compatible with Neovim) to display a scrollbar in the statusline.

## License
[LICENSE](./LICENSE)
