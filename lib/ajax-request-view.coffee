$ = require('jquery')
providers = require('../providers/ajax-provider').providers

module.exports =
class AjaxRequestView
  constructor: (serializedState) ->
    # Create root element
    @root = document.createElement('div')
    @root.classList.add('ajax-request')

    @element = document.createElement('div')
    @element.classList.add('half-left')

    pselect = document.createElement('p')
    selectAPI = document.createElement('select')
    option = document.createElement('option')
    option.value = 'null'
    option.textContent = 'Choose an API'
    selectAPI.appendChild(option)
    for key of providers
        option = document.createElement('option')
        option.value = option.textContent = key
        selectAPI.appendChild(option)
    selectAPI.addEventListener "change", (e) => @changeProvider(e)
    pselect.appendChild(selectAPI)
    @element.appendChild(pselect)

    p1 = document.createElement('p')

    # URL Input
    purl = document.createElement('label')
    purl.for = 'url'
    purl.textContent = 'URL : '
    purl.style.margin = '5px'
    p1.appendChild(purl)
    @url = document.createElement('input')
    @url.type = 'text'
    @url.id = 'url'
    @url.value = ''
    @url.size = 50
    @url.classList.add('native-key-bindings')
    p1.appendChild(@url)

    @element.appendChild(p1)


    p2 = document.createElement('p')
    p2.classList.add('listBtn')

    # "Add field" button
    @btnAddField = document.createElement('input')
    @btnAddField.type = "button"
    @btnAddField.value = "Add field"
    p2.appendChild(@btnAddField)
    @btnAddField.addEventListener "click", (e) => @addField()
    # "Delete field" button
    @btnDeleteField = document.createElement('input')
    @btnDeleteField.type = "button"
    @btnDeleteField.value = "Delete fields"
    p2.appendChild(@btnDeleteField)
    @btnDeleteField.addEventListener "click", (e) => @deleteAllFields()

    # "Clear" button
    @btnClear = document.createElement('input')
    @btnClear.type = "button"
    @btnClear.value = "Clear"
    p2.appendChild(@btnClear)
    @btnClear.addEventListener "click", (e) => @setTextResult()

    @element.appendChild(p2)

    p3 = document.createElement('p')
    p3.classList.add('listBtn')
    # "Ajax Get/Post" Button
    @btnAjaxGet = document.createElement('input')
    @btnAjaxGet.type = 'button'
    @btnAjaxGet.value = 'AJAX GET'
    p3.appendChild(@btnAjaxGet)
    @btnAjaxPost = document.createElement('input')
    @btnAjaxPost.type = 'button'
    @btnAjaxPost.value = 'AJAX POST'
    p3.appendChild(@btnAjaxPost)

    @element.appendChild(p3)

    # Creation of the table
    @table = document.createElement('table')
    @table.className = 'table-ajax'
    tr = document.createElement('tr')
    th1 = document.createElement('th')
    th1.textContent = 'Key'
    tr.appendChild(th1)
    th2 = document.createElement('th')
    th2.textContent = 'Input'
    tr.appendChild(th2)
    th3 = document.createElement('th')
    th3.textContent = 'Delete'
    tr.appendChild(th3)
    @table.appendChild(tr)
    @element.appendChild(@table)

    # Results
    @results = document.createElement('div')
    @results.classList.add('half-right')
    @results.classList.add('native-key-bindings')
    @textResult = document.createElement('p')
    @results.appendChild(@textResult)

    @root.appendChild(@element)
    @root.appendChild(@results)

  serialize: ->

  destroy: ->
    @root.remove()

  changeProvider:(e) ->
    if e.target.value != 'null'
        @setProvider(providers[e.target.value])

  setProvider:(provider) ->
    @deleteAllFields()
    @setUrl(provider.url)
    for val in provider.fields
        @addField(val.key, val.type, val.data, val.required)

  addField:(keyName = '', valueType = 'text', valueData = '', required = false) ->
    tr = document.createElement('tr')
    tr.className='field'

    # Input for the key
    td1 = document.createElement('td')
    td1.className = 'key'
    key = document.createElement('input')
    key.classList.add('native-key-bindings')
    key.value = keyName
    td1.appendChild(key)
    tr.appendChild(td1)

    # Input for the value
    td2 = document.createElement('td')
    td2.classList.add('value')
    valueInput = null
    switch valueType
        when 'text'
            valueInput = document.createElement('input')
            valueInput.type = 'text'
            valueInput.title = 'text'
            valueInput.value = valueData
            valueInput.classList.add('native-key-bindings')
        when 'integer'
            valueInput = document.createElement('input')
            valueInput.type = 'number'
            valueInput.title = 'number'
            valueInput.value = valueData
            valueInput.classList.add('native-key-bindings')
            #only allowing number
            valueInput.addEventListener "keypress", (e) => @checkNumeric(e)
            valueInput.addEventListener "change", (e) => @checkNumeric(e)
        when 'select'
            valueInput = document.createElement('select')
            for val in valueData
                option = document.createElement('option')
                option.value = option.textContent = val
                valueInput.appendChild(option)

    if required
      valueInput.classList.add('required')
    td2.appendChild(valueInput)
    tr.appendChild(td2)

    # Delete button
    td3 = document.createElement('td')
    deleteBtn = document.createElement('input')
    deleteBtn.type = 'button'
    deleteBtn.value = 'X'
    deleteBtn.addEventListener "click", (e) => @deleteField(e)
    td3.appendChild(deleteBtn)
    tr.appendChild(td3)

    @table.appendChild(tr)

  checkNumeric:(e) ->
    value = e.target.value
    number = parseInt(value)
    if isNaN(number)
        e.target.classList.add('error')
    else
        e.target.classList.remove('error')

  deleteField:(e) ->
    $(e.target).parent().parent().remove()

  deleteAllFields: ->
    $(@table).children('.field').each (index, element) ->
        $(element).remove()

  getData: ->
    data = {}
    $(@table).children('.field').each (index, element) ->
        key = $(element).children('.key').first().children().first().val()
        value = $(element).children('.value').first().children().first().val()
        if(key != '' && value != '' && value != null)
            data[key] = value
    data

  getTable: ->
    @table

  getRoot: ->
    @root

  getElement: ->
    @element

  getResults: ->
    @results

  getTextResult: ->
    @textResult

  toHTML:(input) ->
    html = '<ul class="base">'
    if typeof input is 'string'
        html += '<li class="base">' + input + '</li>'
    else
        for key of input
            if input[key] instanceof Object
                html += '<li class="base"><span class="key">' + key + '</span> <span class="base">:</span> <span class="value">' +  @toHTML(input[key]) + '</li>'
            else if Array.isArray(input[key])
                html += '<li class="base"><span class="key">' + key + '</span> <span class="base">:</span> <span class="value">' + @toHTML(JSON.stringify(input[key])) + '</li>'
            else
                html += '<li class="base"><span class="key">' + key + '</span> <span class="base">:</span> <span class="value">' + input[key] + '</li>'
    html += '</ul>'
    html


  setTextResult:(data = {}) ->
    @textResult.innerHTML = @toHTML(data)

  setUrl:(url) ->
    @url.value = url

  getUrl: ->
    @url.value

  getBtnAjaxGet: ->
    @btnAjaxGet

  getBtnAjaxPost: ->
    @btnAjaxPost
