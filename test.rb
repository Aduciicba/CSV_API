require 'csv'
require 'json'
require_relative 'csv_file'

c = CSV_file.new('f:/test_file.csv', ';')
#a,b  = c.has_such_row('1yyy')

# j = JSON.parse(b)
# j.each do |row|
#   puts row.class
# end

puts Dir.pwd

#puts JSON.parse(b.to_json)[0].is_a? Array

__END__
j = JSON.parse(b)

j.each {|r|
  puts r.to_s.gsub('[', '').gsub(']', '').split(',')
  puts '-----------------'
}



i = 1
headers, table = Array.new, Array.new
CSV.foreach('f:/test_file.csv', { :col_sep => ';', encoding: 'UTF-8' }) do |row|
  if i == 1
    headers = row.to_a
  else
    table << row.to_a
  end
  i = i + 1
end

h = Array.new

table.each{ |r|
  sub_h = Hash.new
  (0..r.count - 1).each{|i|
    sub_h[headers[i]] = r[i]
  }
  h << sub_h

}

h2 = {:csv_data => h}

#puts JSON.parse(table.to_json)[1][1];
#puts a.to_json

