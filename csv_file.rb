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

  def has_column_by_name(name)
    @headers.include? name
  end

  def has_column_by_idx(idx)
    idx >= 0 and idx < @headers.count
  end

  def is_number_idx(col_id)
    true if Integer(col_id) rescue false
  end

  def has_such_column(col_id)
    if  !is_number_idx(col_id)
      has_column_by_name(col_id)
    else
      has_column_by_idx(Integer(col_id))
    end
  end

  def has_such_row(row_idx)
    if is_number_idx(row_idx) then
      row_idx.to_i >= 0 and row_idx.to_i < @row_count
    else
      false
    end
  end

  def get_error_values
    return ['Error:'].to_json, [['Bad range parameters: no such row/column']].to_json
  end

  def get_col_index(col_id)
    idx = Integer(col_id) if is_number_idx(col_id)
    idx = @headers.include? col_id ? @headers.index(col_id).to_i : -1 unless is_number_idx(col_id)
    idx
  end

  def get_row_index(row_idx)
    idx = (is_number_idx(row_idx) ? Integer(row_idx) : -1)
    idx
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
    if !(has_such_column(col_idx1) and
         has_such_column(col_idx2) and
         has_such_row(row_idx1) and
         has_such_row(row_idx2) )
      get_error_values
    else
      headers, range = get_array_range(get_row_index(row_idx1), get_col_index(col_idx1), get_row_index(row_idx2), get_col_index(col_idx2))
      return headers.to_json, range.to_json
    end
  end

  def get_column(col_id)
    idx = get_col_index(col_id)
    get_range(0, idx, @row_count - 1, idx)
  end

  def get_row(row_idx)
    idx = get_row_index(row_idx)
    get_range(idx, 0, idx, @col_count - 1)
  end

  def get_file
    get_range(0, 0, @row_count - 1, @col_count - 1)
  end

  def edit_cell(row_idx, col_idx, value)
    table[row_idx, col_idx] = value
    get_file
  end



end