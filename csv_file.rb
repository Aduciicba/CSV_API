require 'csv'
require 'json'

class CSV_file
  attr_accessor :headers
  attr_accessor :table
  attr_reader :row_count
  attr_reader :col_count

  def initialize(path, separator)
    @headers, @table = Array.new, Array.new
    fill_file_data(path, separator)
  end

  def fill_file_data(path, separator)
    i = 1
    CSV.foreach(path, { :col_sep => separator, encoding: 'UTF-8' }) do |row|
    if i == 1
      @headers = row.to_a
    else
      @table << row.to_a
    end
    i = i + 1
    end
    @row_count = i - 2
    @col_count = @headers.count
  end

   def get_array_range(row_idx1, col_idx1, row_idx2, col_idx2)
    range_table = Array.new
    #puts row_idx1, col_idx1, row_idx2, col_idx2

    (row_idx1 ..row_idx2).each {|i|
      row_arr = Array.new
      (col_idx1..col_idx2).each {|j|
        row_arr << @table[i][j]
      }
      range_table << row_arr
    }

    range_headers = Array.new
    (col_idx1..col_idx2).each {|j|
      range_headers << @headers[j]
    }

    return range_headers, range_table
  end

  def get_range(row_idx1, col_idx1, row_idx2, col_idx2)
    headers, range = get_array_range(row_idx1, col_idx1, row_idx2, col_idx2)
    return headers.to_json, range.to_json
  end

  def get_column(col_idx)
    idx = 0

    if col_idx.is_a? String
      idx = @headers.index(col_idx).to_i
    else
      idx = col_idx.to_i
    end
    puts col_idx, idx, idx.class
    get_range(0, idx, @row_count - 1, idx)
  end

  def get_row(row_idx)
    get_range(row_idx, 0, row_idx, @col_count - 1)
  end

  def get_file
    get_range(0, 0, @row_count - 1, @col_count - 1)
  end

  def edit_cell(row_idx, col_idx, value)
    table[row_idx, col_idx] = value
    get_file
  end



end