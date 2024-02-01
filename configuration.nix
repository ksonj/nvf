inputs: let
  modulesWithInputs = import ./modules inputs;

  neovimConfiguration = {
    modules ? [],
    pkgs,
    lib ? pkgs.lib,
    check ? true,
    extraSpecialArgs ? {},
  }:
    modulesWithInputs {
      inherit pkgs lib check extraSpecialArgs;
      configuration.imports = modules;
    };

  tidalConfig = {
    config.vim.languages.tidal.enable = true;
  };

  mainConfig = isMaximal: {
    config = {
      vim = {
        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 20;
          logFile = "/tmp/nvim.log";
        };
      };

      vim.lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = isMaximal;
        trouble.enable = true;
        lspSignature.enable = true;
        lsplines.enable = isMaximal;
        nvim-docs-view.enable = isMaximal;
      };

      vim.debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };

      vim.languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        html.enable = isMaximal;
        css.enable = isMaximal;
        sql.enable = isMaximal;
        java.enable = isMaximal;
        ts.enable = isMaximal;
        svelte.enable = isMaximal;
        go.enable = isMaximal;
        zig.enable = isMaximal;
        python.enable = isMaximal;
        dart.enable = isMaximal;
        elixir.enable = isMaximal;
        bash.enable = isMaximal;
        terraform.enable = isMaximal;
        tailwind.enable = isMaximal;
        clang = {
          enable = isMaximal;
          lsp.server = "clangd";
        };

        rust = {
          enable = isMaximal;
          crates.enable = true;
        };
        scala.enable = isMaximal;
        helm.enable = isMaximal;
      };

      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        scrollBar.enable = true;
        smoothScroll.enable = true;
        cellularAutomaton.enable = false;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;

        indentBlankline = {
          enable = true;
          fillChar = null;
          eolChar = null;
          scope = {
            enabled = true;
          };
        };

        cursorline = {
          enable = true;
          lineTimeout = 0;
        };
      };

      vim.statusline = {
        lualine = {
          enable = true;
          theme = "catppuccin";
        };
      };

      vim.theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };
      vim.autopairs.enable = true;

      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };

      vim.filetree = {
        nvimTree = {
          enable = true;
        };
      };

      vim.tabline = {
        nvimBufferline.enable = true;
      };

      vim.treesitter.context.enable = true;

      vim.binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      vim.telescope.enable = true;

      vim.git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions = false; # throws an annoying debug message
      };

      vim.minimap = {
        minimap-vim.enable = false;
        codewindow.enable = isMaximal; # lighter, faster, and uses lua for configuration
      };

      vim.dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = isMaximal;
      };

      vim.notify = {
        nvim-notify.enable = true;
      };

      vim.projects = {
        project-nvim.enable = isMaximal;
      };

      vim.utility = {
        ccc.enable = isMaximal;
        vim-wakatime.enable = isMaximal;
        icon-picker.enable = isMaximal;
        surround.enable = isMaximal;
        diffview-nvim.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = true;
        };
      };

      vim.notes = {
        obsidian.enable = false; # FIXME neovim fails to build if obsidian is enabled
        orgmode.enable = false;
        mind-nvim.enable = isMaximal;
        todo-comments.enable = true;
      };

      vim.terminal = {
        toggleterm = {
          enable = true;
          lazygit.enable = true;
        };
      };

      vim.ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        modes-nvim.enable = false; # the theme looks terrible with catppuccin
        illuminate.enable = true;
        breadcrumbs = {
          enable = isMaximal;
          navbuddy.enable = isMaximal;
        };
        smartcolumn = {
          enable = true;
          columnAt.languages = {
            # this is a freeform module, it's `buftype = int;` for configuring column position
            nix = 110;
            ruby = 120;
            java = 130;
            go = [90 130];
          };
        };
      };

      vim.assistant = {
        copilot = {
          enable = isMaximal;
          cmp.enable = isMaximal;
        };
      };

      vim.session = {
        nvim-session-manager.enable = false;
      };

      vim.gestures = {
        gesture-nvim.enable = false;
      };

      vim.comments = {
        comment-nvim.enable = true;
      };

      vim.presence = {
        neocord.enable = true;
      };
    };
  };
in {
  inherit neovimConfiguration mainConfig tidalConfig;
}
