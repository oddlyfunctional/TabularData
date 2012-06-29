# TabularData

A library for parsing tabular data.

## Usage

```ruby
class Person < TabularData::Entry
    attr_accessor :name, :age
    
    def attributes
        [:name, :age]
    end
end

person = Person.new("Marcos;23")

person.name
=> "Marcos"

person.age
=> "23"
```

### Changing strategies

```ruby
Person.strategy = :array
person = Person.new(["Marcos", 23])

person.name
=> "Marcos"

person.age
=> 23

custom_csv = TabularData::Strategies::CSVStrategy.new
custom_csv.column_delimiter = "|"
Person.strategy = custom_csv

person = Person.new("Marcos|23")

person.name
=> "Marcos"

person.age
=> "23"

Person.strategy = lambda do |context, attributes|
    attributes = [attributes[0..3], attributes[4..5]]
    context.attributes.each_with_index do |attribute, i|
        context.send "#{attribute}=", attributes[i]
    end
end

person = Person.new("Marc23")

person.name
=> "Marc"

person.age
=> "23"
```
