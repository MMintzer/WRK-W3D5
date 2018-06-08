require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
      table = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{table_name}"
      SQL
    @columns = table.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |col|
      define_method("#{col}") do 
        attributes[col]
      end  
      
      define_method("#{col}=") do |arg| 
        attributes[col] = arg 
      end 
    end 
  end

  def self.table_name=(table_name)
    chars = table_name.chars
    new_name = ''
    chars.each_with_index do |char, i|
      next if i == chars.length - 1 
      if chars[i + 1] == chars[i + 1].upcase 
        new_name << "#{char}_"
      else 
        new_name << char.downcase 
      end 
    end 
    
    new_name << chars.last 
    @table_name = new_name 
  end

  def self.table_name
    chars = self.to_s.chars 
    new_name = ''
    chars.each_with_index do |char, i|
      next if i == chars.length - 1 
      if chars[i + 1] == chars[i + 1].upcase 
        new_name << "#{char}_"
      else 
        new_name << char.downcase 
      end 
    end 
    
    new_name << chars.last 
    new_name << "s"
  end

  def self.all
    tables = DBConnection.execute(<<-SQL, arg1, arg2, ...)
    SQL
  end 

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |key, value|
      
      if self.class.columns.include?(key)
        self.send("#{key}=", value)
      else 
        raise "unknown attribute '#{key.to_s}'"
      end 
    end 
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # attributes 
    # @attributes.values 
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
