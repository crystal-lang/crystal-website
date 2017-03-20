Crystal Website
===============
Powered by [Jekyll](https://jekyllrb.com/)

## Development setup

- Checkout the repository
- Check the Ruby version in `.travis.yml` and make sure you're using it
- Run `bundle install`
- Start the server with `bundle exec jekyll serve`
- Open a broswer in `localhost:4000`

or to build without starting it: `bundle exec jekyll build`

### Troubleshooting

#### `An error occurred while installing libv8 (3.16.14.11)`

```
gem install therubyracer -v '0.12.2'
gem install libv8 -v '3.16.14.11' -- --with-system-v8
```

Then retry from the `bundle install` step.

## Thanks!

As always, thanks to the community who contributes to Crystal and its infrastructure and projects.

## License

Crystal is licensed under the Apache License, Version 2.0
