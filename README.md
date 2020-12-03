# nvim-finder
nvim-finder is a fuzzy finder built upon
[popfix](https://github.com/RishabhRD/popfix) fuzzy engine. This repository
if bundle of commands for fuzzy finding various things in neovim.

![](https://user-images.githubusercontent.com/26287448/101091071-ab205700-35dd-11eb-8f28-00bcf6ec63c7.gif)

## Installation

Install it as any other plugin. For example with vim-plug:

- Add this to your init.vim:
   ```vim
   Plug 'RishabhRD/nvim-finder'
   ```
- After re-sorurcing init.vim
   ```vim
   :PlugInstall
   ```

## Invoking plugin

### Using lua

#### With default opts

```vim
lua require'finder'.command()
```

#### With custom opts

Custom opts are passed as lua tables.

```vim
lua require'finder'.command{<opts>}
```

Example:

```vim
lua require'finder'.files{preview_disabled = true, height = 24}
```

Example mapping:
```vim
nnoremap <leader>p <cmd>lua require'finder'.files{}<CR>
```


## Currently supported commands

- **Files**

   Search through all files in directory.

   Call: 
   ``:lua require'finder'.files{}``

## Custom Opts
These are custom opts supported by every nvim-finder command:

### cwd [string]
Directory from which command will be launched. By default vim's current working
directory is used.

Example: ``cwd = '/home/user/.config/nvim'``

### preview_disabled [boolean]
Decides if preview will be disabled for the command. Doesn't effect when
command doesn't support preview. Default is false.

Example: ``preview_disabled = true``

### height [integer]
Height of finder window.

Example: ``height = 24``

### width [integer]
Width of finder window.

Example: ``width = 24``

### mode [string]
Render mode of plugin. nvim-finder supports multiple rendering modes.

Supported rendering modes are:
- editor (default)
- split
- cursor (if preview is disabled)

Example: ``mode = 'split'``

### init_text [string]
Initial text with which plugin would start.

Example: ``init_text = 'somefile.cc'``

### sorter [sorter's instance] [See [popfix](https://github.com/RishabhRD/popfix)]
Custom sorter for command. Sorter changes the way plugin sorts the result
according to current prompt text.
You can pick some predefined sorter from popfix's builtin sorters or can have
you own sorter. To read about sorter see [popfix](https://github.com/RishabhRD/popfix)

By default fzy native sorter is used.

Example: ``sorter = require'popfix.sorter'.new_fzy_soter()``


## Contribute

Raise an issue or create a PR if you feel some important command is missing.
This is possible that some commands are missing because they may not be in
my workflow. :smiley:

If you feel there is any bug in fuzzy engine, please raise an issue in
[popfix issues](https://github.com/RishabhRD/popfix/issues).

If you feel working of any command is not proper please make an issue here or
create a PR.
