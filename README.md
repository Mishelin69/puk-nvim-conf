# puk-nvim-conf

A personal Neovim configuration powered by **Packer**, **Treesitter**, and **Mason** for modern development.

---

## 🚀 Requirements

Before installing, make sure you have:

1. **Neovim 0.11 or higher**

   * ⚠️ Do **NOT** install from your distro's `apt` (too outdated).
   * Instead, install from the official [Neovim GitHub releases](https://github.com/neovim/neovim/releases).

2. **Packer.nvim** (plugin manager)

   * Follow installation instructions here: [packer.nvim](https://github.com/wbthomason/packer.nvim)

---

## 📦 Installation

1. Create a Neovim config directory if it doesn’t exist:

   ```bash
   mkdir -p ~/.config/nvim
   ```

2. Clone this repository:

   ```bash
   git clone https://github.com/Mishelin69/puk-nvim-conf.git
   ```

3. Move the contents into your Neovim config directory:

   ```bash
   mv puk-nvim-conf/* ~/.config/nvim/
   ```

4. Launch Neovim:

   ```bash
   nvim
   ```

   * You may see some error messages the first time. Ignore them.

5. Inside Neovim, run:

   ```vim
   :PackerSync
   ```

   After the sync is done, **close and reopen Neovim**.

---

## 🛠 Language Support

This config uses **Treesitter** and **Mason** for language support.

1. **Install Treesitter parsers**

   * Run inside Neovim:

     ```vim
     :TSInstall <language>
     ```
   * Example: `:TSInstall python`, `:TSInstall cpp`
   * See the Treesitter docs for full language list.

2. **Install LSP servers with Mason**

   * Run inside Neovim:

     ```vim
     :Mason
     ```

     or

     ```vim
     :MasonInstall <lsp>
     ```
   * Example: `:MasonInstall pyright`, `:MasonInstall clangd`
   * Look up the correct LSP name for your language in the Mason window or its documentation. You can also install and update LSPs directly via the `:Mason` window.

3. **Configure LSPs**

   * Go to the `nvim/` folder and edit the file `invim/init.lua`.
   * Add entries like:

     ```lua
     vim.lsp.enable('pyright')
     vim.lsp.enable('clangd')
     ```
   * ⚠️ Check the [nvim-lspconfig repo](https://github.com/neovim/nvim-lspconfig) for the exact setup instructions for each LSP.

---

## 🔧 Optional Dependencies for Better Telescope.nvim Performance

Telescope.nvim works best with an efficient file finder and search backend. It’s **highly recommended** to install the following tools:

* **fd** (a fast, user‑friendly alternative to `find`):
  Install via your package manager or download from GitHub: [sharkdp/fd](https://github.com/sharkdp/fd)
  On Ubuntu/Debian, the package is called `fd-find`, and you can add an alias so it’s available as `fd`:

  ```bash
  sudo apt install fd-find
  alias fd=fdfind
  ```

* **ripgrep** (an extremely fast recursive search tool that respects `.gitignore`):
  Available on GitHub: [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
  Many distros provide it via package manager, e.g.:

  ```bash
  sudo apt install ripgrep
  # or
  brew install ripgrep
  ```

These tools allow Telescope to search files more quickly and efficiently, especially in large codebases.

---

## ✅ Done!

Now you have a modern Neovim setup with syntax highlighting, autocompletion, and LSP integration. 🎉

For updates, pull the latest changes and run `:PackerSync` again.

