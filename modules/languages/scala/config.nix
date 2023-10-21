{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.scala;
  usingLualine = config.vim.statusline.lualine.enable;
  usingDap = config.vim.debugger.nvim-dap.enable;
  self = import ./scala.nix {inherit config lib pkgs;};

  mappingDefinitions = self.options.vim.languages.scala.mappings;
  mappings = addDescriptionsToMappings cfg.mappings mappingDefinitions;

  mkBinding = binding: action: "vim.api.nvim_buf_set_keymap(bufnr, 'n', '${binding.value}', '<cmd>lua ${action}<CR>', {noremap=true, silent=true, desc='${binding.description}'})";
in {
  config = mkIf cfg.enable (
    mkMerge [
      (mkIf usingLualine {
        vim.statusline.lualine.extraActiveSection.c = ["'g:metals_status'"];
      })
      (mkIf cfg.treesitter.enable {
        vim.treesitter.enable = true;
        vim.treesitter.grammars = [cfg.treesitter.package];
      })
      (mkIf cfg.dap.enable {
        vim.debugger.nvim-dap.enable = true;
        vim.debugger.nvim-dap.sources.scala = cfg.dap.config;
      })
      {
        vim.startPlugins = ["nvim-metals"];
        vim.luaConfigRC.nvim-metals = nvim.dag.entryAfter ["lsp-setup"] ''
          -- Scala nvim-metals config
          local metals_caps = capabilities  -- from lsp-setup

          local attach_metals_keymaps = function(client, bufnr)
            attach_keymaps(client, bufnr)  -- from lsp-setup
            ${
            if config.vim.telescope.enable
            then mkBinding mappings.listCommands ''require("telescope").extensions.metals.commands()''
            else mkBinding mappings.listCommands ''require("metals").commands()''
          }
          end

          metals_config = require('metals').bare_config()
          ${optionalString usingLualine "metals_config.init_options.statusBarProvider = 'on'"}

          metals_config.capabilities = metals_caps
          metals_config.on_attach = function(client, bufnr)
            ${optionalString usingDap "require('metals').setup_dap()"}
            attach_metals_keymaps(client, bufnr)
          end
          metals_config.settings = {
             metalsBinaryPath = "${cfg.metals}/bin/metals",
             showImplicitArguments = true,
             showImplicitConversionsAndClasses = true,
             showInferredType = true,
             excludedPackages = {
               "akka.actor.typed.javadsl",
               "com.github.swagger.akka.javadsl"
             },

          }

          metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
              virtual_text = {
                prefix = '',
              }
            }
          )


          -- without doing this, autocommands that deal with filetypes prohibit messages from being shown
          vim.opt_global.shortmess:remove("F")

          vim.cmd([[augroup lsp]])
          vim.cmd([[autocmd!]])
          vim.cmd([[autocmd FileType java,scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
          vim.cmd([[augroup end]])
        '';
      }
    ]
  );
}
