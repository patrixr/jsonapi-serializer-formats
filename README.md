# JSON:API Serializer format module

A module to enrich [JSON:API Serializers](https://github.com/jsonapi-serializer) with configurable formats.

## Installation

Add this line to your Gemfile:

```ruby
gem 'jsonapi-serializer-formats'
```

Execute:

```bash
$ bundle install
```

### Serializer extension

After the module is included in your existing serializer, the `format` keyword is now available for you to use


```ruby
class MovieSerializer
  include JSONAPI::Serializer
  include JSONAPI::Formats

  attributes :name

  format :detailed do
    attribute   :year
    attribute   :rating
  end
end
```

### Rendering

#### Default behaviour

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

### Specifying a format

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
    }
  }
}
```
