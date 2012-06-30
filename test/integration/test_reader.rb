$:.unshift File.expand_path("../../lib")
require 'tabular_data'
require 'test/unit'

class Entry
    attr_accessor :a, :b
    ATTRIBUTES = [:a, :b]
end

class TestEntry < Test::Unit::TestCase

    def setup
        @reader = TabularData::Reader.new(Entry::ATTRIBUTES)
        @entry = Entry.new
    end
    
    def test_csv_strategy
        @reader.strategy = :csv
        @reader.read(@entry, "first;second")
        assert_equal "first", @entry.a
        assert_equal "second", @entry.b
    end
    
    def test_csv_strategy_setting_delimiter
        strategy = TabularData::Strategies::CSVStrategy.new
        strategy.column_delimiter = "|"
        @reader.strategy = strategy
        
        @reader.read(@entry, "first|second")
        assert_equal "first", @entry.a
        assert_equal "second", @entry.b
    end
    
    def test_array_strategy
        @reader.strategy = :array
        @reader.read(@entry, ["first","second"])
        assert_equal "first", @entry.a
        assert_equal "second", @entry.b
    end
    
    def test_anonymous_strategy
        @reader.strategy = lambda do |context, attributes_to_parse, attributes|
            attributes_to_parse = [attributes_to_parse[0..2], attributes_to_parse[3..5]]
            attributes.each_with_index do |attribute, i|
                context.send "#{attribute}=", attributes_to_parse[i]
            end
        end
        @reader.read(@entry, "1st2nd")
        assert_equal "1st", @entry.a
        assert_equal "2nd", @entry.b
    end
    
    def test_parse_lines
        entries = TabularData.parse_lines("first;second\n1st;2nd",
                                           Entry::ATTRIBUTES,
                                           lambda{ Entry.new })
        assert_equal "first", entries[0].a
        assert_equal "second", entries[0].b
        assert_equal "1st", entries[1].a
        assert_equal "2nd", entries[1].b
    end
    
    def test_parse_csv
        require 'fileutils'
        FileUtils.mkdir("temp") unless File.exists?("temp")
        File.open("temp/entries.csv", "w") do |f|
            f << "first;second\n1st;2nd"
        end
        
        entries = TabularData.parse_csv("temp/entries.csv",
                                         Entry::ATTRIBUTES,
                                         lambda { Entry.new })
        assert_equal "first", entries[0].a
        assert_equal "second", entries[0].b
        assert_equal "1st", entries[1].a
        assert_equal "2nd", entries[1].b
        
        FileUtils.rm_rf("temp")
    end
    
    def test_default_strategy
        @reader.read(@entry, "first;second")
        assert_equal "first", @entry.a
        assert_equal "second", @entry.b   
    end
end
