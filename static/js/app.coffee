React = require 'react'
ReactDOM = require 'react-dom'
ObjectEditor = require 'object-editor'
Kefir = require 'kefir'
KefirBus = require 'kefir-bus'
nalgene = require 'nalgene'
NalgeneEditor = require './editor'

require './reload-client'

template = require './template'

# template = '''
# %
#     hi there $name
# '''
context = {
    $food_place: "Pizza Hut"
    $device: "kitchen light"
    $state: "on"
}

_template$ = KefirBus()
template$ = KefirBus()
context$ = KefirBus()
refresh$ = KefirBus()
refreshing$ = Kefir.merge [
    refresh$.map -> true
    refresh$.delay(300).map -> false
]

template$ = _template$.debounce(200)

delayedUpdateTemplate = (template) ->
    _template$.emit template

updateContext = (context) ->
    context$.emit context

refresh = ->
    refresh$.emit new Date().getTime()

NalgenePreview = ({template, context, refresh}) ->
    try
        grammar = nalgene.parse template
        <p>{nalgene.generate grammar, context, '%', {skip_duplicates: true}}</p>
    catch e
        <p style={color: 'red'}>{e.toString()}</p>

Refresher = React.createClass
    getInitialState: -> {refreshing: false}
    componentDidMount: ->
        refreshing$.onValue @setRefreshing
    setRefreshing: (refreshing) ->
        @setState {refreshing}
    render: ->
        className = 'refresh'
        if @state.refreshing
            className += ' refreshing'
        <a className=className onClick=refresh><i className='fa fa-refresh' /></a>

App = React.createClass
    getInitialState: -> {template, context}

    componentDidMount: ->
        template$.onValue @setTemplate
        context$.onValue @setContext
        refresh$.onValue @setRefresh

    setTemplate: (template) ->
        @setState {template}

    setContext: (context) ->
        @setState {context}

    setRefresh: (refresh) ->
        @setState {refresh}

    render: ->
        <div>
            <div className='content'>
                <NalgeneEditor template=@state.template onChange=delayedUpdateTemplate />
            </div>
            <div className='sidebar'>
                <h2>Context</h2>
                <ObjectEditor object={@state.context} onSave=updateContext />
                <div className='row'>
                    <h2>Generated</h2>
                    <Refresher />
                </div>
                <NalgenePreview template=@state.template context=@state.context refresh=refresh />
            </div>
        </div>

ReactDOM.render <App />, document.getElementById 'app'
