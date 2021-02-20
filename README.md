# JSON:API Serializer format module

A module to enrich [JSON:API Serializers](https://github.com/jsonapi-serializer) with configurable formats.

[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com)

## Installation

Add this line to your Gemfile:

```ruby
gem 'jsonapi-serializer-formats'
```

Execute:

```bash
$ bundle install
```

## Serializer extension

After the module is included in your existing serializer, the `format` keyword is now available for you to use


```ruby
class MovieSerializer
  include JSONAPI::Serializer
  include JSONAPI::Formats

  attributes :name

  format :detailed do
    attribute   :year
    attribute   :rating

    has_many :actors
  end
end
```

## Rendering

### Default behaviour

When no filter is specified, only the attributes declared at the root will be rendered.

```ruby
hash = MovieSerializer.new(movie).serializable_hash
```

Output

```json
{
  "data": {
    "id": "3",
    "type": "movie",
    "attributes": {
      "name": "pulp fiction"
    }
  }
}
```

## Specifying a format

When a format is specified during render, the attributes defined under that format will be included

```ruby
hash = MovieSerializer.new(movie, { params: { format: :detailed }}).serializable_hash
```

Output

```json
{
  "data": {
    "id": "3",
    "type": "movie",
    "attributes": {
      "name": "pulp fiction",
      "year": "1994",
      "rating": 5
    },
    "relationships": {
      "actors": {
        "data": [...]
      }
    }
  }
}
```

## Nested formats

You can nest formats one into another. A nested format will only render if **all** of its parent formats have been enabled during rendering

```ruby
class MovieSerializer
  include JSONAPI::Serializer
  include JSONAPI::Formats

  attributes :name

  format :detailed do
    attribute   :year

    format :admin do
      attribute :view_count
    end
  end
end
```

```ruby
hash = MovieSerializer.new(movie, { params: { format: [:detailed, :admin] } }).serializable_hash
```

Renders

```json
{
  "data": {
    "id": "3",
    "type": "movie",
    "attributes": {
      "name": "pulp fiction",
      "year": "1994",
      "view_count": 98776
    }
  }
}
```

## LICENSE

MIT License

Copyright (c) 2021 Patrick R

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

