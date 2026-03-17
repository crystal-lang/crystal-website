{ pkgs, ... }:

{
  languages.ruby = {
    enable = true;
    package = pkgs.ruby_3_3;
    bundler.enable = true;
  };

  # This is required to fix encoding errors in Jekyll.
  # `encode': "\\xC3" from ASCII-8BIT to UTF-8 (Encoding::UndefinedConversionError)
  env.RUBYOPT = "-Eutf-8";

  languages.crystal = {
    enable = true;
    # The Crystal language configuration uses `crystalline` as LSP, but the
    # nix package seems to be temporarily broken.
    lsp.enable = false;
  };

  packages = (with pkgs; [
    htmltest
  ]);

  processes.serve.exec = "make serve";

  git-hooks.hooks = {
    actionlint.enable = true;
    lychee = {
      enable = true;
      settings = {
        flags = "--no-progress";
      };
    };
    markdownlint.enable = true;
    prettier = {
      enable = true;
      settings = {
        write = true;
      };
    };
    typos.enable = true;
  };

  dotenv.enable = true;
}
