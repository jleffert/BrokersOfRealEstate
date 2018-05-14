module HousesHelper
  def humanize_abbreviated_list(abbreviation_hash, list)
    final_string = ""
    list = list.split(',')
    list.each do |item|
      final_string += "#{abbreviation_hash[item]}, "
    end

    return final_string.slice(0, final_string.length-2)
  end
end
