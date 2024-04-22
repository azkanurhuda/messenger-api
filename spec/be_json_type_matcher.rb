RSpec::Matchers.define :be_json_type do |expected|
  match do |actual|
    match_json_structure_helper(expected, actual)
  end

  def match_json_structure_helper(expected, actual)
    expected.each do |key, value|
      if value.is_a?(Hash)
        return false unless actual.is_a?(Hash) && actual.key?(key)
        return false unless match_json_structure_helper(value, actual[key])
      elsif value == []
        return false unless actual[key] == []
      elsif value.kind_of?(Array)
        return false unless match_json_structure_helper(value.first, actual[key].first)
      else
        return false unless actual.is_a?(Hash) && actual.key?(key) && (actual[key] == value ||actual[key].is_a?(value))
      end
    end
    true
  end
end