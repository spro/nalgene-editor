React = require 'react'
{Editor, EditorState, ContentState, CompositeDecorator, Modifier} = require 'draft-js'

TAB = '    '

matchRegex = (regex, contentBlock, callback, contentState) ->
    text = contentBlock.getText()
    while match_arr = regex.exec text
        start = match_arr.index
        callback start, start + match_arr[0].length

phrase_regex = /%[\w-]*/g
variable_regex = /\$[\w-]+/g
synonym_regex = /~[\w-]+/g

phraseStrategy = (contentBlock, callback, contentState) ->
    matchRegex phrase_regex, contentBlock, callback, contentState

PhraseSpan = ({children}) ->
    <span className='phrase'>{children}</span>

variableStrategy = (contentBlock, callback, contentState) ->
    matchRegex variable_regex, contentBlock, callback, contentState

VariableSpan = ({children}) ->
    <span className='variable'>{children}</span>

synonymStrategy = (contentBlock, callback, contentState) ->
    matchRegex synonym_regex, contentBlock, callback, contentState

SynonymSpan = ({children}) ->
    <span className='synonym'>{children}</span>

compositeDecorator = new CompositeDecorator [{
    strategy: phraseStrategy
    component: PhraseSpan
}, {
    strategy: variableStrategy
    component: VariableSpan
}, {
    strategy: synonymStrategy
    component: SynonymSpan
}]

# Editor transformations
# ------------------------------------------------------------------------------

addSplit = (editor_state) ->
    EditorState.push editor_state,
        Modifier.splitBlock(
            editor_state.getCurrentContent(),
            editor_state.getSelection()
        )
    , 'split-block'

addTab = (editor_state) ->
    EditorState.push editor_state,
        Modifier.replaceText(
            editor_state.getCurrentContent(),
            editor_state.getSelection(),
            TAB
        )
    , 'insert-characters'

deleteToStart = (editor_state) ->
    EditorState.push editor_state,
        Modifier.removeRange(
            editor_state.getCurrentContent(),
            editor_state.getSelection().merge({anchorOffset: 0}),
            'backward'
        )
    , 'remove-range'

# Main editor
# ------------------------------------------------------------------------------

module.exports = NalgeneEditor = React.createClass

    getInitialState: ->
        editor_state: EditorState.createWithContent ContentState.createFromText(@props.template), compositeDecorator

    onChange: (editor_state) ->
        window.es = editor_state
        @props.onChange editor_state.getCurrentContent().getPlainText()
        @setState {editor_state}

    handleKeyCommand: (command) ->
        if command == 'split-block'
            @doSplit()
        else if command == 'backspace'
            @doBackspace()

    currentBlock: ->
        k = @state.editor_state.getSelection().getFocusKey()
        @state.editor_state.getCurrentContent().getBlockForKey(k)

    doSplit: ->
        line = @currentBlock().getText()
        if line.match /^    /
            editor_state = addTab addSplit @state.editor_state
            @setState {editor_state}
            return 'handled'

    doBackspace: ->
        if @state.editor_state.getSelection().getStartOffset() == 4
            editor_state = deleteToStart @state.editor_state
            @setState {editor_state}
            return 'handled'

    onTab: (e) ->
        e.preventDefault()
        editor_state = addTab @state.editor_state
        @setState {editor_state}

    render: ->
        <Editor editorState=@state.editor_state onChange=@onChange onTab=@onTab handleKeyCommand=@handleKeyCommand />

