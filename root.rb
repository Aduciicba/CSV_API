
require 'sinatra'
require 'csv'

csv_file = nil;

get '/' do
  "Hello, guy! Let's <a href=""/auth"">authorizing</a> and start working!"
end

get '/auth' do
  erb :'authorization'
end

post '/auth' do
  puts params
  csv_file = CSV.read('f:/test_file.csv', { :col_sep => ';', headers:true,  encoding: 'UTF-8' })#CSV.read('f:/test_file.csv', col_sep: "$", encoding: "UTF-8")
  redirect '/main_csv'
end

get '/get_column' do
  erb :'get_column'
end

post '/get_column' do
  puts params[:column_name]
  int = Integer(params[:column_name]) rescue nil
  range = nil
  puts int
  range = csv_file[params[:column_name].to_s] if int == nil
  range = csv_file[int] if int != nil
  puts range
  redirect '/main_csv', locals: {:csv_file => range}
end

get '/main_csv' do
  erb :'main_csv', locals: {:csv_file => csv_file}
end