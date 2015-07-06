
require 'sinatra'
require 'json'
require_relative 'csv_file'

my_csv = nil;
current_headers, current_table = nil, nil

get '/' do
  "Hello, guy! Let's <a href=""/auth"">authorizing</a> and start working!"
end

get '/auth' do
  erb :'authorization'
end

post '/auth' do
  puts params
  my_csv = CSV_file.new('f:/test_file.csv', ';')
  current_headers, current_table = my_csv.get_file
  redirect '/what_to_do'
end

get '/what_to_do' do
  "<strong>Now you can get some JSON data: </strong><br>" +
  "1. To open some csv with ; separator go to /open_file?path=your path <br>" +
  "2. To get some column put /get_column_json?column_name=your column name or index <br>" +
  "3. To get some row put /get_row_json?row_number=your row_number <br>" +
  "4. To get range put /get_range_json?row1={range left corner row_number};col1={range left corner col_number};row2={range right corner row_number};col2={range right corner col_number}; <br>" +
  "or go to <a href=""/csv_table_view"">csv table view</a>.."
end


get '/open_file' do
  if params.has_key?('path')
    my_csv = CSV_file.new(params[:path], ';')
    'Opened failed, sorry:(' if my_csv == nil
    "Opened file #{params[:path]} success" if my_csv != nil
    my_csv.get_file
  else
    "No 'path' parameter. Puts path=<path to file> to the get query"
  end
end

get '/get_column_json' do
  if params.has_key?('column_name')
    puts params[:column_name]
    my_csv.get_column(params[:column_name])
  else
    "No 'column_name' parameter. Puts column_name=<column name or index> to the get query"
  end
end

get '/get_row_json' do
  if params.has_key?('row_number')
    puts params[:row_number]
    my_csv.get_row(params[:row_number])
  else
    "No 'row_number' parameter. Puts row_number=<row_number> to the get query"
  end
end

get '/get_range_json' do
  puts params
  if params.has_key?('row1') and
     params.has_key?('col1') and
     params.has_key?('row2') and
     params.has_key?('col2')
    my_csv.get_range(params[:row1], params[:col1], params[:row2], params[:col2])
  else
    "Something wrong with parameters:( We need row1, col1, row2, col2 values in the get query"
  end
end

get '/get_row' do
  if params.count == 0
    erb :'get_row'
  else
    current_headers, current_table = my_csv.get_row(params[:row_number])
    redirect '/csv_table_view'
  end
end

get '/get_column' do
  if params.count == 0
    erb :'get_column'
  else
    current_headers, current_table = my_csv.get_column(params[:column_name])
    redirect '/csv_table_view'
  end
end

get '/get_range' do
  if params.count == 0
    erb :'get_range'
  else
    puts params
    current_headers, current_table = my_csv.get_range(params[:row1], params[:col1], params[:row2], params[:col2])
    redirect '/csv_table_view'
  end
end

get '/csv_table_view' do
  if params[:type] == 'all'
    current_headers, current_table = my_csv.get_file
  end
  erb :'csv_table_view', locals: {:csv_headers => current_headers, :csv_table => current_table}
end