module TabularData
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
        
            def column_delimiter
                @column_delimiter ||= ";"
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
            @strategy.call(entry, attributes_to_parse, @attributes)
        end
        
        def self.read_lines(lines)
            objects = []
            lines = lines.split("\n") if lines.is_a? String
            lines.each do |line|
                objects << new(line)
            end
            objects
        end
    end
end
