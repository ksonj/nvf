{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) nvim mkEnableOption mkOption types mkIf mkMerge;

  cfg = config.vim.languages.helm;
in {
  options.vim.languages.helm = {
    enable = mkEnableOption "Helm support";

    treesitter = {
      enable = mkEnableOption "Helm treesitter" // {default = config.vim.languages.enableTreesitter;};
      package = nvim.types.mkGrammarOption pkgs "helm";
    };

    lsp = {
      enable = mkEnableOption "Helm LSP support (helm-ls)" // {default = config.vim.languages.enableLSP;};

      package = mkOption {
        description = "helm-ls package";
        type = with types; package;
        default = pkgs.helm-ls;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.package];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.helm-ls = ''
        lspconfig.helm_ls.setup {
          capabilities = capabilities,
          on_attach=default_on_attach,
          cmd = {"${cfg.lsp.package}/bin/helm-ls", "serve"},
        }
      '';
    })
  ]);
}
