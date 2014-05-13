module.exports =
  activate: (state) ->
    atom.workspaceView.command "atom-erb:erb", => @erb()

  erb: ->
    editor = atom.workspaceView.getActiveView().getEditor()
    [curr_r, curr_c] = editor.getCursorBufferPosition().toArray()
    origin_selected_text = editor.getSelectedText()
    origin_select_range = editor.getSelectedBufferRange()

    editor.moveCursorToBeginningOfLine()
    editor.selectToEndOfLine()
    line = editor.getSelectedText()
    # console.log(line)
    reg = /\<%(.)([^%]+?)(-)*%\>/
    matchs = line.match(reg)
    if matchs
      replace_with_start = " "
      replace_with_end = ""
      matcher = matchs[1]
      if matcher == "="
        replace_with_start = "-"
        replace_with_end = "-"
      if matcher == "-"
        replace_with_start = ""
        curr_c -= 1
      if matcher == " "
        replace_with_start = "= "
        curr_c += 1
      # console.log(replace_with_start)
      line = line.replace(reg, "<%" + replace_with_start + "$2" + replace_with_end + "%>")
      # console.log(line)
      editor.insertText(line)
      editor.setCursorBufferPosition([curr_r, curr_c])
    else
      editor.setCursorBufferPosition([curr_r, curr_c])
      editor.setSelectedBufferRange(origin_select_range)
      editor.insertText("<%= " + origin_selected_text + " %>")
      editor.setCursorBufferPosition([curr_r, curr_c + 4])
