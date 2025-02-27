### private-mode-nvim AKA "vimcognito"

Open sensitive buffers with no traces left behind.

It also disables 'cmp' for the buffer (if it is installed).

### Installation

Using [lazy.nvim]

```lua
return {
    "skeletony007/private-mode.nvim",

    config = true,
}
```

### Setup

```lua
require("private-mode").setup({
    file_patterns = { "*/pass.*/*" },
})
```

[lazy.nvim]: https://github.com/folke/lazy.nvim
