
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
  '-------'
  puts JSON.parse(current_table)[0].is_a? Array
  puts JSON.parse(current_table)[0]
  #puts tmp_headers.is_a? Array
  redirect '/csv_table_view' #, locals: {:csv_headers => tmp_headers, :csv_table => tmp_table}
end

get '/get_column' do
  erb :'get_column'
end

post '/get_column' do
  puts params[:column_name]
  current_headers, current_table = my_csv.get_column(params[:column_name])
  redirect '/csv_table_view'
end

get '/csv_table_view' do
  if params[:type] == 'all'
    current_headers, current_table = my_csv.get_file
  end
  erb :'csv_table_view', locals: {:csv_headers => current_headers, :csv_table => current_table}
end