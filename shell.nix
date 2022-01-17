with import <nixpkgs> {};

let
  gems_env = bundlerEnv {
    name = "gems_env";
    ruby = ruby_3_1;
    gemdir = ./.;
  };
in
  mkShell {
    buildInputs = [ gems_env gems_env.wrappedRuby ];
    shellHook = ''
      exec ${gems_env}/bin/jekyll serve --incremental --livereload
    '';
  }
