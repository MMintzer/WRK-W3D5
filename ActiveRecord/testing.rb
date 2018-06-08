def table_name_fixer(table_name)
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
end