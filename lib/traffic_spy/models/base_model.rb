module TrafficSpy

  class BaseModel

    def initialize params
      params.each {|name, value| instance_variable_set(name.instanceize, value)}
    end

    def valid?
      data.columns.each_with_object(true) do |column, valid|

      end
    end

    def self.data
      puts "getting data"
      DB.from(table_name)
    end

    def self.inherited subclass
      subclass.define_find_by_methods
      subclass.define_with_attr_reader
    end

    def self.define_with_attr_reader
      data.columns.each { |column| attr_reader column}
    end

    def self.define_find_by_methods
      data.columns.each do |column|
        define_singleton_method("find_by_#{column}") do |val|
          data.where(column_name => val)
        end
      end
    end

    def self.table_name
      "#{name.demodulize.underscore}s".to_sym
    end

  end
end

