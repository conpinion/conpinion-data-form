Polymer

  is: 'conpinion-data-form'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    resource: {type: Object}
    model: {type: String, value: 'model'}
    router: {type: Object}
    closeRoute: {type: String}

  ready: ->
    @fields = []
    for field in Polymer.dom(@).children
      if field.nodeName == 'conpinion-DATA-FIELDSET'
        for fieldsetField in Polymer.dom(field).children
          if @_isDataField fieldsetField
            @fields.push @_initField(fieldsetField)
      else if @_isDataField field
        @fields.push @_initField(field)

  attached: ->
    @fieldsByName = @fields.reduce ((acc, field) -> acc[field.name] = field; acc), {}

  load: (href) ->
    if !@resource || !href || href == ''
      @item = {}
      if @fields
        @_loadField field for field in @fields
        @_clearFieldErrors
    else
      @resource.show(href).then (success) =>
        @item = success.data
        @_loadField field for field in @fields
        @_clearFieldErrors
      , (error) =>
        @.fire 'conpinion-data-form-error', error.data

  save: ->
    if @item.href
      @resource.update(@item.href, @item).then (success) =>
        @.closeForm()
      , (error) =>
        @_setFieldErrors error.data.error.errors
        @.fire 'conpinion-data-form-error', error.data
    else
      @resource.create(@item).then (success) =>
        @.closeForm()
      , (error) =>
        @_setFieldErrors error.data.error.errors
        @.fire 'conpinion-data-form-error', error.data

  cancel: ->
    @closeForm()

  closeForm: ->
    if @closeRoute
      @router.go @closeRoute
    else
      @fire 'conpinion-data-form-close'

  _isDataField: (elem) ->
    elem.nodeName.startsWith('conpinion-') && elem.nodeName.endsWith('-FIELD')

  _initField: (field) ->
    field.model = @model
    field

  _loadField: (field) ->
    # add empty objects to @item for missing fields resource path segments
    resource_path = field.name.split('.')
    if resource_path.length > 1
      resource_path.splice -1, 1
      (@item[path_segment] = {}) for path_segment in resource_path when !@item[path_segment]
    field.item = @item

  _setFieldErrors: (errors) ->
    @_clearFieldErrors
    @fieldsByName[error.attribute]?.error = error.message for error in errors

  _clearFieldErrors: ->
    field.error = null for field in @fields
