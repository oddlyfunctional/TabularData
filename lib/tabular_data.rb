module TabularData
    module Strategies
        class ReaderStrategy

            def call(context, attributes)
                attributes = separate_attributes(attributes)
                context.attributes.each_with_index do |attribute, i|
				    context.send(attribute.to_s + "=", attributes[i])
			    end
            end
            
            def separate_attributes(attributes)
                raise NotImplementedError.new("Not implemented yet.")
            end
        end
        
        class CSVStrategy < ReaderStrategy
        
            attr_accessor :column_delimiter
        
            def column_delimiter
                @column_delimiter ||= ";"
            end
            
            def separate_attributes(line)
                line.split(column_delimiter)
            end
        end
        
        class ArrayStrategy < ReaderStrategy
            
            def separate_attributes(attributes)
                attributes
            end
        end
        
    end


    class Entry
    
        def self.strategy
            @strategy ||= TabularData::Strategies::CSVStrategy.new
        end
        
        def self.strategy=(str)
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
	        read_attributes(attributes)
        end
        
        def attributes
            raise NotImplementedError.new("You must implement this method to return the attributes you want to read from the given string.")
        end
        
        def self.read_lines(lines)
            objects = []
            lines = lines.split("\n") if lines.is_a? String
            lines.each do |line|
                objects << new(line)
            end
            objects
        end

	    private
		    def read_attributes(attributes)
		        self.class.strategy.call(self, attributes)
		    end
    end
end
