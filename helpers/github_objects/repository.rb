# frozen_string_literal: true

class Repository
  attr_accessor :name, :full_name
  def initialize(params)
    @name = params['name']
    @full_name = params['full_name']
  end

  def check_name
    YAML.load_file('config/warden_config.yml').find_all do |current_pattern|
      Regexp.new(current_pattern[:repository_name_pattern]).match?(@name)
    end
  end
end
