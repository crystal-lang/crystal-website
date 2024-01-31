{ pkgs, ... }:

{
  languages.ruby.enable = true;

  # This is required to fix encoding errors in Jekyll.
  # `encode': "\\xC3" from ASCII-8BIT to UTF-8 (Encoding::UndefinedConversionError)
  env.RUBYOPT = "-Eutf-8";

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
