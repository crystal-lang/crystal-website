{ pkgs, ... }:

{
  languages.ruby.enable = true;

  processes.serve.exec = "make serve";

  enterShell = ''
    # Automatically run bundler upon enterting the shell.
    bundle install --quiet
  '';

  pre-commit.hooks = {
    markdownlint.enable = true;
    prettier.enable = true;
  };
}
