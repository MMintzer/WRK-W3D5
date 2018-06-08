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
        #{table_name}
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
    tables = DBConnection.execute(<<-SQL)
    SELECT 
      *
    FROM 
      #{table_name}
    SQL
    # debugger
    parse_all(tables)
  end 

  def self.parse_all(results)
    results.map do |hash|
      self.new(hash)
    end 
  end

  def self.find(id)
    table = DBConnection.execute(<<-SQL, id)
    SELECT 
      *
    FROM
      #{table_name}
    WHERE 
      id = ?
    LIMIT 
      1
    SQL
    
    parse_all(table).first
    # debugger
  end

  def initialize(params = {})
    params.each do |key, value|
      
      if self.class.columns.include?(key.to_sym)
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
    attributes.map {|k,v| v}
  end

  def insert
    # debugger
    question_marks = ['?'] * attributes.length
    col_names = attributes.keys.join(',')
    # debugger
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO 
    #{table_name} (col_names)
    VALUES 
    question_marks
    SQL
    # last_insert_row_id
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
