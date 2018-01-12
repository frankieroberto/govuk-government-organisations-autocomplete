# govuk-government-organisations-autocomplete

This is an autocomplete for UK Government organisations.

The code is built on top of the [accessible-autocomplete](https://github.com/alphagov/accessible-autocomplete) component, 
using data from both the [government-organisation register](https://government-organisation.register.gov.uk) and the 
(GOV.UK organisations API)[https://www.gov.uk/api/organisations]. This allows the autocomplete to be searched using 
previous names for organisations as well as abbreviations (eg 'DfE').

[View demo](/examples)

## Source data

* [View source data as JSON](data.json) – this is what is actually used by the code.
* [View source data as CSV](data.csv) - easier to view on GitHub.

The source data contains the following fields:

* `key` - primary key. This is taken from either the [register](https://government-organisation.register.gov.uk), or the `analytics_key` from the (GOV.UK API)[https://www.gov.uk/api/organisations] if the organisation isn’t in the register.
* `current_name` - the current official name of the organisation
* `other_name` - this includes previous names for the organisation, as well as some spelling variants
* `abbreviations` – any abbreviations for the organisation (eg `DfT` for the Department of Transport).
* `start_date` - date or year organisation started (`null` implies unknown).
* `end_date` - date or year organisation ended (`null` implies that the organisation still operates).
* `format` - status of the organisation within Government, eg 'Ministerial department' or 'Executive agency'.
* `parents` - the keys of any parent organisation (eg the Department that an Agency belongs to, or is sponsored by).
