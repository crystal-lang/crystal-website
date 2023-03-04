{ pkgs, ... }:

{
  languages.ruby.enable = true;

  processes.serve.exec = "make serve";

  pre-commit.hooks = {
    markdownlint.enable = true;
    prettier.enable = true;
  };
}
