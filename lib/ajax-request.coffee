$ = require('jquery')

AjaxRequestView = require './ajax-request-view'
{CompositeDisposable} = require 'atom'

module.exports = AjaxRequest =
  AjaxRequestView: null
  setUpPanel: null

  activate: (state) ->
    @AjaxRequestView = new AjaxRequestView(state.AjaxRequestViewState)
    @setUpPanel = atom.workspace.addBottomPanel(item: @AjaxRequestView.getRoot(), visible: false)

    atom.commands.add 'atom-workspace', 'ajax-request:toggle': => @toggle()

    # Listener on Ajax buttons
    @AjaxRequestView.getBtnAjaxGet().addEventListener "click", (e) => @btnAjaxEvent('GET')
    @AjaxRequestView.getBtnAjaxPost().addEventListener "click", (e) => @btnAjaxEvent('POST')

  deactivate: ->
    @setUpPanel.destroy()
    @subscriptions.dispose()
    @AjaxRequestView.destroy()

  serialize: ->
    AjaxRequestViewState: @AjaxRequestView.serialize()

  toggle: ->
      if(!@setUpPanel.isVisible())
          @setUpPanel.show()
      else
          @setUpPanel.hide()

  setApiWeather: ->

  btnAjaxEvent:(method = 'GET') ->
    url = @AjaxRequestView.getUrl()
    param = @AjaxRequestView.getData()
    data = @sendAjax(url, param, method)

  sendAjax:(url, param, method) ->
    response = null
    $.ajax
        url: url
        type: method
        data: param
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
            "AJAX Error: #{textStatus}"
        success: (data) =>
            @AjaxRequestView.setTextResult(data)
