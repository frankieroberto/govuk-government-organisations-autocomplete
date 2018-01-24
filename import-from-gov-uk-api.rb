require 'open-uri'
require 'json'

url = 'https://www.gov.uk/api/organisations'

govuk_orgs = []

parent_relations = []


while url != nil do

  puts url
  data = open(url).read
  json = JSON.parse(data)


  url = json['next_page_url']


  json['results'].each do |result|

    govuk_orgs << {
      'govuk_analytics_identifier' => result['analytics_identifier'],
      'title' => result['title'].to_s.strip,
      'govuk_id' => result['id'],
      'url' => result['web_url'],
      'current_name_logo_formatted' => result['details']['logo_formatted_name'],
      'abbreviation' => result['details']['abbreviation'],
      'format' => result['format'],
      'status' => result['details']['govuk_status'],
      'closed_at' => result['closed_at'],
      'parents' => []
    }

    result['parent_organisations'].each do |parent|
      parent_relations << {'child_id' => result['id'], 'parent_id'=> parent['id']}
    end

  end

end


parent_relations.each do |relation|

  child_org = govuk_orgs.detect {|govuk_org| govuk_org['govuk_id'] == relation['child_id'] }
  parent_org = govuk_orgs.detect {|govuk_org| govuk_org['govuk_id'] == relation['parent_id'] }
  child_org['parents'] << parent_org['govuk_analytics_identifier']

end


json_file = File.open('data.json', 'r')

existing_orgs = JSON.parse(json_file.read)

json_file.close


govuk_orgs.each do |govuk_org|

  existing_org = existing_orgs.detect do |existing_org|
    (existing_org['key'] == govuk_org['govuk_analytics_identifier']) ||
    (existing_org['current_name'] == govuk_org['title'])
  end

  if existing_org == nil

    existing_org = {
      'key' => govuk_org['govuk_analytics_identifier'],
      'current_name' => govuk_org['title'],
      'other_names' => [],
      'start_date' => nil,
      'end_date' => nil
    }
    existing_orgs << existing_org
  end

  if existing_org['current_name'] != govuk_org['title'] &&
    !Array(existing_org['other_names']).include?(govuk_org['title'])

    Array(existing_org['other_names']) << govuk_org['title']
  end

  abbreviations = (existing_org['abbreviations'].to_a + [govuk_org['abbreviation']]).uniq.compact.reject(&:empty?).sort

  if abbreviations.size > 0
    existing_org['abbreviations'] = abbreviations
  end

  existing_org['format'] = govuk_org['format']
  existing_org['parents'] = govuk_org['parents']

  if existing_org['end_date'].nil? && govuk_org['closed_at']
    existing_org['end_date'] = govuk_org['closed_at']

  elsif existing_org['end_date'].nil? && govuk_org['status'] == 'closed'
    existing_org['end_date'] = "unknown"
  end


  logo_formatted_name = govuk_org['current_name_logo_formatted'].gsub(/[\n\r]/, ' ').squeeze(' ').strip

  if existing_org['name'] != logo_formatted_name && !existing_org['other_names'].include?(logo_formatted_name)

    existing_org['other_names'] << logo_formatted_name
  end

  existing_org['other_names'] = existing_org['other_names'].collect {|name| name.gsub(/[\n\r]/, ' ').squeeze(' ') }

  existing_org['other_names'] = (existing_org['other_names'] - [existing_org['current_name']]).uniq.sort

end

json_file = File.open('data.json', 'w')


json_file.write JSON.pretty_generate(existing_orgs.sort_by {|org| org['key'] })

json_file.close

