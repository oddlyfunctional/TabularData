$:.unshift File.expand_path("../../lib")
require 'tabular_data'
require 'test/unit'

class TestEntry < Test::Unit::TestCase

    def setup
        @entry_class = Class.new(TabularData::Entry) do
            attr_accessor :a,:b
            def attributes
                [:a, :b]
            end
        end
    end    
    
    def test_csv_strategy
        @entry_class.strategy = :csv
        entry = @entry_class.new("first;second")
        assert_equal "first", entry.a
        assert_equal "second", entry.b
    end
    
    def test_csv_strategy_setting_delimiter
        strategy = TabularData::Strategies::CSVStrategy.new
        strategy.column_delimiter = "|"
        @entry_class.strategy = strategy
        
        entry = @entry_class.new("first|second")
        assert_equal "first", entry.a
        assert_equal "second", entry.b
    end
    
    def test_array_strategy
        @entry_class.strategy = :array
        entry = @entry_class.new(["first","second"])
        assert_equal "first", entry.a
        assert_equal "second", entry.b
    end
    
    def test_anonymous_strategy
        @entry_class.strategy = lambda do |context, attributes|
            attributes = [attributes[0..2], attributes[3..5]]
            context.attributes.each_with_index do |attribute, i|
                context.send attribute.to_s + "=", attributes[i]
            end
        end
        entry = @entry_class.new("1st2nd")
        assert_equal "1st", entry.a
        assert_equal "2nd", entry.b
    end
end
