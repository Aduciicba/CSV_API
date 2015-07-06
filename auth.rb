require 'json'

class Auth

  attr_accessor :counter

  def initialize(login, password)
    @login, @password = login, password
  end

  def check_authorization
    json_users_data = fill_json_from_config
    @has_such_user = false
    @is_correct_password = false

    json_users_data['users_auth_data'].each { |user|
      if user['login'].to_s == @login
        @has_such_user = true
        @is_correct_password = true if user['password'].to_s == @password
        break
      end
    }
    @has_such_user and @is_correct_password
  end

  def open_config_file(file_name)
    File.read(file_name)
  end

  def fill_json_from_config(file_name = Dir.pwd + '\config.json')
    JSON.parse(open_config_file(file_name))
  end
end

