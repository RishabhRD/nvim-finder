# nvim-finder
nvim-finder is a fuzzy finder built upon
[popfix](https://github.com/RishabhRD/popfix) fuzzy engine. This
repository is a bundle of commands for fuzzy finding various things in neovim.

Popfix's fuzzy engine abstraction is highly extensible and purely written in
lua. Infact, it is possible to use different fuzzy engines for different jobs.
One of the major goal of popfix's default fuzzy engine is to remain
responsive even for big jobs with a good visual performance.

![](https://user-images.githubusercontent.com/26287448/101091071-ab205700-35dd-11eb-8f28-00bcf6ec63c7.gif)

## Installation

Install it as any other plugin. For example with vim-plug:

- Add this to your init.vim:
   ```vim
   Plug 'RishabhRD/popfix'
   Plug 'RishabhRD/nvim-finder'
   ```
- After re-sorurcing init.vim
   ```vim
   :PlugInstall
   ```

## Invoking plugin

### Using vimscript commands

nvim-finder ships a ``Finder`` command. Any nvim-finder function can be invoked using:

```vim
:Finder command init_text
```

command is the function needed to be invoked (like files, git_files, grep, etc).
Tab-completion would also list all the commands available in nvim-finder.

init_text is the initial prompt text with which nvim-finder would be launched.
If not provided, then nvim-finder would launch with no initial prompt text (the
default behavior).

Example:

This would launch file searcher (default behavior) :

```vim
:Finder files
```

This would launch file searcher with ``init.vim`` as initital prompt text:

```vim
:Finder files init.vim
```

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

- **Git Files**

   Iterate through git ls-files in directory.

   Call: 
   ``:lua require'finder'.git_files{}``

- **Fuzzy Grep**

   Grep through all your files in directory with fuzzy finding.

   Call: 
   ``:lua require'finder'.fuzzy_grep{}``

- **Grep**
   
   Grep through all your files in directory with plain search.

   Call: 
   ``:lua require'finder'.grep{}``

   **Why to use when fuzzy grep is there ?**

   Because of performance. In large directory, fuzzy finding all things would
   take time. This command is not built upon default fuzzy engine of popfix
   so maybe not as responsive as default command in large directory. However,
   it would search what you want quite fast.

   If you want to contribute to the fuzzy engine for this command make a PR in
   popfix repository.

- **Buffers**

   Search through all your open buffers with live buffer preview.

   Call: 
   ``:lua require'finder'.buffers{}``

- **Help Tags**

   Search through all your help tags. Easy help.

   Call:
  ``:lua require'finder'.help_tags{}``

- **File types**

   Search through the file type and set the filetype for the current buffer.

   Call:
  ``:lua require'finder'.filetypes{}``

- **Commands**

   Search through all commands currently loaded in neovim and execute them.

   Call:
  ``:lua require'finder'.commands{}``

- **Command History**

   Search through all commands history and execute them.

   Call:
  ``:lua require'finder'.command_history{}``

- **File History**

   Search through all file history and just open them right away.

   Call:
  ``:lua require'finder'.file_history{}``

- **Buffer Lines**

    Search through all current buffer lines.

    Call:
    ``:lua require'finder'.buffer_lines{}``

- **Man Pages**

    Fuzzy search through all man pages.

    Call:
    ``:lua require'finder'.man_pages{}``

- **Finder Commands**

    Fuzzy search through all of the commands exported by nvim-finder itself.

    Call:
    ``:lua require'finder'.finder_commands{}``

## Enabling native sorter

popfix also ships an optional sorter 'native-fzy-sorter' as a separate git
submodule. This sorter is written in C and is very fast in compare to other
sorters. This gives a huge performance boost.

If you have enabled popfix's native-fzy-sorter (read popfix's README.md for
steps) then you can use this sorter as default sorter for nvim-finder using:

```lua
vim.g.enable_finder_native_sorter = true
```

## Custom Opts

These are custom opts supported by every nvim-finder command:

### cwd [string]

Directory from which command will be launched. By default vim's current working
directory is used.

Example: ``cwd = '/home/user/.config/nvim'``

### cmd [string]

Command used for find files in directory

Example: ``cmd = 'find .'``


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

Example: ``sorter = require'popfix.sorter':new_fzy_soter()``

## Custom Highlighting

nvim-finder exposes some highlight group that highlight different elements
of fuzzy window.

- **FinderListBorder**

Border color of nvim-finder's list window

- **FinderPreviewBorder**

Border color of nvim-finder's preview window

- **FinderPromptBorder**

Border color of nvim-finder's prompt window

- **FinderListHighlight**

Defines foreground and background color of list.

- **FinderPreviewHighlight**

Defines foreground and background color of preview.

- **FinderPromptHighlight**

Defines foreground and background color of prompt window.

- **FinderListSelection**

Defines the appearance of selected list element.

- **FinderListMatch**

Defines the appearance of list characters that match with current prompt text.

- **FinderPromptCommand**

Defines the appearance of prompt string (default prompt command is >)

- **FinderPreviewLine**

Defines the appearance of highlighted line in preview window.

## Contribute

Raise an issue or create a PR if you feel some important command is missing.
This is possible that some commands are missing because they may not be in
my workflow. :smiley:

If you feel there is any bug in fuzzy engine, please raise an issue in
[popfix issues](https://github.com/RishabhRD/popfix/issues).

If you feel working of any command is not proper please make an issue here or
create a PR.
