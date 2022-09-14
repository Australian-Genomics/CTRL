require_relative 'seeds_lib'

path = Rails.root.join('db', 'data.yml')
records_array = YAML::load_file(path)
records = replace_records(records_array)

puts "
=============================
RECORDS CREATED SUCCESSFULLY:
============================="
records.each do |record|
  puts
  pp record
end
