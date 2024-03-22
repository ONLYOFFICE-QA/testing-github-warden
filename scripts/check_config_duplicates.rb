require 'yaml'

data = YAML.load_file('config/allowed_branches.yml')
all_repository_names = []
data.each do |entry|
  all_repository_names += entry[:repository_name_array]
end

duplicates = all_repository_names.select { |name| all_repository_names.count(name) > 1 }.uniq

if duplicates.empty?
  puts "No duplicates found in repository_name_array across all entries."
  exit 0
else
  puts "Duplicates found in repository_name_array across all entries: #{duplicates.join(', ')}"
  exit 1
end
