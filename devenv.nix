{ pkgs, ... }:

{
  languages.ruby = {
    enable = true;
    package = pkgs.ruby_3_3;
  };

  # This is required to fix encoding errors in Jekyll.
  # `encode': "\\xC3" from ASCII-8BIT to UTF-8 (Encoding::UndefinedConversionError)
  env.RUBYOPT = "-Eutf-8";

  languages.crystal.enable = true;

  packages = (with pkgs; [
    htmltest
  ]);

  processes.serve.exec = "make serve";

  enterShell = ''
    # Automatically run bundler upon enterting the shell.
    bundle install --quiet
  '';

  pre-commit.hooks = {
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
}
