id = 1

root = exports ? this

conpinionDataFieldBehaviorImpl =

  properties:
    name: {type: String, value: "#{id++}"}
    label: {type: String, value: ''}
    model: {type: String, value: ''}
    description: {type: String}
    item: {type: Object}
    error: {type: String}

  _hasError: (error) ->
    error?

  _itemAttribute: (item, field) ->
    field.split('.').reduce(((o, x) -> o[x]), item)

  _fieldLabel: (name, label, model) ->
    if label then label
    else @i18n "attributes.#{model}.#{name}"


root.conpinionDataFieldBehavior = [Grapp.I18NJsBehavior, conpinionDataFieldBehaviorImpl]
