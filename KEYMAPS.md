# Neovim Keymaps Cheat Sheet

## Basic Editing

| Key                | Action                 |
| ------------------ | ---------------------- |
| `x`                | Delete without yanking |
| `+`                | Increment number       |
| `-`                | Decrement number       |
| `<C-a>`            | Select all             |
| `jk` (insert mode) | Exit to normal mode    |

## File Management

| Key          | Action               |
| ------------ | -------------------- |
| `<Leader>w`  | Save file            |
| `<Leader>q`  | Quit                 |
| `<Leader>Q`  | Quit all             |
| `<Leader>f`  | Find file in tree    |
| `<Leader>e`  | Toggle file explorer |
| `<Leader>fe` | Focus file explorer  |

## Tabs

| Key       | Action       |
| --------- | ------------ |
| `te`      | New tab      |
| `<Tab>`   | Next tab     |
| `<S-Tab>` | Previous tab |
| `tw`      | Close tab    |

## Window Management

| Key            | Action               |
| -------------- | -------------------- |
| `ss`           | Horizontal split     |
| `sv`           | Vertical split       |
| `sh`           | Move to left window  |
| `sk`           | Move to up window    |
| `sj`           | Move to down window  |
| `sl`           | Move to right window |
| `<C-w><left>`  | Decrease width       |
| `<C-w><right>` | Increase width       |
| `<C-w><up>`    | Increase height      |
| `<C-w><down>`  | Decrease height      |

## Movement

| Key     | Action                     |
| ------- | -------------------------- |
| `H`     | Jump to start of line      |
| `L`     | Jump to end of line        |
| `J`     | Jump to next paragraph     |
| `KK`    | Jump to previous paragraph |
| `<C-;>` | Hop to word                |

## LSP

| Key  | Action               |
| ---- | -------------------- |
| `gi` | Go to implementation |

## Diagnostics

| Key          | Action                  |
| ------------ | ----------------------- |
| `<C-j>`      | Next diagnostic         |
| `<S-j>`      | Previous diagnostic     |
| `<Leader>cy` | Copy diagnostic message |
