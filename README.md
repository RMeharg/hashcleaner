# HashCleaner

Remove elements from a hash

## Installation

```
$ gem install hashcleaner
```

## Usage

```
$> yamlcleaner path/to/file.yml
```

yamlcleaner will iterate over the hash and remove fields containing:

1. `credential` equal to true and `value` containing `***`
1. `configurable` equal to false

## Contributing

1. Fork it
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create new Pull Request
