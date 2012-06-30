# TabularData

A library for parsing tabular data.

## Installation

Add this line to your application's Gemfile:

    gem 'tabular_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tabular_data

## Usage


```ruby
class Person

    ATTRIBUTES = [:name, :age]
    
    attr_accessor *ATTRIBUTES
end

reader = TabularData::Reader.new(Person::ATTRIBUTES)
person = reader.read(Person.new, "Marcos;23")

person.name
=> "Marcos"

person.age
=> "23"
```

### Changing strategies

```ruby
reader.strategy = :array
person = reader.read(Person.new, ["Marcos", 23])

person.name
=> "Marcos"

person.age
=> 23

custom_csv = TabularData::Strategies::CSVStrategy.new
custom_csv.column_delimiter = "|"
reader.strategy = custom_csv

person = reader.read(Person.new, "Marcos|23")

person.name
=> "Marcos"

person.age
=> "23"

reader.strategy = lambda do |context, attributes_to_parse, attributes|
    attributes_to_parse = [attributes[0..3], attributes_to_parse[4..5]]
    attributes.each_with_index do |attribute, i|
        context.send "#{attribute}=", attributes_to_parse[i]
    end
end

person = reader.read(Person.new, "Marc23")

person.name
=> "Marc"

person.age
=> "23"
```

### Useful methods

```ruby
people = TabularData.parse_csv("people_data.csv", Person::ATTRIBUTES, Person.method(:new))

people = TabularData.parse_lines("Marcos;23\nFelipe;25", Person::ATTRIBUTES, Person.method(:new))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
