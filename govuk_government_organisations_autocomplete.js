


var govukGovernmentOrganisationsAutocomplete = function(options) {

  var req = new XMLHttpRequest();
  req.addEventListener('load', function() {

    var organisations = JSON.parse(this.responseText)

    var formatSortOrder = ['Ministerial department', 'Non-ministerial department', 'Executive agency']

    var organisationsThatStillExist = organisations.filter(function(organisation) {
      return organisation.end_date == null
    })

    var sortedOrganisations = organisationsThatStillExist.sort(function(orgA, orgB) {

      var indexA = formatSortOrder.indexOf(orgA.format)
      var indexB = formatSortOrder.indexOf(orgB.format)

      indexA = (indexA > -1 ? indexA : 9999)
      indexB = (indexB > -1 ? indexB : 9999)

      if (indexA < indexB) {
        return -1
      } else if (indexA > indexB) {
        return 1
      } else {
        return (orgA.current_name < orgB.current_name ? -1 : 1)
      }

    })


    var sourceSelect = function(query, callback) {

      var regex = new RegExp('\\b' + query, 'i')

      var matches = sortedOrganisations.map(function(organisation) {

        var allNames = [organisation.current_name]
          .concat(organisation.other_names)
          .concat(organisation.abbreviations)
          .filter(function(name) { return name })

        organisation['resultPosition'] = null


        for (var i = 0; i < allNames.length; i++) {

          var matchPosition = allNames[i].search(regex)

          if (matchPosition > -1 && (organisation['resultPosition'] == null || matchPosition < organisation['resultPosition'])) {
            organisation['resultPosition'] = matchPosition
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


    accessibleAutocomplete.enhanceSelectElement({
      selectElement: options['selectElement'],
      showAllValues: options['showAllValues'],
      defaultValue: options['defaultValue'],
      source: sourceSelect
    })


  })
  req.open('GET', options['sourceUrl'])
  req.send()

}
