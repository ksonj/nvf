{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;

  cfg = config.vim.languages.helm;
in {
  options.vim.languages.helm = {
    enable = mkEnableOption "Helm support";

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
    {
      vim.startPlugins = ["vim-helm"];
    }
    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.helm-ls = ''
        lspconfig.helm_ls.setup {
          capabilities = capabilities,
          on_attach=default_on_attach,
          cmd = {"${cfg.lsp.package}/bin/helm_ls", "serve"},
          filetypes = {"helm","yaml","yml","tpl"},
        }
      '';
    })
  ]);
}
