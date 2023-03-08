Crystal Website
===============
Powered by [Jekyll](https://jekyllrb.com/)

## Development setup (via docker)

- Checkout the repository
- Run `$ docker-compose up`
- Open a browser in `localhost:4000`

The docker container will launch jekyll with `--incremental` option.

## Development setup (Nix)

- Checkout the repository
- Run `$ nix-shell`
- Open a browser in `localhost:4000`

## Development setup (Devenv)

Using [devenv](https://devenv.sh)

- Checkout the repository
- Run `devenv up` to start a local web server
- Open a browser in `localhost:4000`
- Run `devenv shell` to get a shell with all development environment

## Thanks!

As always, thanks to the community who contributes to Crystal and its infrastructure and projects.

## License

Crystal is licensed under the Apache License, Version 2.0
