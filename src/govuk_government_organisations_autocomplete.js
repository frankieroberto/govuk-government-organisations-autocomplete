


var govukGovernmentOrganisationsAutocomplete = function(options) {

  var sourceSelect = function(query, callback) {

    var optionsWithAValue = [].filter.call(options.selectElement.options, function(option) {
      return option.value != ''
    })

    var orgs = optionsWithAValue.map(function(select) {

      var dataAbbreviations = select.getAttribute('data-abbreviations');
      dataAbbreviations = dataAbbreviations ? dataAbbreviations.split('|') : []

      var dataOtherNames = select.getAttribute('data-other-names');
      dataOtherNames = dataOtherNames ? dataOtherNames.split('|') : []

      return {
        'current_name': select.label,
        'abbreviations': dataAbbreviations,
        'other_names': dataOtherNames
      }
    })

    var regexes = query.trim().split(/\s+/).map(function(word) {
      return new RegExp('\\b' + word, 'i')
    })

    var matches = orgs.map(function(organisation) {

      var allNames = [organisation.current_name]
        .concat(organisation.other_names)
        .concat(organisation.abbreviations)
        .filter(function(name) { return name })

      organisation['resultPosition'] = null


      for (var i = 0; i < allNames.length; i++) {

        var matches = regexes.reduce(function(acc, regex) {

          matchPosition = allNames[i].search(regex)
          if (matchPosition > -1) {
            acc.count += 1

            if (acc.lowestPosition == -1 || matchPosition < acc.lowestPosition) {
              acc.lowestPosition = matchPosition
            }
          }

          return acc;

        }, {'count': 0, 'lowestPosition': -1})


        if (matches.count == regexes.length && (organisation['resultPosition'] == null || matches.lowestPosition < organisation['resultPosition'])) {
          organisation['resultPosition'] = matches.lowestPosition
        }
      }

      return organisation

    })

    var filteredMatches = matches.filter(function(organisation) {
      return (organisation['resultPosition'] != null )
    })

    var sortedFilteredMatches = filteredMatches.sort(function(organisationA, organisationB) {

      if (organisationA['resultPosition'] < organisationB['resultPosition'] ) {
        return -1
      } else if (organisationA['resultPosition'] > organisationB['resultPosition'] ) {
        return 1
      } else {
        return 0
      }
    })

    var results = sortedFilteredMatches.map(function(organisation) { return organisation['current_name'] })

    return callback(results)
  }


  options.source = sourceSelect

  accessibleAutocomplete.enhanceSelectElement(options)

}
