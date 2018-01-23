require 'json'

json_file = File.open('data.json', 'r')
orgs = JSON.parse(json_file.read)
json_file.close

File.open("options.html", "wb") do |file|

  groups = [
    {label: 'Ministerial departments', formats: ['Ministerial department']},
    {label: 'Executive offices', formats: ['Executive office']},
    {label: 'Non-ministerial departments', formats: ['Non-ministerial department']},
    {label: 'Executive agencies', formats: ['Executive agency']},
    {label: 'Other bodies', formats: ['Executive non-departmental public body','Executive non-departmental public body','Advisory non-departmental public body','Sub-organisation', 'Ad-hoc advisory group','Other']},
    {label: 'Courts and Tribunals', formats: ['Court', 'Tribunal non-departmental public body']},
    {label: 'Civil Service', formats: ['Civil Service']},
    {label: 'Devolved administrations', formats: ['Devolved administration']},
    {label: 'Public corporations', formats: ['Public corporation']},
    {label: 'Independent bodies', formats: ['Independent monitoring body']}
  ]


  groups.each do |group|
    file.write "<optgroup label=\"#{group[:label]}\">\n"

    orgs.select {|org| group[:formats].include?(org['format']) && org['end_date'] == nil }
      .sort_by {|org| org['current_name'] }
      .each do |org|


      if org['abbreviations'] && org['abbreviations'].size > 0
        data_abbeviations = "data-abbreviations=\"#{org['abbreviations'].join('|')}\""
      end

      if org['other_names'] && org['other_names'].size > 0
        data_other_names = "data-other-names=\"#{org['other_names'].join('|')}\""
      end

      file.write("  <option value=\"#{org['key']}\" #{data_abbeviations} #{data_other_names}>#{org['current_name'].gsub('&', '&amp;')}</option>\n")
    end

    file.write "</optgroup>\n"
  end

end