Polymer
  is: 'conpinion-data-select-field'

  behaviors: [conpinionDataFieldBehavior]

  properties:
    selectables: {type: Array, notify: true, value: -> []}
    simpleItems: {type: Boolean, value: false},
    itemIdProperty: {type: String, value: 'id'}
    itemLabelProperty: {type: String, value: 'label'}
    maximum: {type: Number, value: null}

  _itemAttribute: (item, field) ->
    itemAttribute = field.split('.').reduce(((o, x) -> o[x]), item)
    itemAttribute ?= []
    if (itemAttribute instanceof Array) then itemAttribute else [itemAttribute]

  _onSelectedChanged: (e) ->
    value = e.detail.value
    return unless value
    @set 'item.' + this.name, if @maximum == 1 then value[0] else value
