module TrafficSpy

  class BaseModel

    def initialize params
      params.each {|name, value| instance_variable_set(name.instanceize, value)}
    end

    def valid?
      data.columns.inject(true) do |valid, column|
        if column != :id
          !send(column).nil? && valid
        else
          valid
        end
      end
    end

    def invalid?
      not valid?
    end

    def exists?
      id.nil? ? false : (!data.where(id: id).empty?)
    end

    def save
      raise ArgumentError if invalid? || exists?

      values = data.columns.each_with_object({}) do |column, hash|
        hash[column] = send(column)
      end
      @id = data.insert(values)

      return self
    end


    def data
      self.class.data
    end

    def self.data
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
          new data.where(column => val).first
        end
      end
    end

    def == (other)
      if other.kind_of? self.class
        data.columns.inject(true) do |equal, column|
          (send(column) == other.send(column)) && equal
        end
      else
        false
      end
    end

    def self.table_name
      "#{name.demodulize.underscore}s".to_sym
    end

  end
end

