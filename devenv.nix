{ pkgs, ... }:

{
  languages.ruby = {
    enable = true;
    package = pkgs.ruby_3_4;
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
    # TODO: We don't run mdsf automatically with git-hooks due to several issue:
    # - mdsf itself has critical bugs (e.g. https://github.com/hougesen/mdsf/issues/1702)
    # - mdsf has no mechanism to exclude or disable specific files or lines
    # - some code blocks use Crystal syntax highlighting but are not valid syntax,
    #   which fails the formatter (e.g. they are excerpts or use outdated syntax)
    # - mdsf only reports failure of a formatter, but without details. That makes
    #   it hard to find and fix the problems.
    mdsf
    rufo
    shfmt
  ]);

  processes.serve.exec = "make serve";

  git-hooks.hooks = {
    actionlint.enable = true;
    check-toml.enable = true;
    lychee = {
      enable = true;
      settings = {
        flags = "--no-progress";
      };
    };
    prettier = {
      enable = true;
      settings = {
        write = true;
      };
    };
    rumdl.enable = true;
    typos.enable = true;
  };

  dotenv.enable = true;
}
