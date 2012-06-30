module TabularData

    def self.parse_lines(lines, attributes, factory, column_delimiter = ";")
        lines = lines.split("\n") if lines.is_a? String
        
        reader = TabularData::Reader.new(attributes)
        reader.strategy = TabularData::Strategies::CSVStrategy.new(column_delimiter)
        
        entries = []
        lines.each do |line|
            entries << reader.read(factory.call, line.strip)
        end
        entries
    end
    
    def self.parse_csv(path, attributes, factory, column_delimiter = ";")
        parse_lines File.open(path, "r").readlines, attributes, factory, column_delimiter
    end

    module Strategies
        class ReaderStrategy

            def call(context, attributes_to_parse, attributes)
                attributes_to_parse = parse_attributes(attributes_to_parse)
                attributes.each_with_index do |attribute, i|
				    context.send "#{attribute}=", attributes_to_parse[i]
			    end
            end
            
            def parse_attributes(attributes)
                raise NotImplementedError.new("Not implemented yet.")
            end
        end
        
        class CSVStrategy < ReaderStrategy
        
            attr_accessor :column_delimiter
            
            def initialize(column_delimiter = ";")
                @column_delimiter = column_delimiter
            end
        
            def column_delimiter
                @column_delimiter
            end
            
            def parse_attributes(line)
                line.split(column_delimiter)
            end
        end
        
        class ArrayStrategy < ReaderStrategy
            
            def parse_attributes(attributes)
                attributes
            end
        end
        
    end

    class Reader
    
        def strategy
            @strategy ||= TabularData::Strategies::CSVStrategy.new
        end
        
        def strategy=(str)
            if str.is_a? Symbol
                case str
                    when :csv then @strategy = TabularData::Strategies::CSVStrategy.new
                    when :array then @strategy = TabularData::Strategies::ArrayStrategy.new
                end
            else
                @strategy = str
            end
        end

        def initialize(attributes)
	        @attributes = attributes
        end
        
        def read(entry, attributes_to_parse)
            strategy.call(entry, attributes_to_parse, @attributes)
            entry
        end

    end
end
