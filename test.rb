require 'csv'

file = CSV.read('f:/test_file.csv', { :col_sep => ';', headers: true })


puts file["City"]