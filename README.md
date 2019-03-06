# github-cr

[![Travis Build Status](https://travis-ci.org/arnavb/github-cr.svg?branch=master)](https://travis-ci.org/arnavb/github-cr)

A Github API wrapper for Crystal. Currently a work in progress, so don't use it for anything outside experimentation. Documentation is yet to be written.

## TODO:

- [ ] Turn `GithubCr::PaginatedResource` and `GithubCr::Page` into iterators.
- [ ] Create a config system and pass a config object to all methods/classes.
- [ ] Add tests for all classes and functions.
- [ ] Add documentation for all parts of the public API.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     github-cr:
       github: arnavb/github-cr
   ```

2. Run `shards install`

## Usage

```crystal
require "github-cr"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/arnavb/github-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Arnav Borborah](https://github.com/arnavb) - creator and maintainer
