require 'json'
require 'csv'

json_file = File.open('data.json', 'r')
orgs = JSON.parse(json_file.read)
json_file.close

CSV.open("data.csv", "wb") do |csv|

  csv << ['key', 'current_name', 'other_names',
    'abbreviations', 'format',
    'start_date', 'end_date',
    'parents']


  orgs.each do |org|

    csv << [
      org['key'] ,
      org['current_name'],
      Array(org['other_names']).join('\n'),
      Array(org['abbreviations']).join(', '),
      org['format'],
      org['start_date'],
      org['end_date'],
      Array(org['parents']).join(', ')
    ]

  end
end