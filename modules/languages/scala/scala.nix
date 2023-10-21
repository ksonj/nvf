{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.languages.scala = {
    enable = mkEnableOption "scala";
    metals = mkOption {
      type = types.package;
      default = pkgs.metals;
      description = ''
        metals package to use
      '';
    };
    dap = {
      enable = mkOption {
        description = "Enable Scala Debug Adapter";
        type = types.bool;
        default = config.vim.languages.enableDAP;
      };
      config = mkOption {
        description = "Lua configuration for dap";
        type = types.str;
        default = ''
          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        '';
      };
    };
    treesitter = {
      enable = mkOption {
        description = "Enable Scala Treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = mkOption {
        type = types.package;
        description = "Tree sitter grammar to use for Scala";
        default = pkgs.vimPlugins.nvim-treesitter.builtGrammars.scala;
      };
    };
    mappings = {
      listCommands = mkMappingOption "List Metals commands" "<leader>lc";
    };
  };
}
