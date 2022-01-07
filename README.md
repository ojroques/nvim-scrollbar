# nvim-scrollbar

A simple and fast scrollbar for Neovim.

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
  symbol_bar = {' ', 'TermCursor'},  -- The bar symbol and highlight group
  symbol_track = {},                 -- The track symbol and highlight group
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

## License
[LICENSE](./LICENSE)
